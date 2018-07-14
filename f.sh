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
exit 1
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
shortParams[0]="${commandChar}" # <-- first level recursion, note that a bare hyphan (the current command char, '-') should return the help printout


# ^-- sorted, ish
# unsorted --v


# slurp up the short params
# short params are a command character followed by a single character, followed by a break character
function processShortParams {
	local inputParamString="${@}"
	local sanizedParam[0]="${inputParamString:0:1}"

	# @todo - check different methods of iterating for speed
	# Start at position one, as position zero has the command character.
	for (( i=1; i<${#inputParamString}; i++ )); do
		if [[ "${enabledCommands[@]}" =~ "${inputParamString:$i:1}" ]]; then
			sanizedParam[$i]="${inputParamString:$i:1}"
			echo "'${sanizedParam[$i]}' is a valid command parameter!"

		else
			echo "command parameter '${inputParamString:$i:1}' is invalid"

		fi
	done

	echo ${sanizedParam[@]}
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
