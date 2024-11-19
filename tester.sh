#!/bin/bash

# files :	apply on normal file, redo, undo.
# 			apply on none existing file. redo, undo.
#		  	apply on protected file, redo, undo.
#		  	apply on file en protected directory, redo, undo.
 
# dirs :	apply on normal dir, redo, undo.
# 			apply on none existing dir. redo, undo.
#		  	apply on protected dir, redo, undo.
#		  	apply on dir in protected directory, redo, undo.

# links :	apply on normal link, redo, undo.
# 			apply on none existing link. redo, undo.
#		  	apply on protected link, redo, undo.
#		  	apply on link in protected directory, redo, undo.

print-header()
{
	printf "     ____      _   _____ _   _ _     	V 0.1\n"
	printf "    |    \ ___| |_|  _  | |_|_| |___ 	\n"
	printf "    |  |  | . |  _|   __|   | | | -_|	Worst tester in earth.\n"
	printf "___ |____/|___|_| |__|  |_|_|_|_|___| o _____________________\n\n"
}

execute()
{
	echo "COMMAND: $COMMAND $1 $NAME" && $COMMAND $1 $NAME 
	check $2 $?
}

check(){ 	#checks and exit if error, avoid pouring fuel on the fire
			# erex {exit code} {error message} {success message} (message or "-none")
	EREX_MSG_SUCCESS="=[ ✓ pass. ]=\n\n"
	EREX_MSG_ERROR="=[ ✖ unexpected. ]=\n\n"

	if [[ $1 == $2 ]]; then
		printf "$EREX_MSG_SUCCESS" >> /dev/tty
	else
		printf "$EREX_MSG_ERROR" >> /dev/tty
	fi
}

test1()
{	
	COMMAND="bash doting.sh"
	NAME=../testfile

	touch $NAME
	rm archive.txt

	printf "\n====[ TEST 1.1 ]==== try without args\n"
	execute "" 1

	printf "\n====[ TEST 1.2 ]==== try redo file from  here before adding\n"
	execute re 1

	printf "\n====[ TEST 1.3 ]==== try to undo file from here before adding\n"
	execute un 1

read -p "resume test 1"
clear

	printf "\n====[ TEST 1.4 ]==== try to add file\n"
	execute add 0

	printf "\n====[ TEST 1.5 ]==== try redo file, after adding\n"
	execute re 0

	printf "\n====[ TEST 1.6 ]==== try undo file, after adding\n"
	execute un 0

	rm $NAME
}


test2()
{
	COMMAND="bash doting.sh"
	NAME=../testdir/

	mkdir $NAME
	rm archive.txt

	printf "\n====[ TEST 2.1 ]==== try without args\n"
	execute "" 1

	printf "\n====[ TEST 2.2 ]==== try redo dir\n"
	execute re 1

	printf "\n====[ TEST 2.3 ]==== try to undo\n"
	execute un 1

read -p "resume test 2"
clear

	printf "\n====[ TEST 2.4 ]==== try to add dir\n"
	execute add 0

	printf "\n====[ TEST 2.5 ]==== try redo dir, after adding\n"
	execute re 0

	printf "\n====[ TEST 2.6 ]==== try undo dir, after adding\n"
	execute un 0

	rmdir  $NAME
}

test3()
{	
	COMMAND="bash doting.sh"
	NAME=testfile

	touch $NAME
	rm archive.txt

	printf "\n====[ TEST 3.1 ]==== try without args\n"
	execute "" 1

	printf "\n====[ TEST 3.2 ]==== try redo file before adding\n"
	execute re 1

	printf "\n====[ TEST 3.3 ]==== try to undo file before adding\n"
	execute un 1


read -p "resume test 3"
clear

	printf "\n====[ TEST 3.4 ]==== try add file from inside dotfile\n"
	execute add 5

	printf "\n====[ TEST 3.5 ]==== try redo file from inside dotfile, after adding\n"
	execute re 1

	printf "\n====[ TEST 3.6 ]==== try undo file from inside dotfile, after adding\n"
	execute un 1

	rm $NAME
}

print-header

read -p "start test 1"
clear
test1 

read -p "start test 2"
clear
test2 

read -p "start test 3"
clear
test3 
