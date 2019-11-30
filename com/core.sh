#!/bin/bash
#
# author: @jakimfett
# license: cc-by-sa
#
# Common functions and utilities for Debian-ish Linux shell scripts.
# This is a dangerous toy, read carefully before using in your shop.
# Test it in a copy of development, with your use case, first.

# @todo - integrate instantiation with documentation, for conciseness and strong coupling.
#
# @TODO - Add auto update to scripts, with md5 verify.
# @TODO - Refactor to use local variables whenever possible.
# @TODO - Add usage examples for all scripts? (possibly autogenerate?)

########### Usage Help ###########

# Checks if the script is being run directly or sourced.
if [ "$0" == "$BASH_SOURCE" ];then
  # Display functions.sh usage information.
  function functionsUsageHelp {
    echo
    echo "Available commands in functions.sh:"
    echo -e "\t--search|-s <functionName> \t\t Locates all usages of the function. Supports partial function names."
    echo -e "\t--list|-l \t\t\t\t Lists all shared function names, with descriptions."
    echo -e "\t--allusage|-a \t\t\t\t Lists usage locations of all shared functions."
    echo
    echo "Available (optional) variables:"
    echo -e "\t\$CHECKSUDO\tdefault is zero \t check for ability to run sudo commands if set to non-zero"

# Check if VERBOSITY variable is instantiated before setting to zero
if [ -z $VERBOSITY ];then
	VERBOSITY=2
    echo -e "\t\$VERBOSITY\tdefault is two \t\t severity filtering of status/debug text if non-zero, 9 being 'all'."
fi

# Default to protecting the user, ni?
if [ -z $DRYRUN ];then
	DRYRUN=1
    echo -e "\t\$DRYRUN\t\tdefault is non-zero \t performs only non-destructive operations"
fi

    echo -e "\t\$EXEC\t\tdefault is non-zero \t executes sanity checks before continuing, set to zero to disable"
    echo -e "\t\$INTERACTIVE\tdefault is zero \t displays yes/no interactive elements for the user if set to non-zero"
    echo
    echo
    echo "Include this block at the top of your script to allow access to functions:"
    echo
    echo -e '\t########### Include functions ###########'
    echo -e '\tif [[ `find ~/ -type f -iname "functions.sh" 2>&1` == *"No such file"* ]];then echo "functions.sh not found, exiting";exit 1;fi'
    echo -e '\tsource "`dirname "$0"`/functions.sh"'
    echo -e '\t########### End include functions #######'
    echo
  }

  # List all functions and their descriptions.
  function listAllFunctions {
    echo
    echo "List of all shared functions:"
    echo "--"
    cat $0 | egrep -v "  function [A-Za-z]* {" | egrep -B1 "function [A-Za-z]* {" | awk '{$1=$1;print}'
    echo
    echo
    echo "List of all non-shared functions:"
    echo "--"
    cat $0 | egrep -B1 "  function [A-Za-z]* {" | awk '{$1=$1;print}'
  }

  # Search for usage of all shared functions.
  function locateAllFunctionUsage {
    for i in `egrep "function [A-Za-z]* {" tools/functions.sh | egrep -v "  function [A-Za-z]* {" | awk '{print $2}'`;do
      ISUSED=$(egrep -rn "$i" `dirname "$0"` --exclude=README.md --exclude=functions.sh)

      if [[ ! -z $ISUSED ]];then
        echo
        locateFunctionUsage $i
      fi
    done
  }

  # Search usage of a specific function.
  function locateFunctionUsage {
    local FUNCTIONNAME="$1"
    echo
    echo "Usage list for $FUNCTIONNAME:"
    echo
    grep -rn "$FUNCTIONNAME" `dirname "$0"` --exclude=README.md --exclude=functions.sh | grep -v "function $FUNCTIONNAME {" | sed 's/:/ /g' | awk '{print "File \""$1"\", line #"$2":"}{system("sed -n "$2"p "$1)}{print ""}'
  }

  case "$1" in
    --search|-s)
      # Locate usages of shared functions
      locateFunctionUsage $2
      ;;
    --list|-l)
      # List all functions in the functions script, with descriptions
      listAllFunctions
      ;;
    --allusage|-a)
      # List all functions in the functions script, with descriptions
      locateAllFunctionUsage
      ;;
    --help|*)
      # Displays help and usage info
      functionsUsageHelp
      exit 1
      ;;
  esac
fi

########### End of Usage Help ###########


########### Set pre-function flags ###########

