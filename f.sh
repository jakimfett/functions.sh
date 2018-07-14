#!/bin/bash
# @author: @jakimfett
# @description: minimalism, sorta
# @goal: satisfy mel's curiousity
# @link: https://en.wikipedia.org/wiki/The_Story_of_Mel
# @addendum: http://archive.is/jDFuO

BASENAME=`basename "${0}"`
# get filename without extension(s), this needs work
FILENAME=`echo ${0##*/} | cut -d'.' -f1`


########### Include functions ###########
if [[ `find functions.sh 2>&1` == *"No such file"* ]];then

function installVerify {
    mkdir -p ~/functions.sh/tmp
    cd ~/functions.sh/
    curl http://functions.sh | openssl sha512 > tmp/functions.sha.512.sum
    wget http://functions.sh/ -O tmp/functions.sh
    wget http://functions.sh/sha3.sum -O tmp/sha3.sum
    diff tmp/functions.sha.512.sum tmp/sha3.sum
}
installVerify
exit 1

;fi
clear; source "`dirname "$0"`/functions.sh"; when.sh;echo; logThis "loaded:'functions.sh'"
########### End include functions #######

#alias reload="source ${FILENAME}"

#echo "${FILENAME}";


exit 1


# Set the command character.
commandChar='-'

# Enable shortcommand
enabledCommands[0]='h' # display the help
enabledCommands[1]='r' # recursive

# Create the parameter array.
shortParams[0]="${commandChar}"

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
