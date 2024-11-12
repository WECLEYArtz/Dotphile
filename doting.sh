#!/bin/bash
# set -e
if [ "$1" == "-v" ]; then
	echo "version 0.98, by din dimakley"
	exit 0
elif [ -z "$1" ] || [ -z "$2" ] ;then
	echo "Missing argument: bash doting.sh {option} {path_to_file/dir or file_name}"
	exit 0
fi

DOTFILE_PATH=$(pwd)		#path to dotfile folder
CONFG="archive.txt"
SYM_OPT='-s' 			#linking option -s -sf

# -----------------[ INITIALISING FUNCTIONS ]-----------------

erex(){ 				#check and exit if error, avoid pouring fuel on the fire
	if [[ $1 -ne 0 ]]; then
		echo "✖ error." >> /dev/tty
		exit $1
	else
		echo "✓ Done."  >> /dev/tty

	fi
}

symlinking(){
	# echo "ln $SYM_OPT $SYM_TAR $SYM_LOC" >> /dev/tty
	ln $SYM_OPT $SYM_TAR $SYM_LOC #linking command
	erex
}

update()
{
	echo "... updating $CONFG" 

	printf "\n[ $TOSYM_NAME ]\n" >> $CONFG
	printf "TARGET=	$DOTFILE_PATH/$TOSYM_NAME\n" >> $CONFG
	printf "SMLINK=	$TOSYM_PATH" >> $CONFG
}

unarchive(){
	LINE_A=$(awk "/ $1 / {printf NR}" $CONFG)
	LINE_B=$((LINE_A + 3))
	sed -i "$LINE_A , $LINE_B d" $CONFG

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
	if  [ -e "$2" ];then
		echo "REJECTED!"
		echo "File is already in Dotfile directory or is symlink for it,"
		echo "make sure $CONFG is updated."
		exit 5
	elif [ ! -e "$1" ];then
		echo "No '$1' file found."
		exit 2
	fi
}

creatin(){
	echo "creatig installer"
	touch $CONFG  
	printf "This file is automatically created, stores paths of doted file\n#neccesary to perform undos and redos\n\n" >> $CONFG

	erex
}

doting()
{
	TOSYM_NAME=$(basename $1) 	#file name extraction
	TOSYM_PATH=$1				#the argument that is the target file to be doted

	isexist $1 $DOTFILE_PATH/$TOSYM_NAME
	printf " ____      _   _____ _   _ _     	\n"
	printf "|    \ ___| |_|  _  | |_|_| |___ 	\n"
	printf "|  |  | . |  _|   __|   | | | -_|	\n"
	printf "|____/|___|_| |__|  |_|_|_|_|___| o	\n\n"

	printf "DOTFILE PATH: set to currind location : $DOTFILE_PATH \n\n"

	printf "... moving		'$TOSYM_NAME'	to	$DOTFILE_PATH/$TOSYM_NAME \n"
	mv $TOSYM_PATH $DOTFILE_PATH 

	printf "... symlinking	'$TOSYM_NAME'	to	$TOSYM_PATH \n"
	#	Initialising symlinking command argument
	SYM_TAR="$DOTFILE_PATH/$TOSYM_NAME"
	SYM_LOC=$TOSYM_PATH

	#	Calling command
	symlinking
	update

	erex
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
	SYM_OPT='-sf'
	#	Calling command
	symlinking || exit $?
	}

getpath-archive()
{
	# set -e
	grep -A2 " $1 " $CONFG >> /dev/null #test command incase of errors, for set -e
	erex $? || exit $?

	#second arg: (1 file name, 2 TRGET, 3 SMLNK)
	PATHH=$(\
		grep -A2 " $1 " $CONFG |\
		awk -v FS='\t' "NR==$2 {print \$2}"
	)
	echo "$PATHH"	

}

undo()
{
	set -e #i dont wanna set erex for every rm and mv

	isexist $1

	echo "... undoting $1 from dotfile"

	SMLNK=$(getpath-archive "$1" 3)
	TRGET=$(getpath-archive "$1" 2)

	rm "$SMLNK"
	mv "$TRGET" "$SMLNK"

	unarchive $1 || exit $?
}


# -----------------[ APPLICATION  ]-----------------

if [ ! -f $CONFG ]; then 		#Creat archive
	echo "no installer found. "
	ask
fi

case $1 in
	'-r' | 're' | 'redo')resymlink $2
		exit
		;;
	'-u' | 'un' | 'undo')undo $2
		exit
		;;
	'-a' | 'ad' | 'add')doting $2
		exit
		;;
	*)	echo "Unavailible argument, use : ('add' \ 'redo' \ 'undo')."
		echo "                       or : ( 'ad' \  're'  \  'un' )."
		echo "                       or : ( '-a' \  '-r'  \  '-u' )."
		exit
		;;
esac
