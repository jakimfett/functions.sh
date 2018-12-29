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
# hey
# --- # --- # --- # --- #
# submolecular life looks a lot like code.
# --- # --- # --- # --- # --- # --- # --- #
# huh. that's odd.
# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #



# configuration values
declare -A config['start']="$(date +%s)"




# location for the base directory installation
# realpath makes cross platform easier
config['installTo']="$(realpath ~/)/functions.sh/"
config['invokedFrom']="$(pwd)"
config['self']="${config['invokedFrom']}${0:1:${#0}}"
config['repo']="ssh://git@github.com/jakimfett/functions.sh.git"
config['branch']="development"
# done with configuration values

# state variables
declare -A stateVar

# zero is a decent stand-in for a boolean false, right?
stateVar['depsPresent']=0
stateVar['emptyDir']=0
stateVar['gitRemote']=0
stateVar['isGit']=0
stateVar['doInstall']=0

# determine if the user can sudo
sudoer=$(sudo -n -v 2>&1)
if [[ "${sudoer}" == *"password is required"* ]];then
	stateVar['sudoer']=1
else
	stateVar['sudoer']=0
fi

# done with state variables

# exit code definitions
declare -A exits
exits['done']=0
exits['general']=1
exits['dependency']=2
exits['permissions']=3
# done with exit codes



# prerequisites
declare depList=('git' 'ssh' 'rsync' )
declare -A missingDep
# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #
# mmmm...poetry.
# --- # --- # --- # --- # --- # --- # --- #
# something else that is a lot like life.
# --- # --- # --- # --- #



echo
# iterate through the dependencies list
# check that the system knows that they exist
for singleDep in ${depList[@]}; do

	echo "checking for ${singleDep}..."
	# ask the system where the dependency lives
	declare depLoc="$(which ${singleDep})"

	# add an entry to the missing dependencies array
	# if the dependency location query to the system returns empty
	if [ ! "${depLoc}" ];then
		echo
		echo "dependency '${singleDep}' not located..."
		missingDep["${singleDep}"]=0
	else
		echo "found ${singleDep} at ${depLoc}"
	fi

done;echo



# fail early, fail often
if [ ! "${!missingDep[@]}" == '' ];then
	echo
	echo "error running script."
	echo "missing: ${!missingDep[@]}"
	echo "Please install dependencies to continue."
	echo
	echo "failmuffins"
	exit ${exits['dependency']}
else
	echo "all dependencies found.";echo
fi
# done with prerequisites
echo ${config['installTo']}

# load functions.sh if it exists on the system
if [ -d "${config['installTo']}" ];then

	if [ ! "$(ls -A ~/functions.sh)" ];then
		stateVar['emptyDir']=1
	fi

fi


# clear
echo "#=-              welcome to f.sh                  -=#"
echo
echo "#=- this script manages your local 'functions.sh' -=#"
echo "#=-                                               -=#"
echo "#=-                                               -=#"
echo

if [ ${stateVar['isGit']} == 1 ];then
	echo "#=- a git repository exists at ~/functions.sh     -=#"
	echo "#=- would you like to attempt to update this      -=#"
	echo "#=- existing installation?                        -=#"

	declare userInput
	# solicite the user for some feedback
	read "#=-                                       (y/n/?) -=#" userInput

else

	echo "#=- there is no current installation, install?    -=#"
	echo "#=-                                               -=#"
	echo "#=-                 (y/n/?)                       -=#"


	declare rawInput
	read -p "#=-                    " rawInput

	case "${rawInput}" in
		[yY])
			stateVar['doInstall']=1
			echo "#=-                                               -=#"

			mkdir -p "${config['installTo']}"
			cd "${config['installTo']}"

			# check if remote repo is accessible
			# all we need is the exit code, so any output is sent to /dev/null
			git ls-remote --exit-code -h "${config['repo']}" > /dev/null 2>&1

			if [ "$?" == 0 ];then
				echo "#=-                                               -=#"
				echo "#=- Remote repo exists, attempting to clone...    -=#"

				# double check that we're in the installation directory
				if [ "$(pwd)/" == "${config['installTo']}" ];then
					git clone --single-branch -b "${config['branch']}" "${config['repo']}" .
					if [ "$?" == 0 ];then
						echo "#=-                                               -=#"
						echo "#=- initialized git repository...                 -=#"
					else

						echo "#=-                                               -=#"
						echo "#=-                 failmuffins                   -=#"
					fi
				fi
			else
				echo "#=-                                               -=#"
				echo "#=- remote repository not found, cannot install   -=#"
				echo "#=-                                               -=#"

			fi
		;;
		[nN])
			echo "#=-                                               -=#"
			echo "#=- script will now exit                          -=#"
			echo "#=-                                               -=#"
		;;
		*)
			echo "#=-                                               -=#"
			echo "input '${rawInput}' not recognized."
			echo "#=-                                               -=#"
		;;
	esac
	unset rawInput
fi



exit 13

# mobility, finally!
mkdir -p "${config['installTo']}"
cd "${config['installTo']}"
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

# Keep track of completeds
declare -A doneList

function cleanUp {
	config['end']="$(date +%s)"
	echo
	echo "runtime: $(expr ${config['start']} - ${config['end']})"
	echo
	echo "Completed task(s):"
	echo ${doneList[@]}
	echo

#	an attempt at exit code display
#	encountered race conditions and variable nomenclature questions
#	local code=$?
#	echo "exit code ${?}"
#	if [ "${exits['${?}']}" ]

	echo "tmp folder contents:"
	echo
	ls -lah "./tmp"
	echo
	declare rawInput
	read -p "Clear 'tmp' folder? (y/n/?): " rawInput
	case "${rawInput}" in
		[yY])
			echo "Clearing tmp folder."
			rm -rf ./tmp/*
			echo "tmp folder cleared."
		;;
		[nN])
			echo "Not clearing 'tmp' folder."
		;;
		*)
			echo "input '${rawInput}' not recognized."
		;;
	esac
	unset rawInput
}

#trap cleanUp EXIT INT QUIT TERM


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
