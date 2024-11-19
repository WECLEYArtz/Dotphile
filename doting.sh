#!/bin/bash
# set -e
if [ "$1" == "-v" ]; then
	echo "version 0.99, by din dimakley"
	exit 0
elif [ -z "$1" ] || [ -z "$2" ] ;then
	echo "Missing argument: bash doting.sh {option} {path_to_file/dir or file_name}"
	exit 1
fi

DOTFILE_PATH=$(pwd)		#path to dotfile folder
CONFG="archive.txt"
SYM_OPT='-s' 			#linking option -s -sf

# -----------------[ INITIALISING FUNCTIONS ]-----------------

ask(){
	read -p "create and continue? (y/n):" INP
	case $INP in
		'y')creatin;;
		
		'n')echo "abort."
			exit;;
		
		*)	echo "not an option, retry"
			echo $INP
			ask;;
	esac
}

creatin(){
	echo "creatig $CONFG"
	touch $CONFG  

	erex $? "creation failed" "created"

	printf "This file is automatically created, stores paths of doted file\n#neccesary to perform undos and redos\n\n" >> $CONFG
}

erex(){ 	#checks and exit if error, avoid pouring fuel on the fire
			# erex {exit code} {error message} {success message} (message or "-none")
	EREX_MSG_SUCCESS="✓ Done.\n"
	EREX_MSG_ERROR="✖ error.\n"

	if [ "$2" == "-none" ]; then
		EREX_MSG_ERROR=
	elif [ -n "$2" ]; then
		EREX_MSG_ERROR="✖ $2\n"
	fi

	if [ "$3" == "-none" ]; then
		EREX_MSG_SUCCESS=
	elif [ -n "$3" ]; then
		EREX_MSG_SUCCESS="✓ $3\n"
	fi

	case $3 in
	esac

	if [[ $1 -ne 0 ]]; then
		printf "$EREX_MSG_ERROR" >> /dev/tty
		exit $1
	else
		printf "$EREX_MSG_SUCCESS" >> /dev/tty

	fi
}

getpath-archive()
{
	# set -e
	grep -A2 " $1 " $CONFG >> /dev/null #test command incase of errors, for set -e
	erex $? "bad grep" "-none" || exit $?

	#second arg: (1 file name, 2 TRGET, 3 SMLNK)
	PATHH=$(\
		grep -A2 " $1 " $CONFG |\
		awk -v FS='\t' "NR==$2 {print \$2}"
	)
	echo "$PATHH"	
}

isexist(){
	if  [ -e "$2" ];then #only for doting()
		printf "✖ REJECTED : File is already in Dotfile directory or is symlink for it,\n"
		printf "make sure $CONFG is updated.\n"
		exit 5
	elif [ ! -e "$1" ];then
		echo "No '$1' file found."
		exit 2
	fi
}


print-header()
{
	printf "     ____      _   _____ _   _ _     	\n"
	printf "    |    \ ___| |_|  _  | |_|_| |___ 	\n"
	printf "    |  |  | . |  _|   __|   | | | -_|	\n"
	printf "___ |____/|___|_| |__|  |_|_|_|_|___| o ____________________\n\n"

	printf "    DO NOT USE THIS SCRIPT OUTSIDE YOUR DOTFILE DIRECTORY!\n"
	printf "    IF USED, UNDO THE PROCESS.\n\n"
}

symlinking(){
	# echo "ln $SYM_OPT $SYM_TAR $SYM_LOC" >> /dev/tty
	ln $SYM_OPT $SYM_TAR $SYM_LOC #linking command
	erex $? "syming error"
}

unarchive(){
	LINE_A=$(awk "/ $1 / {printf NR}" $CONFG)
	LINE_B=$((LINE_A + 3))
	sed -i "$LINE_A , $LINE_B d" $CONFG

	erex $? "unarchive error"
}

