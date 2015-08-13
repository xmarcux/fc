!**********************************************************************
!Copyright (C) 2015 Marcus Pedersén
!
!This program is free software: you can redistribute it and/or modify
!it under the terms of the GNU General Public License as published by
!the Free Software Foundation, either version 3 of the License, or
!(at your option) any later version.
!
!This program is distributed in the hope that it will be useful,
!but WITHOUT ANY WARRANTY; without even the implied warranty of
!MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!GNU General Public License for more details.
!
!You should have received a copy of the GNU General Public License
!along with this program.  If not, see <http://www.gnu.org/licenses/>.
!**********************************************************************

!This module contains functions that
!takes care of the comparing of files.

module comp
implicit none

contains

!Subroutine compares file 1 and 2 for equality
!row by row.
!If reportFile has the value "-1" report is written
!to terminal, else report will be written to file
!name in argument reportFile.
subroutine compFiles(compFile1, compFile2, reportFile)
    character(100), intent(inout) :: compFile1, compFile2
    character(100), intent(in) :: reportFile
    character(1000) :: filebuff1, filebuff2
    integer :: noFile1, noFile2, noEq, noNEq, iostat1, iostat2, iostat3
    logical :: reportToFile, fileExists

    reportToFile = .false.
    noFile1 = 0
    noFile2 = 0
    noEq = 0
    noNEq = 0

    compFile1 = getFileName(compFile1)
    compFile2 = getFileName(compFile2)

    open(unit=20, file=trim(compFile1), status='old', &
         action='read', position='rewind', iostat=iostat1)
    open(unit=21, file=trim(compFile2), status='old', &
         action='read', position='rewind', iostat=iostat2)

    if (trim(reportFile) /= "-1") then
        inquire(file=trim(reportFile),exist=fileExists)
        if (fileExists) then
            open(unit=22, file=trim(reportFile), status='old', &
                 action='write', position='rewind', iostat=iostat3)
        else
            open(unit=22, file=trim(reportFile), status='new', &
                 action='write', position='rewind', iostat=iostat3)
        end if

        reportToFile = .true.
    end if

    if (iostat1 == 0 .and. iostat2 == 0) then
        if (reportToFile .and. iostat3 /= 0) then
            write(*,'(/,3x,a)') "Error writing to report file."
            write(*,'(3x,a,/)') "Writing report to terminal:"
            reportToFile = .false.
        end if

        if (reportToFile) then
            write(*,'(/,3x,a)')    "########################################"
            write(*,'(3x,a,a)')     "Writing report to file: ", trim(reportFile)
            write(*,'(3x,a,/)')    "########################################"

            write(22,'(/,3x,a)')    "fc compare report."
            write(22,'(3x,a)')      "########################################"
            write(22,'(/,3x,a)')    "fc starting to compare files."
            write(22,'(3x,a)')      "----------------------------------------"
        else
            write(*,'(/,3x,a)')    "fc compare report."
            write(*,'(3x,a)')      "########################################"
            write(*,'(/,3x,a)')    "fc starting to compare files."
            write(*,'(3x,a)')      "----------------------------------------"
        end if

        do
            if (iostat1 == 0) then
                read(20,'(a)', iostat=iostat1) filebuff1
                if (iostat1 == 0) then
                    noFile1 = noFile1 + 1
                end if
            end if
            if (iostat2 == 0) then
                read(21,'(a)', iostat=iostat2) filebuff2
                if (iostat2 == 0) then
                    noFile2 = noFile2 + 1
                end if
            end if

            if (iostat1 == 0 .and. iostat2 == 0) then
                if (filebuff1 == filebuff2) then
                    noEq = noEq + 1
                 else
                    noNEq = noNEq + 1
                    if (reportToFile) then
                        write(22,'(/,3x,a)')    "****************************************"
                        write(22,'(3x,a,I7,a)') "Line number: ", noFile1, " is NOT equal."
                        write(22,'(3x,a)')      "----------------------------------------"
                        write(22,'(3x,a,a,a)')  "Content file ", trim(compFile1), ":"
                        write(22,'(3x,a)')      trim(filebuff1)
                        write(22,'(3x,a,a,a)')  "Content file ", trim(compFile2), ":"
                        write(22,'(3x,a)')      trim(filebuff2)
                        write(22,'(/,3x,a)')    "****************************************"
                    else
                        write(*,'(/,3x,a)')    "****************************************"
                        write(*,'(3x,a,I7,a)') "Line number: ", noFile1, " is NOT equal."
                        write(*,'(3x,a)')      "----------------------------------------"
                        write(*,'(3x,a,a,a)')  "Content file ", trim(compFile1), ":"
                        write(*,'(3x,a)')      trim(filebuff1)
                        write(*,'(3x,a,a,a)')  "Content file ", trim(compFile2), ":"
                        write(*,'(3x,a)')      trim(filebuff2)
                        write(*,'(/,3x,a)')    "****************************************"
                    end if
                end if
            end if

            if (iostat1 < 0 .and. iostat2 < 0) then
                exit
            end if

        end do

    else
        write(*,'(/,3x,a)') "Error comparing files: "
        write(*,'(3x,a)') trim(compFile1)
        write(*,'(3x,a)') trim(compFile2)
        write(*,'(3x,a,/)') "Exiting fc"
    end if

    if (reportToFile) then
        write(22,'(/,3x,a)')    "fc finished comparing files."
        write(22,'(3x,a)')      "----------------------------------------"
        write(22,'(3x,a,a)')    "File1: ", trim(compFile1)
        write(22,'(3x,a,6x,I7)')"Number of rows in file1: ", noFile1
        write(22,'(3x,a,a)')    "File2: ", trim(compFile2)
        write(22,'(3x,a,6x,I7)')"Number of rows in file2: ", noFile2
        write(22,'(3x,a)')      "----------------------------------------"
        write(22,'(3x,a,I7)')   "Total number of rows compared: ", noEq + noNEq
        write(22,'(3x,a,9x,I7)')"Number of rows equal: ", noEq
        write(22,'(3x,a,7x,I7)')"Number of rows unequal: ", noNEq
        write(22,'(3x,a)')      "----------------------------------------"
    else
        write(*,'(/,3x,a)')    "fc finished comparing files."
        write(*,'(3x,a)')      "----------------------------------------"
        write(*,'(3x,a,a)')    "File1: ", trim(compFile1)
        write(*,'(3x,a,6x,I7)')"Number of rows in file1: ", noFile1
        write(*,'(3x,a,a)')    "File2: ", trim(compFile2)
        write(*,'(3x,a,6x,I7)')"Number of rows in file2: ", noFile2
        write(*,'(3x,a)')      "----------------------------------------"
        write(*,'(3x,a,I7)')   "Total number of rows compared: ", noEq + noNEq
        write(*,'(3x,a,9x,I7)')"Number of rows equal: ", noEq
        write(*,'(3x,a,7x,I7)')"Number of rows unequal: ", noNEq
        write(*,'(3x,a)')      "----------------------------------------"
    end if

    if (noFile1 > noFile2) then
        if (reportToFile) then
            write(22,'(3x,a)')     "Note!"
            write(22,'(3x,a,a,a,I7,a)') "File1: ", trim(compFile1), " has ", noFile1-noFile2, " more rows"
            write(22,'(3x,a,/)')   "########################################"
        else
            write(*,'(3x,a)')     "Note!"
            write(*,'(3x,a,a,a,I7,a)') "File1: ", trim(compFile1), " has ", noFile1-noFile2, " more rows"
            write(*,'(3x,a,/)')   "########################################"
        end if
    else 
        if (noFile1 < noFile2) then
            if (reportToFile) then
                write(22,'(3x,a)')     "Note!"
                write(22,'(3x,a,a,a,I7,a)') "File2: ", trim(compFile2), " has ", noFile2-noFile1," more rows"
                write(22,'(3x,a,/)')   "########################################"
            else
                write(*,'(3x,a)')     "Note!"
                write(*,'(3x,a,a,a,I7,a)') "File2: ", trim(compFile2), " has ", noFile2-noFile1," more rows"
                write(*,'(3x,a,/)')   "########################################"
            end if
        else
            if (reportToFile) then
                write(22,'(3x,a)')     "Note!"
                write(22,'(3x,a,a,a)') "FILES ARE EQUAL"
                write(22,'(3x,a,/)')   "########################################"
            else
                write(*,'(3x,a)')     "Note!"
                write(*,'(3x,a,a,a)') "FILES ARE EQUAL"
                write(*,'(3x,a,/)')   "########################################"
            end if
        end if
    end if

    close(20)
    close(21)

    if (reportToFile) then
        close(22)
    end if

end subroutine compFiles

!Function continues to ask for valid
!filename as long as the file does
!not exists
character(100) function getFileName(fileName)
    character(100), intent(in) :: fileName
    character(100) :: fName

    fName = fileName

    do
        if (fileExists(trim(fName)) == 1) then
            exit
        end if

        write(*,'(/,3x,a)') "Error opening file named: " // trim(fName)
        write(*,'(3x,a)')   "Does file exist?"
        write(*,'(3x,a)', advance='no') "Specify filename (enter -1 to exit): "
        read(*, *) fName

        if(trim(fName) == "-1") then
            stop
        end if

    end do

    getFileName = fileName
    return

end function getFileName

!Function returns 1 if file exists and
!-1 if file can not be opened.
integer function fileExists(fileName)
    character(100), intent(in) :: fileName
    integer :: iostat

    open(unit=20, file=trim(fileName), status='old', &
         action='read', position='rewind', iostat=iostat)

    if (iostat == 0) then
        fileExists = 1
    else
        fileExists = -1
    end if

    close(20)
    return

end function fileExists




end module comp
