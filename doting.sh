#!/bin/bash

LINKER="installer.sh"

DOTFILE_PATH=
TOSYM_PATH=$1
TOSYM_NAME=$(basename $1)

SYM_CMD=
SYM_OPT='-s' 

if [ -z "$1" ];then
    echo "Missing argument: bash doting.sh [path to file/dir]"
    exit
fi

creatin(){
    echo "creatig installer"
    touch $LINKER  

    printf "#!/bin/bash \n\nSYM_OPT='-s'\n\n" >> $LINKER

    printf "if [ \$1 = 'f' ]; then\n\tSYM_OPT='-sf'\nfi\n\n" >> $LINKER

    printf "#The linking commands containing each doted's original path\n\n" >> $LINKER

    printf "if [ \$0 -neq 0 ]; then\n\t" >> $LINKER
    printf "echo \"Symlinks updated.\"\nfi\n" >> $LINKER
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

if [ ! -f $LINKER ]; then
    echo "no installer found. "
    ask
fi

DOTFILE_PATH=$(pwd)
printf "DOTFILE PATH: set to current location : $DOTFILE_PATH \n\n"

echo "  moving     '$TOSYM_NAME' to      $DOTFILE_PATH/$TOSYM_NAME"
mv $TOSYM_PATH $DOTFILE_PATH

echo "  symlinking '$TOSYM_NAME' back to $TOSYM_PATH"
SYM_CMD="ln $SYM_OPT $DOTFILE_PATH/$TOSYM_NAME $TOSYM_PATH"
$SYM_CMD

echo "  updating $LINKER" 
SYM_OPT='$SYM_OPT'
SYM_CMD="ln $SYM_OPT $DOTFILE_PATH/$TOSYM_NAME $TOSYM_PATH"
sed -i "10i $SYM_CMD" $LINKER #thanks stackoverflow, but i still dont fully understand ;-;

echo "Done."
