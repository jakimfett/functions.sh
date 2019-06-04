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



# configuration values
declare -A config['start']="$(date +%s)"




# location for the base directory installation
# realpath makes cross platform easier
config['installTo']="$(realpath ~/)/functions.sh/"
config['invokedFrom']="$(pwd)"
config['self']="${config['invokedFrom']}${0:1:${#0}}"
config['repo']="https://git.functions.sh"
config['branch']="development"
# done with configuration values

# state variables
declare -A stateVar

# zero is a decent stand-in for a boolean false, right?
# feature/state flags, zero is good?
# I bet most of these could be pre-filled with some one-liners...hmm... @todo
stateVar['missingDep']=0
stateVar['installDirExists']=0
stateVar['installDirEmpty']=0
stateVar['installDirHasGit']=0
stateVar['installDirCluttered']=0

stateVar['emptyDir']=0
stateVar['clutteredDir']=0
stateVar['isGit']=0
stateVar['gitRemote']=0
stateVar['doInstall']=0

# determine if the user can sudo
sudoer=$(sudo -n -v 2>&1)
if [[ "${sudoer}" == *"may not run sudo"* ]];then
	stateVar['sudoer']=0
elif [[ "${sudoer}" == *"password is required"* ]];then
	stateVar['sudoer']=1
elif [[ "${sudoer}" == '' ]];then
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
exits['debug']=4
exits['failmuffins']=5
exits['userInput']=6
exits['aog']=7
# done with exit codes



# prerequisites
# @todo autoinstall, or autocompile?
declare depList=('git' 'ssh' 'rsync' 'mlocate')
declare -A missingDep

echo "Prerequisites check, hold plz..."
# iterate through the dependencies list
# check that the system knows that they exist
for singleDep in ${depList[@]}; do

	echo "checking for ${singleDep}..."
	# ask the system where the dependency lives
	declare depLoc="$(which ${singleDep})"

	# add an entry to the missing dependencies array
	# if the dependency location query to the system returns empty
	if [ ! "${depLoc}" ];then

		echo "Sudoer var: ${stateVar['sudoer']} "

		if [ ${stateVar['sudoer']} == 0 ]; then
			missingDep["${singleDep}"]=1
			# increment the missingDep counter
			stateVar['missingDep']=$((${stateVar['missingDep']}+1))

		elif [ ${stateVar['sudoer']} == 1 ]; then
			# install things, hope you're running a debian variant...
			echo "dependenc(y|ies) missing:"
			echo " ${!missingDep[@]}"
			echo
			echo "Attempting to install..."
			sudo apt install "${!missingDep[@]}"
		else
			echo "failmuffins"
			exit ${exits['failmuffins']}
		fi
	#else
		# @debug @todo re-add the logthis function, super useful
		#echo "found ${singleDep} at ${depLoc}"
	fi

done

# check if our installation directory exists,
# then verify the state if so
if [ -d "${config['installTo']}" ];then
	# directory exists
	stateVar['installDirExists']=1

	# check for directory status and set state variables
	if [ -d "${config['installTo']}/.git/" ]; then
		stateVar['installDirHasGit']=1
	elif [ "$(ls -A ${config['installTo']})" ]; then
		stateVar['installDirCluttered']=1
	else
		stateVar['installDirEmpty']=1 # double negatives are as good as single negatives
	fi
fi


# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #
# mmmm...poetry.
# --- # --- # --- # --- # --- # --- # --- #
# something else that is a lot like life.
# --- # --- # --- # --- #

# @todo uncomment for visual streamlining
# clear

echo "#=-              welcome to f.sh                  -=#"
echo
echo "#=-                                               -=#"
echo "#=- this script manages your local 'functions.sh' -=#"
echo "#=-                                               -=#"
echo "#=-                                               -=#"
echo

if [ ! ${stateVar['missingDep']} == 0 ]; then
	echo "#=-                                               -=#"
	echo "#=-             error running script.             -=#"
	echo "#=-           missing dependenc(y|ies):           -=#"
	echo "total - ${stateVar['missingDep']}"
	echo "		${!missingDep[@]}"
	echo "#=-                                               -=#"
	echo "#=- Please install dependencies to continue, eg:  -=#"
	# help out the end user when possible by spitting out the remedial commands.
	echo "		apt install ${!missingDep[@]}"
	echo "#=-                                               -=#"
	exit ${exits['dependency']}
else
	echo "#=-        ...all dependencies found...           -=#"
	echo "#=-                                               -=#"
fi

