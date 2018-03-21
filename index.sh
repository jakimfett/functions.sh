#!/bin/bash
#
# author: @jakimfett
# license: cc-by-na
#
# Creates a sorted, cleaned index of files in a given directory.

########### Include functions ###########
if [[ `find functions.sh 2>&1` == *"No such file"* ]];then echo "functions.sh not found, exiting";exit 1;fi
source "`dirname "$0"`/functions.sh"
########### End include functions #######
