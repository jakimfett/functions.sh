#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# A jumble of things meant to configure, set up, and otherwise assemble
# the functions.sh framework and runtime environment.
#
# Commitment to non-destructive default paths:
#	# Generally, this script attempts to check with the user before doing			#
#	# something (anything) destructive. The use of flags, or mashing your keyboard,	#
#	# will override this non-destructive path, so read the warning lables.			#
#
# Shorthand:
# <name> = a variable, of the designation 'name'
# ~/ = /home/<username>, directory reference
#
# files modified by this script:
includeFilePath="$(realpath ~/.profile)" # <-- single line added to the end
# set this next line to wherever you want your deployment of f.sh to live:
defaultInstallRoot=$(realpath ~/functions.sh) # <-- default install location.


# Yeah, that's actually it for the user configurable values.
#
# Here there be heavy wizardy and/or voodoo programming.
# Which is which is left as an exercise for the end user.
# http://eps.mcgill.ca/jargon/jargon.html#heavy%20wizardry


# This is suboptimal, but *useful*.
if [[ ! "$@" == *"--persistLog"* ]]; then
	clear
fi

echo "The functions.sh default location is:"
echo "${defaultInstallRoot}"

# currently, development is all we've got:
defaultBranch='development'

# where are you getting your code?
#repoSource='https://git.functions.sh/'
repoSource='gitea@badfruit.local:jakimfett/functions.sh.git'
# have you considered mirroring?



# flags - set programmatically, tinker, but make backups

# Get the current directory from the pa
currentDirectory="$(realpath $(pwd) | rev| cut -d'/' -f1 | rev)"
echo
echo "Found current directory as:"
echo "${currentDirectory}"
echo "...done with found 'currentDirectory'."

if [[ "$@" == *"--force"* ]]; then
	echo "Hidden force install protocal enabled, overwriting default install location."
	rm -rf "${defaultInstallRoot}"
fi

if [ -d "${defaultInstallRoot}" ]; then

		echo "Default install location exists, attempting to update."

else
	echo "...default install location is empty, creating..."
	mkdir -p "${defaultInstallRoot}"
	echo "(exit code for directory creation was: '$?')"

	echo "...cloning tool locally..."
	git clone -b "${defaultBranch}" "${repoSource}" "${defaultInstallRoot}"
	echo "(exit code for repo clone was: '$?')"
fi

echo
echo "...moving into install location..."
cd "${defaultInstallRoot}"
echo "Directory path is now:"
pwd

echo
echo "Checking git status"
git status 2>/dev/null > /dev/null
isGit=$?

if [ "${isGit}" == 0 ];then
	echo "The install directory is git."
else [ "${isGit}" == 0]; then
	echo
	echo "Directory at '${defaultInstallRoot}' not a git repo, please debug!"
	exit "${isGit}"
fi


if [[ "$@" == *"--force"* ]]; then
	echo "Forcing install of source to bash profile..."
	cp "${includeFilePath}" "${includeFilePath}.bak"
	cat "${includeFilePath}.bak" | egrep -v 'f.sh|functions.sh' >> "${includeFilePath}.install"
	echo "source '${defaultInstallRoot}/com/usr/aliases.src'" >> "${includeFilePath}.install"
	echo
	echo
	echo "See '${includeFilePath}.bak' file."
	echo "Execute the following command to complete installation:"
	echo "mv ${includeFilePath}.install ${includeFilePath}"
	exit 0
fi

# check if fsh is sourced in a variety of user files, eg .bash_aliases or .profile
fshSourced="$(egrep 'f.sh|functions.sh' $(realpath ~/)/.*  2>/dev/null | grep -v grep | grep source | tail -1 )"

if [ ! -z "${fshSourced}" ]; then
	echo "Found source directive in '$(echo ${fshSourced} | cut -d':' -f1)', debug?"
	echo "${fshSourced}"
	exit 0
else
	echo "source '${defaultInstallRoot}/com/usr/aliases.src'" >> "${includeFilePath}"
	exit 0
fi
