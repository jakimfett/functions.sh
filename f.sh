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
declare -A enabledCommands commandDescript

enabledCommands['h']="help" # display the help
commandDescript["${enabledCommands['h']}"]="Displays usage/command info for the script."

enabledCommands['i']="install" # update the script
commandDescript["${enabledCommands['i']}"]="Installs functions.sh to the local system."

enabledCommands['p']="purge" # update the script
commandDescript["${enabledCommands['p']}"]="Remove all traces of functions.sh from the local system."


# Sanitized parameter array.
declare -a saneParam

# Keep track of completeds
declare -A doneList



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


# Display script usage information and flags.
function usageHelp {
	doneList['help']="task begin: `./when.sh`"
	echo
    echo "Commands available in f.sh:"
	echo -e "  <empty>|--help|-h \t ${commandDescript["help"]}"
	echo -e "  --install|-i \t\t ${commandDescript["install"]}"
	echo -e "  --purge|-p \t\t ${commandDescript["purge"]}"
    echo
	# @todo - calculate run time?
	doneList['help']="${doneList['help']}, task complete: `./when.sh`"
}

# Decision input from the user
function userInput {
	read -p "execute the previous command(s)? (y/n/?): " rawInput
	case "${rawInput}" in
		[yY])
			echo `./when.sh`
		;;
		[nN])
			echo "program will now exit"
			exit 1
		;;
		*)
			echo "input '${rawInput}' not recognized, program will exit."
			echo
			exit 1
		;;
	esac
}

for flag in "${@}"; do
	case "${flag}" in
		# parse any short flags (single command char)
		${commandChar}[a-zA-Z0-9_]*)
			processShortParams "${flag}"
			#echo "shortParam"
		;;
		# parse long params (double command char)
		${commandChar}${commandChar}[a-zA-Z0-9_]*)
			processLongParams "${flag}"
			echo
			#echo "longParam"
		;;

		*)
			echo "command line input '${flag}' not understood."
			echo
		;;
	esac
done

## unsorted --v

# if no parameters have been passed, display the help
if [ "${#saneParam}" == 0 ]; then
	usageHelp
	exit 0
fi
