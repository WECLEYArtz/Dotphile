# Dotphile
Dotphilism

[ USAGE ]
=
`bash doting.sh {option} {path_file/dir}`

**options :**

`re` , reinstalls the symlink incase of removal
must have the file in dotfile folder, and archive.txt containing
current and previous paths in order

*todo : take from name rather than line order*

`un` : undo any doting and retuns the file where it used to be acording to
archive.txt

note: archive.txt get created if the script hasnt found it in the dotfile directory


if you get this error :
`ln: failed to create symbolic link '/path/to/dir/': No such file or directory`
edit installer.sh and remove '/' at the end of any path.
example : /path/to/dir/ -> /path/to/dir
and run 'installer.sh f'.

