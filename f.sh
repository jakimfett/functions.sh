# !/bin/bash
# @author: @jakimfett
# @description: minimalism, sorta
# @goal: satisfy mel's curiousity
# @practice: never do anything for just one reason
# @advice: when stuck, do something functionally/tactically frivelous with long term strategic benefit.
# @link: https://en.wikipedia.org/wiki/The_Story_of_Mel
# @addendum: http://archive.is/jDFuO
#
# @todo double check input sanitization#
# @todo (better)feature flags mebbe?
# @todo load functions.sh if it exists on the system
# @todo loop user input bits until valid/exit path found
# @todo command line params for config bits
# @todo split actual install into install.sh, obviously
# @todo scan docs for missing/broken links, combine with archive.is replacement?

###
# Author's comment (2018.07.14.2119.gmt.gregorian):
# this is a *very* dangerous tool
# educating yourself mitigates the (karmic) stupidity tax
# remove the following line(s) from execution to violate (some|all) warrenties
#exit 1

###
# hey
# --- # --- # --- # --- #
# submolecular life looks a lot like code.
# --- # --- # --- # --- # --- # --- # --- #
# huh. that's odd.
# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #


# some prerequisites
# @todo autoinstall, or autocompile?
declare depList=('git' 'ssh' 'rsync' 'mlocate' 'traceroute' 'traceroute6' 'dig')
declare depListDev=('man-db' 'etckeeper')
declare -A missingDep
declare -A autoInstall=('man-db')
declare -A autoCompile=('capn-proto')



# grab the epoc timestamp (for determining how long stuff took to run)
declare -A stateVar
stateVar['start']="$(date +%s)"
# we can convert this to a human-readable format later.

# exit code definitions
declare -A exits
exits['done']=0
exits['general']=1
exits['dependency']=2
exits['permissions']=3
exits['debug']=4
exits['failmuffins']=5
exits['userInput']=6
exits['aog']=7
# done with exit codes


# Edit these to break things
declare -A config

# where did we put the rest of our parts?
config['installPath']="$(realpath ~/)/src/f.sh/"

# location for the base directory installation
# realpath makes cross platform easier
config['invokedFrom']="$(pwd)/"
config['self']="${0:1:${#0}}"

# how to present time to the user(s)
config['dateTimeFormat']='%Y.%m.%d:%T (%Z, %z)'

# logging bits
#
# @default.loglevel.hardcoded
# display by default messages with log level greater than this value
config['logLevel']=3

# see how we [stack](/doc/stacks/readme.md) the file path?
# config['logPath']="${config['installPath']}logs"

config['logPath']="${config['invokedFrom']}logs"
if [ ! -d ${config['logPath']} ]; then
	mkdir -p ${config['logPath']}
fi

config['logFile']="${config['logPath']}${config['self']}.$$.log"
echo "Logging to: ${config['logFile']}"
if [ ! -w ${config['logFile']} ]; then
	touch ${config['logFile']}
fi



# done with configuration values (for now...)


logThis "Script start: $(dateConvert ${stateVar['start']}) " 1

exit

###
# Author's comment (2018.07.14.2119.gmt.gregorian):
# this is a *very* dangerous tool
# educating yourself mitigates the (karmic) stupidity tax
# remove the following line(s) from execution to violate (some|all) warrenties
#exit 1

# getting feedback from the user is super important

# make sure that the functions we need actually exist first
if [ ${isInstalled} -ne 1 ];then
	askUser "This system seems to lack functions.sh, download/verify/install?"
	echo $?
	if [ ${userInputYes} ];then
		if [ ${isInstallDir} ];then
			wget https://functions.sh/ -o ./install.sh
			md5sum verify ./install.sh
			if [ ${installerVerified} ];then
				eval ./install.sh
			else
				logThis "Installer failed verifiecation, please download manually." 0
			fi
else
	logThis "Base install cannot be found." 0 'tmp/fsh.install.log'

fi


###
# hey
# --- # --- # --- # --- #
# submolecular life looks a lot like code.
# --- # --- # --- # --- # --- # --- # --- #
# huh. that's odd.
# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #












# mobility, finally!
cd "${config['installPath']}"
ls -lah


echo "#=-                                          -=#"
echo "#=-                                          -=#"
echo "#=-                                          -=#"

echo "#=-  -=#"
echo "#=-  -=#"
echo "#=-  -=#"
echo "#=-  -=#"
echo "#=-  -=#"
echo "Hold on, here we go..."

# @todo - set all variables via user-facing setup questions
# Set the command character.
commandChar='-'

echo

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
fi
