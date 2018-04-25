#!/bin/bash
#
# author: @jakimfett
# license: cc-by-sa
#
# usage: index.sh <folder>
# Creates a sorted, cleaned index of files in a given directory.

# @todo - include functions.sh
# get filename without extension(s), this needs work
FILENAME=`echo ${0##*/} | cut -d'.' -f1`
# echo "${FILENAME}"


# Set the command character.
commandChar='-'

# Create the parameter array.
shortParams[0]="${commandChar}"

function processShortParams {
    local inputParamString="${@}"

    # @todo - check different methods of iterating for speed
    # Start at position one, as position zero has the command character.
    for (( i=1; i<${#inputParamString}; i++ )); do
        echo "${inputParamString:$i:1}"
    done

}

function processLongParams {
    local inputParamString="${@}"
    echo "not implemented"
}

function userInput {
    # @todo - implement
    # http://wiki.bash-hackers.org/commands/builtin/read
    echo "Not implemented."
}

for flag in "${@}"; do
    case "${flag}" in
        # parse any short flags first
        ${commandChar}[a-zA-Z0-9_]*)
            processShortParams "${flag}"
        ;;
        # parse any short flags first
        ${commandChar}${commandChar}[a-zA-Z0-9_]*)
          processLongParams "${flag}"
        ;;

        *)
            echo "command line input '${flag}' not understood."
            echo
        ;;
    esac
done


echo



exit 1;

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
                fileMD5="`md5 -q "${path}"`"
                echo -n '.'

                # this is a horrible hack but it works (for now)
                fileSize="`echo $(wc -c <"${path}") | xargs`"
                # @todo - refactor file size calculation method
                # use rhash --sha3-512, requires homebrew on OSX


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
