#!/bin/bash

if [ -z "$1" ];then
    echo "Missing argument: bash doting.sh [path to file/dir]"
	#creat archive if not existing, better exist
    exit
fi

LINKER="archive.txt"

DOTFILE_PATH=	#path to dotfile folder
TOSYM_PATH=$1	#the argument that is the target file to be doted
TOSYM_NAME=$(basename $1)

SYM_OPT='-s' 	#linking option -s -sf
SYM_TAR=
SYM_LOC=



# INITIALISING FUNCTIONS

sym(){
	ln $SYM_OPT $SYM_TAR $SYM_LOC #linking command
}

unarchive(){
	LINE_A=$(awk "/ $1 / {printf NR}" $LINKER)
	LINE_B=$((LINE_A + 3))
	sed -i "$LINE_A , $LINE_B d" $LINKER
}

ask(){
    read -p "create and continue? (y/n):" INP
    case $INP in
        'y')
            creatin
            ;;
        'n')
            echo "abort."
            exit
            ;;
        *)
            echo "not an option, retry"
            echo $INP
            ask
            ;;
    esac
}

creatin(){
    echo "creatig installer"
    touch $LINKER  
    printf "\n#this file is automatically created, and saves paths for each file\n#used to undo a linking or redo it\n\n" >> $LINKER

    # printf "if [ \$1 = 'f' ]; then\n\tSYM_OPT='-sf'\nfi\n\n" >> $LINKER
    # printf "#The linking commands containing each doted's original path\n\n" >> $LINKER
    # printf "if [ \$0 -neq 0 ]; then\n\t" >> $LINKER
    # printf "echo \"Symlinks updated.\"\nfi\n" >> $LINKER
}

doting()
{
	DOTFILE_PATH=$(pwd)
	printf "DOTFILE PATH: set to current location : $DOTFILE_PATH \n\n"

	echo "	moving		'$TOSYM_NAME'	to	$DOTFILE_PATH/$TOSYM_NAME"
	mv $TOSYM_PATH $DOTFILE_PATH

	echo "	symlinking	'$TOSYM_NAME'	to	$TOSYM_PATH"

	#INITIALISING SYMLINKING COMMAND ARGUMENT
	SYM_TAR="$DOTFILE_PATH/$TOSYM_NAME"
	SYM_LOC=$TOSYM_PATH
	#CALLING COMMAND
	sym
}

update()
{
	echo "	updating $LINKER" 

	printf "\n[ $TOSYM_NAME ]\n" >> $LINKER
	printf "current=	$DOTFILE_PATH/$TOSYM_NAME\n" >> $LINKER
	printf "previous=	$TOSYM_PATH" >> $LINKER
}

resymlink()
{
	CURRENT=$(grep -A2 "$1" $LINKER | awk -v FS='\t' 'NR==2 {print $2}')
	PREVIOUS=$(grep -A2 "$1" $LINKER | awk -v FS='\t' 'NR==3 {print $2}')

	echo "reinstalling symlink for $1"

	#INITIALISING SYMLINKING COMMAND ARGUMENT
	SYM_TAR=$CURRENT
	SYM_LOC=$PREVIOUS
	SYM_OPT='-sf'
	#CALLING COMMAND
	sym
}

undo()
{
	if [ ! -f "$1" ];then
		echo "File doesnt exist."
		exit
	fi

	CURRENT=$(grep -A2 "$1" $LINKER | awk -v FS='\t' 'NR==2 {print $2}')
	PREVIOUS=$(grep -A2 "$1" $LINKER | awk -v FS='\t' 'NR==3 {print $2}')

	echo "undoting $1 from dotfile"

	rm "$PREVIOUS"
	mv "$CURRENT" "$PREVIOUS"

	unarchive $1

	echo "done."
}

erex(){
if [ $? -gt 0 ]; then
	echo "error."
	exit 
else
	echo "Done."
fi
}
# APPLICATION ====================================

case $1 in
	're')
		resymlink $2
		exit
		;;
	'un')
		undo $2
		exit
		;;

esac

if [ ! -f $LINKER ]; then #CREAT ARCHIVE
    echo "no installer found. "
    ask
fi

doting
erex
update
erex
# ==== logs =====================================

# [ FILE_NAME 1 ]
# current=	'DOTFILE_PATH/TOSYM_NAME 1'
# previous=	'TOSYM_PATH 1'

# [ FILE_NAME 2 ]
# current=	'DOTFILE_PATH/TOSYM_NAME 2'
# previous=	'TOSYM_PATH 2'

# awk -v FS='\t' 'NR==2 {print $2}'
# awk -v FS='\t' 'NR==3 {print $2}'
# =============================================

# SYM_OPT='$SYM_OPT'
# SYM_CMD="ln $SYM_OPT $DOTFILE_PATH/$TOSYM_NAME $TOSYM_PATH"
# sed -i "10i $SYM_CMD" $LINKER #thanks stackoverflow, but i still dont fully understand ;-;

