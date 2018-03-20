#!/bin/bash
#
# author: @jakimfett
# license: cc-by-na
#
# Common functions and utilities for Debian Linux shell scripts


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
    echo -e "\t\$LOGLEVEL\tdefault is two \t\t displays extra status/debug text if set to non-zero"
    echo -e "\t\$DRYRUN\t\tdefault is zero \t prints output and check results, but doesn't actually write any values"
    echo -e "\t\$EXEC\t\tdefault is non-zero \t executes sanity checks before continuing, set to zero to disable"
    echo -e "\t\$INTERACTIVE\tdefault is zero \t displays yes/no interactive elements for the user if set to non-zero"
    echo
    echo
    echo "Include this block at the top of your script to allow access to functions:"
    echo
    echo -e '\t########### Include functions ###########'
    echo -e '\tif [[ `git status 2>&1| head -1 ` == *"fatal"* ]];then curl https://cdn.irregular.team/functions.sh -o ./functions.sh;fi'
    echo -e '\tsource "`dirname "$0"`/functions.sh"'
    echo -e '\tif [ ! "`type -t siteRootCheck`" == "function" ];then echo "Please navigate to the website root folder and try again";exit;fi'
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

if [ -z "$*" ];then
  HELP=1
fi

# @TODO - need to refactor this to correctly parse non-delimited options, eg `./scriptname.sh -dm`
# @TODO - add functions.sh file update, and AUTOUPDATE variable.
for i in "$@"; do
  case "$i" in
  --loglevel=[0-9]|-l=[0-9])
    # Displays help and usage info
    LOGLEVEL=$(echo "${@}" | grep -o '[0-9]')
    ;;
  --dry-run|--dry-run=true)
    # Displays help and usage info
    DRYRUN=1
    ;;
  --dry-run=false)
    # Displays help and usage info
    DRYRUN=0
    ;;
  --help|help|-h|h)
    # Displays help and usage info
    HELP=1
    ;;
  --interactive|interactive|-i|i)
    # Execute all commands interactively
    INTERACTIVE=1
    ;;
  *)
    echo
    ;;
  esac
done

########### End pre-function flags ###########


########### Sanity Checks ###########

# Refuse to run if user is root - can cause issues with chown
if [ $USER == "root" ];then
  echo "This script should not be run as root or via sudo!"
  echo "Please re-run as an unprivileged user."
  echo "Script will now exit."
  exit 1
fi

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

# Check if LOGLEVEL variable is instantiated before setting to zero
if [ -z $LOGLEVEL ];then
  LOGLEVEL=2
  if [ ! -z "${DEBUG}" ];then
    LOGLEVEL="${DEBUG}"
    echo
    echo "Script uses DEBUG, which is deprecated. Please refactor."
    echo
  else
    DEBUG="${LOGLEVEL}"
  fi
fi

function cleanup {
  wait

  logThis 1 "Done."

#  rm $PIDFILE
}

# On exit, do cleanup
trap cleanup EXIT

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

# Check if the CHECKSITEROOT variable is set before setting to default
if [ -z $CHECKSITEROOT ];then
  CHECKSITEROOT=1
fi

# Check if LOGSFOLDER variable is instantiated before setting to default
if [ -z $LOGSFOLDER ];then
  LOGSFOLDER="./logs"
fi

# Check if LOGFILE variable is instantiated before setting to default
if [ -z $LOGFILE ];then
  LOGFILE="${LOGSFOLDER}/${0}.`date "+%Y-%m-%d_%H%M.%S"`.log"
fi

# Check if TEMPFOLDER variable is instantiated before setting to zero
if [ -z $TEMPFOLDER ];then
  TEMPFOLDER="./temp"
fi

# Check if REPORTFOLDER variable is instantiated before setting to zero
if [ -z $REPORTFOLDER ];then
  REPORTFOLDER="./reports"
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

# Text output handling for logging
# Syntax is `logThis LOGLEVEL MESSAGE LOGFILE(optional)`
function logThis {
  local logging_level=$1
  local message=$2

  local file_name="${LOGFILE}"
  if [ ! -z $3 ];then
    file_name="${3}"
  fi

  if [ -z "${logging_level}" ];then
    logging_level=$LOGLEVEL
  fi

  if [ $logging_level -le $LOGLEVEL ];then
    echo "`date +%Y-%m-%d_%H:%M.%S:` ${message}" | tee -a $file_name
  fi
}

# Outputs a horizontal line to the logfile
# Syntax is logHL LOGLEVEL(optional)
function logHL {
  local logging_level=2
  if [ ! -z $1 ];then
    logging_level="${1}"
  fi
  logThis $logging_level "####################################################"
}

# Specify that the script must be run from the site root
function siteRootCheck {
  ISSITEROOT=$(ls -a|grep .git)
  ISTOOLSDIR=$(pwd | rev | cut -d"/" -f1 | rev)

  if [[ ! -z $ISSITEROOT ]]; then
    logThis 7 "Currently in tools root folder..."

  elif [[ $ISTOOLSDIR == "scripts" ]]; then
    logThis 7 "Currently in scripts folder, changing directory to root..."
    cd ../
    siteRootCheck

  else
    echo $ISTOOLSDIR
    echo "Please navigate to the scripts folder and try again"
    exit 1
  fi
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
  logThis 9 "Executing default functions..."


  if [ $CHECKSITEROOT -ne 0 ];then
    siteRootCheck
  fi

  autogenFolderCheck

  tempFolderCheck

  if [ $CHECKSUDO -ne 0 ];then
    checkSudo
  fi

  logThis 9 "Defaults executed."

fi

########### End of Execute Defaults ###########
