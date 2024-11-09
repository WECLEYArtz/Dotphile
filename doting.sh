#!/bin/bash
# set -e

if [ -z "$1" ] || [ -z "$2" ] ;then
	echo "Missing argument: bash doting.sh {option} {path_to_file/dir or file_name}"
	exit 0
fi

LINKER="archive.txt"
SYM_OPT='-s' 	#linking option -s -sf

# ===[ INITIALISING FUNCTIONS ]=== #

erex(){ #check and exit if error, avoid pouring fuel on the fire
	# echo "nn hh $1" >> /dev/tty
	if [[ $1 -ne 0 ]]; then
		echo "error." >> /dev/tty
		exit $1
	else
		echo "Done."  >> /dev/tty

	fi
}

sym(){
	# echo "ln $SYM_OPT $SYM_TAR $SYM_LOC" >> /dev/tty
	ln $SYM_OPT $SYM_TAR $SYM_LOC #linking command
	erex
}

update()
{
	echo "	updating $LINKER" 

	printf "\n[ $TOSYM_NAME ]\n" >> $LINKER
	printf "current=	$DOTFILE_PATH/$TOSYM_NAME\n" >> $LINKER
	printf "previous=	$TOSYM_PATH" >> $LINKER
}

unarchive(){
	LINE_A=$(awk "/ $1 / {printf NR}" $LINKER)
	LINE_B=$((LINE_A + 3))
	sed -i "$LINE_A , $LINE_B d" $LINKER

	erex
}

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

isexist(){
	if [ ! -f "$1" ];then
		echo "No file found."
		exit 2
	fi
}

creatin(){
	echo "creatig installer"
	touch $LINKER  
	printf "\n#this file is automatically created, and saves paths for each file\n#used to undo a linking or redo it\n\n" >> $LINKER

	erex
}

doting()
{
	isexist
	DOTFILE_PATH=$(pwd)	#path to dotfile folder
	TOSYM_PATH=$1	#the argument that is the target file to be doted
	TOSYM_NAME=$(basename $1) #file name extraction

	printf "DOTFILE PATH: set to current location : $DOTFILE_PATH \n\n"

	echo "	moving		'$TOSYM_NAME'	to	$DOTFILE_PATH/$TOSYM_NAME"
	mv $TOSYM_PATH $DOTFILE_PATH

	echo "	symlinking	'$TOSYM_NAME'	to	$TOSYM_PATH"

	#INITIALISING SYMLINKING COMMAND ARGUMENT
	SYM_TAR="$DOTFILE_PATH/$TOSYM_NAME"
	SYM_LOC=$TOSYM_PATH
	#CALLING COMMAND
	sym
	update

	erex
}


resymlink()
{
	set -e #i dont wanna set erex for every rm and mv

	isexist $1
	echo "reinstalling symlink for $1"

	CURRENT=$(getpath-archive $1 2)
	PREVIOUS=$(getpath-archive $1 3)

	#INITIALISING SYMLINKING COMMAND ARGUMENT
	SYM_TAR=$CURRENT
	SYM_LOC=$PREVIOUS
	SYM_OPT='-sf'
	#CALLING COMMAND
	sym || exit $?
	}

getpath-archive()
{
	# set -e
	grep -A2 " $1 " $LINKER >> /dev/null #test command incase of errors, for set -e
	# echo "nn hh $?" >> /dev/tty
	erex $? || exit $?

	#second arg: (1 file name, 2 current, 3 previous)
	PATHH=$(\
		grep -A2 " $1 " $LINKER |\
		awk -v FS='\t' "NR==$2 {print \$2}"
	)
	echo "$PATHH"	

}

undo()
{
	set -e #i dont wanna set erex for every rm and mv

	isexist $1

	echo "undoting $1 from dotfile"

	PREVIOUS=$(getpath-archive "$1" 3)
	CURRENT=$(getpath-archive "$1" 2)

	rm "$PREVIOUS"
	mv "$CURRENT" "$PREVIOUS"

	unarchive $1 || exit $?
}


# ===[ APPLICATION  ]=== #

if [ ! -f $LINKER ]; then #CREAT ARCHIVE
	echo "no installer found. "
	ask
fi

case $1 in
	're')resymlink $2
		exit
		;;
	'un')undo $2
		exit
		;;
	'ad')doting $2
		exit
		;;
	*)	echo "Unavailible argument, ('ad' \ 're' \ 'un')."
		exit
		;;
esac


