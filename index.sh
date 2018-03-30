#!/bin/bash
#
# author: @jakimfett
# license: cc-by-na
#
# usage: index.sh <folder>
# Creates a sorted, cleaned index of files in a given directory.

########### Include functions ###########
if [[ `find functions.sh 2>&1` == *"No such file"* ]];then echo "functions.sh not found, exiting";exit 1;fi
source "`dirname "$0"`/functions.sh"
########### End include functions #######

if [[ ! -z "${1}" ]]; then

TARGETDIR="$1"

cd $TARGETDIR
TEMPOUTPUT="${TEMPFOLDER}/`basename ${TARGETDIR}`.index.tmp"
echo "Temp index will be created at '${TEMPOUTPUT}'"

echo "Directory size:"
du -hs .
echo
echo "starting file indexing:"

find . | sort | uniq > "${TEMPOUTPUT}"

rm -f ${TEMPOUTPUT}.md5sum
touch ${TEMPOUTPUT}.md5sum

while read line; do
  md5 "${line}" >> "${TEMPOUTPUT}.md5sum"
done <"${TEMPOUTPUT}"

echo "file indexing done"
