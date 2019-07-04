#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# A jumble of things meant to configure, set up, and otherwise assemble
# the functions.sh framework and runtime environment.

# set this to wherever you want your deployment of f.sh to live:
defaultInstallRoot=$(realpath ~/functions.sh)
echo
clear
echo "(returning zero is a success, oddly enough...)"
echo
echo "The functions.sh default location is:"
echo "${defaultInstallRoot}"


# Yeah, that's actually it for the user configurable values.
#
# Here there be heavy wizardy and/or voodoo programming.
# Which is which is left as an exercise for the end user.
# http://eps.mcgill.ca/jargon/jargon.html#heavy%20wizardry

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
echo "The install directory is git?"
echo "${isGit}"

if [ "${isGit}" -ne 0 ]; then
	echo
	echo "Directory at '${defaultInstallRoot}' not a git repo, please debug!"
	exit "${isGit}"
fi


if [[ "$@" == *"--force"* ]]; then
	echo "Forcing install of source to bash profile..."
	cp $(realpath ~/.profile) $(realpath ~/.profile).bak
	cat $(realpath ~/.profile).bak | egrep -v 'f.sh|functions.sh' >> $(realpath ~/.profile).install
	echo "source '${defaultInstallRoot}/com/usr/aliases.src'" >> "$(realpath ~/.profile).install"
	echo
	echo "See '$(realpath ~/.profile).bak' file."
	echo "Use 'mv $(realpath ~/.profile).install $(realpath ~/.profile)' to complete the installation."
	exit 0
fi

# check if fsh is sourced in a variety of user files, eg .bash_aliases or .profile
fshSourced="$(egrep 'f.sh|functions.sh' $(realpath ~/)/.*  2>/dev/null | grep -v grep | grep source | tail -1 )"

if [ ! -z "${fshSourced}" ]; then
	echo "Found source directive in '$(echo ${fshSourced} | cut -d':' -f1)', debug?"
	echo "${fshSourced}"
	exit 0
else
	echo "source '${defaultInstallRoot}/com/usr/aliases.src'" >> $(realpath ~/.profile)
	exit 0
fi
