# Prepend functions.sh/ 
PATH="~/functions.sh:${PATH}"

#Adding the local kanban dev location to the PATH
export PATH="~/bin/kanban.bash:${PATH}"

# I like nano.
export EDITOR=nano
git config --global core.editor nano

# Re-source the aliases file
source ~/.bash_aliases

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


#if [[ ! "${PATH}" == *"functions.sh"* ]]; then
#	export PATH="~/functions.sh:${PATH}"
#fi

# set PATH so it includes user's local functions.sh if it exists
if [ -d "$HOME/functions.sh" ] ; then
    PATH="$HOME/functions.sh:$PATH"
fi
