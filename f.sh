#!/usr/local/bin/bash
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

# Commands, short and long
declare -A enabledCommands
enabledCommands['h']='help' # display the help
enabledCommands['u']='update' # update
# this order probably matters, but we won't actually know until we get ethical analytics set up


# Create the parameter array.
declare -a saneParam



# ^-- sorted, ish

# housekeeping and conventions
# NAME variable is used for log file and screen instance naming
NAME="francis" # <-- uppercase variable name is significant, will explain later




# sanitize and process short params
# short params are a single command character followed by one or more character(s)
# intended as shorthand and ease-of-prototyping flags
function processShortParams {
	# fail early if there's nothing passed to the function
	if [ "${@}" ]; then

		# Local variable for manipulating/using input
		local inputParamString="${@}"

		# Iterate through the length of the command string
		for (( i=0; i<${#inputParamString}; i++ )); do
			# ignore the command character
			if [[ "${commandChar}" =~ "${inputParamString:$i:1}" ]]; then
				continue
			fi
			# Add the character in question to the parameters list if it is part of the enabledCommands array
			if [[ "${enabledCommands[${inputParamString:$i:1}]}" ]]; then
				saneParam[${#saneParam[@]}]="${enabledCommands[${inputParamString:$i:1}]}"
			fi
		done
	fi

}


## unsorted --v
function processLongParams {
	# fail early if there's nothing passed to the function
	if [ "${@}" ]; then

		# Local variable for manipulating/using input
		local inputParamString="${@}"

		# Remove the command sequence from the string
		if [ "${commandChar}${commandChar}" == "${inputParamString:0:2}" ]; then
			saneParam[${#saneParam[@]}]="${inputParamString:2:${#inputParamString}}"
		fi

	fi
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

# if no parameters have been passed, display the help
if [ "${#saneParam}" == 0 ]; then
	saneParam[${#saneParam}]="${enabledCommands[0]}"
fi


echo ${saneParam[@]}
