# Dotphile
Dotphilism

currently developing "buffing" branch.
=

if you get this error :

ln: failed to create symbolic link '/path/to/dir/': No such file or directory

edit installer.sh and remove '/' at the end of any path.
example : /path/to/dir/ -> /path/to/dir
and run 'installer.sh f'.