# pass in the 'help' flag if the core is run without arguments
if [ -z "$*" ];then
  HELP=1
fi

# @TODO - need to refactor this to correctly parse non-delimited options, eg `./scriptname.sh -dm`
# @TODO - add functions.sh file update, and AUTOUPDATE variable.
for i in "$@"; do
  case "$i" in
  --loglevel=[0-9]|-l=[0-9])
    # Displays help and usage info
	VERBOSITY=$(echo "$i" | grep -o '[0-9]')
	echo "${VERBOSITY}"
	exit
    #LOGDISPLAY=$(echo "${@}" | grep -o '[0-9]')
    ;;
  --dry-run|--dry-run=true)
    # Displays help and usage info
    DRYRUN=1
    ;;
  --dry-run=false)
    # Displays help and usage info
    DRYRUN=0
    ;;
  --interactive|interactive|-i|i)
    # Execute all commands interactively
    INTERACTIVE=1
    ;;
  --help|help|-h|h)|*)
    echo "${@}"
	echo
    # Displays help and usage info
    HELP=1
    ;;
  esac
done

########### End pre-function flags ###########

# possibly the most useful bit, right here: the `logThis` function.
# It's a function that logs things conveniently.
# This entire thing is functions, but this one is the function that started it all.


# @logThis.desc
# Text output handling for logging
#
# @logThis.syntax:
# `logThis "Message"`
# `logThis "Message" <int> <filepath>`
#
# @logThis.returns
#	* standard
#
# @logThis.comment
# 	Take time to refactor. Deprication is doable, and optimizing is important.
function logThis {
	# the passed-in message, from function usage, this is mandatory
    local message="${1}" # @todo probably need to sanitize the message somehow.
	if [ -z "${message}" ];then
		echo "Message cannot be empty!"
		return 6
	else
		# parameters 2+ are optional...
	    local logging_level
		local log_file

	    # ...check if they're set, if not, set from globals
	    if [ ! -z "${2}" ] ; then
			# Set the log level (ideally) from the passed-in value...
			logging_level="${2}"

		elif [ ! -z "${config['logLevel']}" ] ; then # config is set, passin isn't.
			# ...next from the script default...
	        logging_level="${config['logLevel']}"

	    else
			# and finally, if the log level has no set default, use max verbosity
	        logging_level=10
	    fi



	    if [ ! -z "${3}" ] ; then
	        log_file="${3}"
		else
			log_file="${config['logFile']}"
	    fi

		local dateTimeNow=$(date +"${config['dateTimeFormat']}")
	    if [ "${logging_level}" -le "${config['logLevel']}" ] ; then
	        echo "${dateTimeNow}: ${message}" | tee -a ${log_file}
		else
			echo "${dateTimeNow}: ${message}" >> ${log_file}
	    fi
	fi
}

########### Sanity Checks ###########



# Check for process ID file
# @TODO - refactor PID logging.
#PIDFILE="/tmp/$$.pid"
#if [ -f $PIDFILE ]; then
#  printf "\nScript is already running as PID `cat $PIDFILE`\n"
#  exit 1;
#fi

#if [ ! -f $PIDFILE ]; then
#  echo $$ > $PIDFILE
#fi


function cleanup {
	# Ensure that child processes have finished before designating time of exit.
  wait

  #  rm $PIDFILE

  logThis "Done." 1

}

# On exit, do cleanup
trap cleanup EXIT

# Check if defaults variable is instantiated before setting to one
if [ -z $BASEDIR ];then
  BASEDIR=`pwd`
fi

# Check if defaults variable is instantiated before setting to one
if [ -z $EXEC ];then
  EXEC=1
fi

# Check if UNRECOGNIZED variable is instantiated before setting to zero
if [ -z $UNRECOGNIZED ];then
  UNRECOGNIZED=0
fi

# Check if HELP variable is instantiated before setting to zero
if [ -z $HELP ];then
  HELP=0
fi

# Check if the CHECKSUDO variable is set before setting to zero
if [ -z $CHECKSUDO ];then
  CHECKSUDO=0
fi

# Check if LOGSFOLDER variable is instantiated before setting to default
if [ -z $LOGSFOLDER ];then
  LOGSFOLDER="${BASEDIR}/logs"
fi

# Check if LOGFILE variable is instantiated before setting to default
if [ -z $LOGFILE ];then
  LOGFILE="${LOGSFOLDER}/`basename ${0}`.`date "+%Y-%m-%d_%H%M.%S"`.log"
fi

