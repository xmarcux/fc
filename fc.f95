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

!This is the main file and start of the program.
!fc compares two files for their equality.
!Differences is writen to sceen or optionally to a file.

!File names are given as commandline options on start of
!the program. 
!Two first arguments are the names of the files to compare.
!The third argument is optional and if it is given,
!the difference report will be written to file with given name.
!eg. fc file1 file2 reportFile
!If there is an error opening any of the files user will be
!prompted for a new file name.

!Two argument flags is defined as well:
! -l : Will show licence and exit program.
! -h : Will show help text and exit program.

program fc
    use info
    use comp

    implicit none

    integer :: cmd_cnt
    character(100) :: arg1, arg2, arg3

    cmd_cnt = command_argument_count()

    if (cmd_cnt == 3) then
        call get_command_argument(1, arg1)
        call get_command_argument(2, arg2)
        call get_command_argument(3, arg3)
        call compFiles(arg1, arg2, arg3)
    else if (cmd_cnt == 2) then
        call get_command_argument(1, arg1)
        call get_command_argument(2, arg2)
        arg3 = "-1"
        arg3 = adjustl(arg3)
        call compFiles(arg1, arg2, arg3)
    else if (cmd_cnt == 1) then
        call get_command_argument(1, arg1)
        if (trim(arg1) == "-l") then
            call license()
        else if (trim(arg1) == "-h") then
            call help()
        else
            call errorMsg()
        end if 
    else
        call errorMsg()
    end if

contains

    subroutine errorMsg()
        implicit none
        write(*,'(/,3x,a,/,3x,a,/,3x,a,/)') "Fortran compare", &
                             "***************", &
                             "Error! Wrong type or number of arguments."
        write(*, '(3x,a,/)') "Use fc -h for help."
    end subroutine errorMsg

end program fc
