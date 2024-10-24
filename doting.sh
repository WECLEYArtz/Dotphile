#!/bin/bash
#version 1 of a script to move and symlink anything in the home directory
#using it with an item outsidu /home/$USER may cause river crying
mv ~/$1 ~/.dotphile/
ln -s ~/.dotphile/$1 ~/$1