# Check if TEMPFOLDER variable is instantiated before setting to zero
if [ -z $TEMPFOLDER ];then
  TEMPFOLDER="${BASEDIR}/tmp"
fi

# Check if REPORTFOLDER variable is instantiated before setting to zero
if [ -z $REPORTFOLDER ];then
  REPORTFOLDER="${BASEDIR}/reports"
fi

# Check if INTERACTIVE variable is instantiated before setting to zero
if [ -z $INTERACTIVE ];then
  INTERACTIVE=0
fi

########### End of Sanity Checks ###########


########### Functions - Alphabetize or else ###########

# Create autogen folder if it doesn't exist
function autogenFolderCheck {
  if [ ! -d "$LOGSFOLDER" ];then
    mkdir -p "$LOGSFOLDER"
  fi

  if [ ! -f "$LOGFILE" ];then
    touch "$LOGFILE"
  fi

  if [ ! -d "$REPORTFOLDER" ];then
    mkdir -p "$REPORTFOLDER"
  fi
}

# Prints the current date and time inline.
function dateTimeNow {
  # If date format is changed, also change LOGFILE variable instantiation format (above).
  date "+%Y-%m-%d_%H%M.%S"
}

# Check if a user has access to the SUDO command, and set the ISSUDO variable appropriately
function checkSudo {
  ISSUDOTEST=$(sudo -v 2>&1)
  ISSUDO=0
  if [ -z "$ISSUDOTEST" ];then
    ISSUDO=1
  fi
}

# Get user input
# @todo - generalize this and fix clunkyness of command/messaging variables.
#
# Syntax is `getUserInputYesNo MESSAGE COMMAND_ON_YES MESSAGE_ON_YES COMMAND_ON_NO MESSAGE_ON_NO`
function getUserInputYesNo {
  MESSAGE="$1 [y/N]: "
  COMMAND_ON_YES="$2"
  MESSAGE_ON_YES="$3"
  COMMAND_ON_NO="$4"
  MESSAGE_ON_NO="$5"

  ERROR_MESSAGE="Please input either 'yes' or 'no' to continue."

  read -r -p "`echo -e "$MESSAGE"`" response
  case $response in
    [yY][eE][sS]|[yY])
      echo -e "$MESSAGE_ON_YES"
      if [ ! $ISSUDO -eq 0 ];then
          echo "$COMMAND_ON_YES" | sudo bash
      else
          echo "$COMMAND_ON_YES" | bash
      fi
      ;;
    [nN][oO]|[nN])
      echo "$MESSAGE_ON_NO"
      if [ ! $ISSUDO -eq 0 ];then
          echo "$COMMAND_ON_NO" | sudo bash
      else
          echo "$COMMAND_ON_NO" | bash
      fi
      ;;
    *)
      echo -e "$ERROR_MESSAGE\n"

      getUserInputYesNo "$1" "$2" "$3" "$4" "$5"
      ;;
  esac
}


function dateConvert {
	date -j -f %s $1 +"${config['dateTimeFormat']}"
}

function enumGetter {
    # @todo - implement using force-case'd text input?
    logThis "function 'enumGetter' is not implemented!"
    exit 1;
}

# Text output handling for logging
# Syntax is `logThis-deprecated_usage_needs_fixed LOGLEVEL MESSAGE LOGFILE(optional)`
#
# @changelog:
# 2018_03_29    19.53.10 (PDT/GMT-0700)
# re-organized parameter order to make more usage sense
function logThis-deprecated_usage_needs_fixed {
    logThis "function usage deprecated"
    exit 1;
}



# @todo - implement
function char2Int {
    echo "implement:# printf -v int '%d\n'  "$1" 2>/dev/null"
}

# Outputs a horizontal line to the logfile
# Syntax is logHL LOGLEVEL(optional)
function logBreak {
  local logging_level=2
  if [ ! -z "${1}" ];then
    logging_level="${1}"
  fi
  logThis "####################################################" "${logging_level}"
}

# Create temp folder if it doesn't exist
function tempFolderCheck {
  if [ ! -d "$TEMPFOLDER" ];then
    mkdir -p "$TEMPFOLDER"
  fi
}

########### End of functions ###########


########### Execute Defaults ###########

# If defaults variable is set to a non-zero value, run these functions by default

if [ $EXEC ];then
  logThis "Executing default functions..." 9

  autogenFolderCheck

  tempFolderCheck

  if [ $CHECKSUDO -ne 0 ];then
    checkSudo
  fi

  logThis "Defaults executed." 9

  logThis "Begin processing" 1

fi

########### End of Execute Defaults ###########