update()
{
	echo "... updating $CONFG" 

	printf "[ $TOSYM_NAME ]\n" >> $CONFG
	printf "TARGET=	$DOTFILE_PATH/$TOSYM_NAME\n" >> $CONFG
	printf "SMLINK=	$TOSYM_PATH\n\n" >> $CONFG
}

safe-rm()
{
	if [ -e $SMLNK ] ; then
		if [ -L $SMLNK ] ; then
			ANSWER="y"
		elif [ -f $1 ] ; then
			read -p "WARNING : '$1' is an existing file, replace with a symlink? (y/n): "\
				ANSWER
		elif [ -d $1 ] ; then
			read -p "WARNING : '$1' is an existing directory, replace with a symlink? (y/n): "\
				ANSWER
		fi
		case $ANSWER in
			'y') rm -r $1
				if [ -e $1 ] ; then
					echo "✖ failed to remove $1"
					exit 1
				else
					echo "✓ removed $1 successfully."
				fi
				;;
			*) echo "aborting"
				exit
				;;
		esac
	fi
}

# -----------------[ PRIMARY FUNCTIONS ]-----------------

doting()
{
	TOSYM_NAME=$(basename $1)		#file name extraction
	TOSYM_PATH=$1
	isexist $1 $DOTFILE_PATH/$TOSYM_NAME

	# printf "DOTFILE PATH: $DOTFILE_PATH \n\n"

	printf "... moving		'$TOSYM_NAME'	to	$DOTFILE_PATH/$TOSYM_NAME \n"
	mv $TOSYM_PATH $DOTFILE_PATH 

	printf "... symlinking	'$TOSYM_NAME'	to	$TOSYM_PATH \n"
	#	Initialising symlinking command argument
	SYM_TAR="$DOTFILE_PATH/$TOSYM_NAME"
	SYM_LOC=$TOSYM_PATH

	#	Calling command
	symlinking
	update

	erex $? "doting error" "complete"
}

resymlink()
{
	set -e		#i dont wanna set erex for every rm and mv

	isexist $1
	echo "... reinstalling symlink for $1"

	TRGET=$(getpath-archive $1 2)
	SMLNK=$(getpath-archive $1 3)

	#	Initialising symlinking command argument
	SYM_TAR=$TRGET
	SYM_LOC=$SMLNK
	#	Verify file
	safe-rm	$SMLNK
	#	Calling command
	symlinking || exit $?
}

undo()
{
	set -e #i dont wanna set erex for every rm and mv

	isexist $1

	echo "... undoting $1 from dotfile"

	SMLNK=$(getpath-archive "$1" 3)
	TRGET=$(getpath-archive "$1" 2)

	safe-rm	$SMLNK
	mv "$TRGET" "$SMLNK"

	unarchive $1 || exit $?
}
# -----------------[ APPLICATION  ]-----------------


case $1 in
	'-r' | 're' | 'redo')

		# print-header
		if [ ! -f $CONFG ]; then 		#Creat archive
			echo "no archiving file found, must have added files. "
			exit 1
		fi
		resymlink $(basename $2)	#get and convert to name if path used.
		exit 
		;;

	'-u' | 'un' | 'undo')

		# print-header
		if [ ! -f $CONFG ]; then 		#Creat archive
			echo "no archiving file found, must have added files. "
			exit 1
		fi
		undo $(basename $2)
		exit
		;;

	'-a' | 'ad' | 'add')

		if [ ! -f $CONFG ]; then 		#Creat archive
			echo "no archiving file found. "
			ask
		fi
		# print-header
		doting $(readlink -f $2)	#get and convert to absolute path if ../ used.
		exit
		;;

	*)	echo "Unavailible argument, use : ('add' \ 'redo' \ 'undo')."
		echo "                       or : ( 'ad' \  're'  \  'un' )."
		echo "                       or : ( '-a' \  '-r'  \  '-u' )."
		exit 1
		;;
esac