# @todo - this logic needs streamlined a bit
# currently checks if empty dir, then git dir, then non-git stuffs.
if [ ${stateVar['installDirExists']} == 0 ]; then

	echo "#=-                                               -=#"
	echo
	ls -lah "${config['installTo']}"
	echo
	echo "#=-         Install directory nonexistent:        -=#"
	echo "#=-           Create install directory?           -=#"
	echo "#=-                  (y/n/?):                     -=#"
	declare rawInput
	read -p 'input -->               ' rawInput

	case "${rawInput}" in
		[yY]|[yY][eE][sS]) # case-insensitive match for 'y' or 'yes'
			echo "#=-                                               -=#"
			echo "#=-    Positive answer, creating directory...     -=#"
			mkdir -p "${config['installTo']}"

			if [ ! -d "${config['installTo']}" ]; then
				echo "#=-                                               -=#"
				echo "#=-          Directory creation failed,           -=#"
				echo "#=-       please debug/set permissions for        -=#"
				echo "#=-            your install location              -=#"
				echo "#=-                and try again.                 -=#"
				echo "#=-                                               -=#"
				echo "		debug: 	ls -lah ${config['installTo']}"
				echo "#=-                   and/or                      -=#"
				echo "		set: 	chmod u+x ${config['installTo']}"
				echo "#=-                                               -=#"
				echo "#=-                                               -=#"
				echo "#=-                program exits                  -=#"
				echo
				exit ${exits['permissions']}
			else
				stateVar['installDirExists']=1
				echo "#=-              Directory created.               -=#"
				echo "#=-                                               -=#"
			fi

		;;
		[nN]|[nN][oO])
			echo "#=-            Not creating directory.            -=#"
			# @todo add cache/tmp run location option?
			echo "#=-                                               -=#"
			echo "#=-                program exits                  -=#"
			exit ${exits['userInput']}

		;;
		*)
			echo "Write in option, shiney."
			exit ${exits['userInput']}
		;;
	esac
	unset rawInput # collect yer garbage

else
	echo "#=-       ...install directory found...           -=#"
	echo "#=-                                               -=#"
fi


echo "#=-        ...checking for git repo...            -=#"
echo "#=-                                               -=#"

if [ ! ${stateVar['installDirHasGit']} == 0 ]; then
	echo "#=- a repository exists at the install location   -=#"
	git status ${config['installTo']}
	echo "#=-                                               -=#"
	echo "#=- would you like to attempt to update this      -=#"
	echo "#=- existing installation?                        -=#"
	echo "#=-                  (y/n/?):                     -=#"
	declare rawInput
	read -p 'input -->               ' rawInput

	case "${rawInput}" in
		[yY]|[yY][eE][sS]) # case-insensitive match for 'y' or 'yes'
			echo "#=-                                               -=#"
			echo "#=-    Positive answer, attempting to update...   -=#"
			# git remote -v
			# grep "upstream==$repoURL"
			# git add/set upstream?
			# git fetch
			# echo git merge upstream $branch

		;;
		[nN]|[nN][oO])
			echo "#=-                Not updating.                  -=#"
			echo "#=-                                               -=#"
			echo "#=-                program exits                  -=#"
			exit ${exits['userInput']}

		;;
		*)
			echo "Write in option, shiney."
			exit ${exits['userInput']}
		;;
	esac
	unset rawInput

else

	echo "#=-     no git repo at target install location.   -=#"
	echo "#=-                                               -=#"
fi

if [ ! ${stateVar['installDirCluttered']} == 0 ]; then
	# something lives here, but it's not us.

	echo "#=-  Misc files exist in target install location: -=#"
	ls -lah ${stateVar['installTo']}
	echo "#=-                                               -=#"
	echo "#=-             Please resolve.                   -=#"

	echo
	exit ${exits['failmuffins']}
else
	echo "#=-          install directory empty.             -=#"
	echo "#=-                                               -=#"
fi



if [ ${stateVar['installDirCluttered']} == 0 ] \
	&& [ ${stateVar['installDirHasGit']} == 0 ] \
	&& [ ! ${stateVar['installDirExists']} == 0 ]; then
	echo "#=-                                               -=#"
	echo "#=-      ...functions.sh not found, install?      -=#"

	# solicite the user for some feedback
	# @todo functionize this (again)
	echo "#=-                  (y/n/?):                     -=#"
	declare rawInput
	read -p 'input -->               ' rawInput


	case "${rawInput}" in
		[yY]|[yY][eE][sS])
			stateVar['doInstall']=1

		;;
		[nN]|[nN][oO])
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

	if [ ! ${stateVar['doInstall']} == 0 ]; then
		echo "#=-                                               -=#"

		if [ ! -d "${config['installTo']}" ]; then
			# yes, in theory we created this earlier.
			# double checking tho.
			mkdir -p "${config['installTo']}"
		fi

		# move to the install location so we can locally reference things
		cd "${config['installTo']}"
		echo "#=-                                               -=#"
		echo "Pinging remote repo: '${config['repo']}'"
		echo "#=-                                               -=#"
		# check if remote repo is accessible
		# all we need is the exit code, so any output is sent to /dev/null
		git ls-remote --exit-code -h "${config['repo']}" > /dev/null 2>&1

		if [ "$?" == 0 ];then
			echo "#=-                                               -=#"
			echo "#=- Remote repo exists, attempting to clone...    -=#"
			echo "#=-                                               -=#"

			# double check that we're in the installation directory
			if [ "$(pwd)/" == "${config['installTo']}" ];then
				echo
				git clone --single-branch -b "${config['branch']}" "${config['repo']}" "${config['installTo']}"
				echo
				git status "${config['installTo']}"
				echo
				if [ "$?" == 0 ];then
					echo "#=-                                               -=#"
					echo "#=-        initialized git repository.            -=#"
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
	else
		echo "not installing"
	fi
else
	echo
	echo
	echo "...something went wrong, plz debug:"
	echo
	echo "path: '${config['installTo']}'"
	echo
	ls -lah "${config['installTo']}"
	echo
	git status "${config['installTo']}"
	echo
	exit ${exits['failmuffins']}
fi


echo we got here
exit 5





# mobility, finally!
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
