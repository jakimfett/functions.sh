#!/bin/bash
#
# author: @jakimfett
# license: cc-by-sa
#
# usage: index.sh <folder>
# Creates a sorted, cleaned index of files in a given directory.

# What to index?
projectName='functions.sh'
cacheDir='cache'
workingDir="$(pwd)"
aliases="${workingDir}/com/usr/aliases.src"
source "${aliases}"

# okayso mlocate is a good thought, but the performance is poor and it's not always available.
#
# functions.sh is about minimalism, and removing a dependency would be nice,
# especially at this point.

# we have to assume there's an index.
# and we are going to assume that there's occasionally more than one.
# so reading a standardized multi-piece index is the first hurdle.
#
# let's start small

# my intention:
# read in all the indexes, output to a single file, after sorting and de-duplicating.
# this was my first psuedo-code for it.
# cat folder.dex.* >> "${cache}/index/${projectName}.${chronoStamp}.dex"; exit
#
# That didn't work, we need to locate where stuff is first.
#
# the -name flag for find seems relevant.
echo "${workingDir}${cache}/index/${projectName}.$(chronoStamp).dex"
echo "finding ${projectName}:"
#find ~ -name "${projectName}" -type d 2>/dev/null


#>> "${cache}/index/${projectName}.${chronoStamp}.dex"


exit


########### Include functions ###########
if [[ `find functions.sh 2>&1` == *"No such file"* ]];then echo "functions.sh not found, exiting";exit 1;fi
clear; source "`dirname "$0"`/functions.sh"; when.sh;echo
logThis "loaded:'functions.sh'"
########### End include functions #######

if [ ! -z "${1}" ]; then

    TARGETDIR="$1"
    DUPEDIR="/Users/jakimfett/Downloads/dupes/"

    cd $TARGETDIR
    TEMPOUTPUT="${TEMPFOLDER}/`basename ${TARGETDIR}`.index.tmp"
    touch ${TEMPOUTPUT}.md5sum


    echo "Temp index will be created at '${TEMPOUTPUT}'"

    echo "Directory size:"
    du -hs .
    echo
    echo "starting file indexing:"

    find . | sort | uniq > "${TEMPOUTPUT}"

    #if [ ! -f "${TEMPOUTPUT}" ] ; then
    #    echo "Skipping creation of index, remove '${TEMPOUTPUT}' to regen."
    #fi

    # if [ ! -f "${TEMPOUTPUT}.md5sum" ] ; then


    # during loops, fail early when possible
    while read path; do
        # check if variable is empty
        if [ ! -z "${path}" ] ; then
            # check if it's a directory
            if [ ! -d "${path}" ] ; then

                fileName="`basename ${path}`"

                # expensive processing, but necessary eventually
                # @todo - refactor to multiprocess this?
                # @todo use rhash --sha3-512, requires homebrew on OSX?
                # @todo switch to using keccak
                fileMD5="`md5 -q "${path}"`"
                echo -n '.'

                # this is a horrible hack but it works (for now)
                fileSize="`echo $(wc -c <"${path}") | xargs`"
                # @todo - refactor file size calculation method


                dupe="`grep "${fileMD5}" "${path}"`"
                # file is a duplicate
                if [ ! -z "${dupe}" ]; then
                    echo "new file: ${fileMD5} ${path}"
                    echo "duplicate file: ${dupe}"
                    # mv '${path}' '${DUPEDIR}'
                fi
                echo "${fileMD5} | ${fileSize} | ${path}" >> "${TEMPOUTPUT}.md5sum"
            fi
        fi
    done <"${TEMPOUTPUT}"

    #echo "# File list" > ${TEMPOUTPUT}.list
    #echo "md5\t|\tfilepath" >> ${TEMPOUTPUT}.list

    #threshold=1
    #cat ${TEMPOUTPUT}.md5sum | awk '{print $2}' | sort | uniq -c | awk -v threshold="$threshold" '$1 > threshold' > ${TEMPOUTPUT}.counts


    echo "file indexing done"
else
    logThis "input a folder path please"
fi
