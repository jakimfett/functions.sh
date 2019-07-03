#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# A jumble of things meant to configure, set up, and otherwise assemble
# the functions.sh framework and runtime environment.

# set this to wherever you want your deployment of f.sh to live:
defaultInstall=$(realpath ~/)
echo "Set to install functions.sh to ${defaultInstall}"


# Yeah, that's actually it for the user configurable values.
#
# Here there be heavy wizardy and/or voodoo programming.
# Which is which is left as an exercise for the end user.
# http://eps.mcgill.ca/jargon/jargon.html#heavy%20wizardry


# flags - set programmatically, tinker, but make backups

# check if fsh is sourced in a variety of user files, eg .bash_aliases or .profile
fshSourced="$(grep 'f.sh' $(realpath ~/).* 2>/dev/null | grep source)"
echo
echo "Found the following"
echo "${fshSourced}"
exit 0 
# Get the current directory from the pa
currentDirectory="$(realpath $(pwd) | rev| cut -d'/' -f1 | rev)"

git status 2>/dev/null > /dev/null
isGit=$?

if [ -z "${fshSourced}" ]; then
	echo "Found sourced version of f.sh, use?"
	echo "${fshSourced}"
	exit 0
elseif []; then
fi


echo 'failmuffins'
exit 13

# if we haven't already, declare the config array
#if [ -z "$(declare -p 'config' 2> /dev/null)" ]; then
	declare -A stateVar
#fi

# Where from and what branch are we installing from?
config['repo']="https://git.functions.sh"
declare -p 'config'
config['branch']="development"
declare -p 'config'

echo ${config['repo']}
echo ${config['branch']}
echo ${config[$@]}

exit

# some prerequisites
# @todo autoinstall, or autocompile?
# @todo move base install to `/install.sh`
declare depList=('git' 'ssh' 'rsync' 'mlocate' 'gcc|clang' )
declare -A missingDep

# Keep track of completeds
declare -A doneList

# zero is a decent stand-in for a boolean false, right?
# feature/state flags, zero is good?
# I bet most of these could be pre-filled with some one-liners...hmm... @todo
stateVar['missingDep']=0
stateVar['installDirExists']=0
stateVar['installDirEmpty']=0
stateVar['installDirHasGit']=0
stateVar['installDirCluttered']=0

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
echo "${sudoer}"
# done with state variables

exit


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
			echo "dependency missing:"
			# @todo install all dependencies at the end if any are missing
			# feature flags for use of dependencies that are missing after prereq check
			echo "${singleDep}"
			echo
			echo "Attempting to install..."
			sudo apt install "${singleDep}" -y
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
if [ -d "${config['installPath']}" ];then
	# directory exists
	stateVar['installDirExists']=1

	# check for directory status and set state variables
	if [ -d "${config['installPath']}/.git/" ]; then
		stateVar['installDirHasGit']=1
	elif [ "$(ls -A ${config['installPath']})" ]; then
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
	ls -lah "${config['installPath']}"
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
			mkdir -p "${config['installPath']}"

			if [ ! -d "${config['installPath']}" ]; then
				echo "#=-                                               -=#"
				echo "#=-          Directory creation failed,           -=#"
				echo "#=-       please debug/set permissions for        -=#"
				echo "#=-            your install location              -=#"
				echo "#=-                and try again.                 -=#"
				echo "#=-                                               -=#"
				echo "		debug: 	ls -lah ${config['installPath']}"
				echo "#=-                   and/or                      -=#"
				echo "		set: 	chmod u+x ${config['installPath']}"
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
	git status ${config['installPath']}
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
	ls -lah ${stateVar['installPath']}
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

		if [ ! -d "${config['installPath']}" ]; then
			# yes, in theory we created this earlier.
			# double checking tho.
			mkdir -p "${config['installPath']}"
		fi

		# move to the install location so we can locally reference things
		cd "${config['installPath']}"
		echo "#=-                                               -=#"
		echo
		echo "Pinging remote repo: '${config['repo']}'"
		echo
		echo "#=-                                               -=#"
		# check if remote repo is accessible
		# all we need is the exit code, so any output is sent to /dev/null
		git ls-remote --exit-code -h "${config['repo']}" > /dev/null 2>&1

		if [ "$?" == 0 ];then
			echo "#=-                                               -=#"
			echo "#=- Remote repo exists, attempting to clone...    -=#"
			echo "#=-                                               -=#"

			# double check that we're in the installation directory
			if [ "$(pwd)/" == "${config['installPath']}" ];then
				echo
				git clone --single-branch -b "${config['branch']}" "${config['repo']}" "${config['installPath']}"
				echo
				git status "${config['installPath']}"
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
	echo "path: '${config['installPath']}'"
	echo
	ls -lah "${config['installPath']}"
	echo
	git status "${config['installPath']}"
	echo
	exit ${exits['failmuffins']}
fi


echo we got here
exit 5




function cleanUp {
	# @todo remove dependencies (if any were installed?)
	# if [missingdeplist > 0 ];then
	# 	sudo apt purge -y
	stateVar['end']="$(date +%s)"
	echo
	echo "runtime: $(expr ${stateVar['start']} - ${stateVar['end']})"
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

# if it exits, it cleans up itself, or it gets the logic probe again.
#trap cleanUp EXIT INT QUIT TERM
