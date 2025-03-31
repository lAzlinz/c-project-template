To compile code:
	type 'make compile_all'

To compile library code:
	type 'make compile_lib LIB_NAME=<name_of_your_library_folder>'

To run the project:
	type 'make run'


Format for code:
	- bin/     -- This is where the object and executable files go.
	- include/ -- This is where the header files go.
	- src/     -- This is where the source or c files go.
	- - main.c -- The main c file.

Format for library:
	- lib/
	- - <library_name>/
	- - - src/
	- - - include/
	- - - lib<library_name>.a