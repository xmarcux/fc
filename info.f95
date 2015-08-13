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
!give information to the user.

module info

contains

!Subroutine is called if flag -l is used at program start
subroutine license()
    implicit none

    character(7) :: format

    format = "(3X, a)"

    write(*, '(/,3x,a,/)') "fc (Fortran Compare) - Compares two files and writes a report on differences."
    write(*, '(3x,a,/)') "Copyright (C) 2015 Marcus Pedersén"
    write(*,format) "This program is free software: you can redistribute it and/or modify"
    write(*,format) "it under the terms of the GNU General Public License as published by"
    write(*,format) "the Free Software Foundation, either version 3 of the License, or"
    write(*,'(3X,a,/)') "(at your option) any later version."
    write(*,format) "This program is distributed in the hope that it will be useful,"
    write(*,format) "but WITHOUT ANY WARRANTY; without even the implied warranty of"
    write(*,format) "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
    write(*,'(3X,a,/)') "GNU General Public License for more details."
    write(*,format) "You should have received a copy of the GNU General Public License"
    write(*,'(3X,a,/)') "along with this program.  If not, see <http://www.gnu.org/licenses/>."

end subroutine license


!Subroutine is called if flag -h is used at program start
subroutine help()
    implicit none

    character(7) :: format

    format = "(3x, a)"

    write(*, '(/,3x,a,/)') "fc (Fortran Compare) - Compares two files and writes a report on differences."
    write(*, format) "There are two flags available:"
    write(*, format) "-h   Help text. Description of application functionality."
    write(*, format) "     You used this flag to come here."
    write(*, format) "-l   License information."
    write(*,*) ""
    write(*, format) "File names are given as commandline options on start of"
    write(*, format) "the program. "
    write(*, format) "Two first arguments are the names of the files to compare."
    write(*, format) "The third argument is optional and if it is given,"
    write(*, format) "the difference report will be written to file with given name."
    write(*, format) "eg. fc file1 file2 reportFile"
    write(*, format) "If there is an error opening any of the files user will be"
    write(*, format) "prompted for a new file name."
    write(*, *) ""


end subroutine help

end module info
