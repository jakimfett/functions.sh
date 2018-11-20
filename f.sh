#!/bin/bash
# @author: @jakimfett
# @description: minimalism, sorta
# @goal: satisfy mel's curiousity
# @practice: never do anything for just one reason
# @advice: when stuck, do something functionally frivelous, but long term strategic additionally
# @link: https://en.wikipedia.org/wiki/The_Story_of_Mel
# @addendum: http://archive.is/jDFuO

###
# Author's comment (2018.07.14.2119.gmt.gregorian):
# this is a *very* dangerous tool
# educating yourself mitigates the (karmic) stupid tax
# remove the following line(s) from execution to violate (some|all) warrenties
#exit 1
###



echo "Hold on, here we go..."

# @todo - set all variables via user-facing setup questions
# Set the command character.
commandChar='-'

# Enable shortcommand
enabledCommands[0]='h' # display the help
enabledCommands[1]='u' # update
# this order probably matters, but we won't actually know until we get ethical analytics set up


# Create the parameter array.
declare -a shortParams



# ^-- sorted, ish

# housekeeping and conventions
# NAME variable is used for log file and screen instance naming
NAME="francis" # <-- uppercase variable name is significant, will explain later




# sanatize and process short params
# short params are a single command character followed by one or more character(s)
# intended as shorthand and ease-of-prototyping flags
function processShortParams {
	# fail early if there's nothing passed to the function
	if [ "${@}" ]; then

		# Local variable for manipulating/using input
		local inputParamString="${@}"

		for (( i=0; i<${#inputParamString}; i++ )); do
			# ignore the command character
			if [[ "${commandChar}" =~ "${inputParamString:$i:1}" ]]; then
				continue
			fi

			if [[ "${enabledCommands[@]}" =~ "${inputParamString:$i:1}" ]]; then
				shortParams[${#shortParams[@]}]="${inputParamString:$i:1}"

			fi
		done
	fi

}


## unsorted --v
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
		# parse any short flags (single command char)
		${commandChar}[a-zA-Z0-9_]*)
			processShortParams "${flag}"
		;;
		# parse long params (double command char)
		${commandChar}${commandChar}[a-zA-Z0-9_]*)
		  processLongParams "${flag}"
		;;

		*)
			echo "command line input '${flag}' not understood."
			echo
		;;
	esac
done

if [ "${#shortParams}" == 0 ]; then
	shortParams[${#shortParams}]="${enabledCommands[0]}"
fi


echo ${shortParams[@]}



exit 1;


SOURCE="https://raw.githubusercontent.com/jakimfett/functions.sh/development/functions.sh"

# get filename without extension(s), this needs work
CUTNAME=`echo ${0##*/} | cut -d'.' -f1`
echo "Current file executing: ${CUTNAME}"


# name of current file
FNAME=`basename "${0}"`
echo "Extensions: ${FNAME}"

# location of current environment
LOCAL="`pwd`/"
echo "Current working directory: ${LOCAL}"

# location of temporary filestash
TMP="${LOCAL}tmp/"

function installVerify {
	mkdir -p ${TMP}

	if [ ! -f ${TMP}functions.sh.net ]; then
		curl ${SOURCE} > ${TMP}functions.sh.net
		openssl sha512 ${TMP}functions.sh.net > ${TMP}functions.sha.512.sum
	fi

	if [ ! -f ${LOCAL}functions.sha.512.sum ]; then
		openssl sha512 ${LOCAL}functions.sha.512.sum > ${LOCAL}functions.sha.512.sum
	fi

	if [ "`diff ${TMP}functions.sha.512.sum ${LOCAL}functions.sha.512.sum`" ];then
		echo shasums differ:
		echo remote sum: `cat ${TMP}functions.sha.512.sum`
		echo local sum: `cat ${LOCAL}functions.sha.512.sum`
	else
		echo sums identical
	fi
}
installVerify

function garbageCollect {
	rm ${TMP}/*
}
#garbageCollect
exit 1
########### Include functions ###########
if [[ `find functions.sh 2>&1` == *"No such file"* ]];then exit 1;fi
#clear; source "`dirname "$0"`/functions.sh"; when.sh;echo; logThis "loaded:'functions.sh'"
########### End include functions #######

#alias reload="source ${FILENAME}"

#echo "${FILENAME}";


exit 1
