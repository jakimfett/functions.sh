#!/bin/bash



# NAME variable is used for log file and screen instance naming
NAME="default"

# Log file location
SAVETO="${HOME}/pinglogs"
mkdir -p "$SAVETO"

# ENDPOINT set to nothing by default
ENDPOINT=""

# How high should the ping get before it is logged
MINPING=100

CHECKSITEROOT=0

########### Include functions ###########
if [[ `git status 2>&1| head -1 ` == *"fatal"* ]];then curl --silent http://quince.ocp.org/functions.sh -o ./functions.sh;fi
source "`dirname "$0"`/functions.sh"
if [ ! "`type -t siteRootCheck`" == "function" ];then echo "Please navigate to the website root folder and try again";exit;fi
########### End include functions #######

SCREEN=0

function usageHelp {
  echo
  echo "Usage: $0 COMMAND OPTIONS"
  echo
  echo "Available commands:"
  echo -e "   --default|-d \t Executes writeConfigHeader and createSandboxCertificates in order. Non-interactive."
  echo
  echo -e "   --help|-h \t\t Displays commands and usage info."
  echo -e "   --background|-b \t Executes logging in the background via 'screen -S ' DNS validation in child processes (faster)."
  echo -e "   --force|-f \t\t Forces renewal of domains, regardless of expiry date."
  echo -e "   <empty> \t\t Displays the same info as '$0 help'"
  echo
}

IPCHECK=0
UNKNOWN=0
UNRECOGNIZED=0
for i in "$@"; do
  case "$i" in
  --background|-b)
    # Use screen to run logging in the background
    SCREEN=1
    ;;
  --force|-f)
    # Execute all commands interactively
    FORCERENEW=1
    ;;
  --debug=true|--debug|--debug=false)
    ;;
  --dry-run|--dry-run=true|--dry-run=false)
    ;;
  --help|help|-h|h)
    ;;
  --interactive|interactive|-i|i)
    ;;
  *)
    # Display unknown command warning and help/usage info
    UNKNOWN=$i
    IPCHECK=1
    ;;
  esac
done

if [ -z $@ ];then
  HELP=1
fi

# Echo the full command line options string if a command isn't recognized.
if [ $UNRECOGNIZED -ne 0 ];then
  echo "Command not recognized:"
  echo "'$0 $*'"
fi

# If the user needs help, display help.
if [ $HELP  -ne 0 ];then
  usageHelp
  exit 1
fi

if [ $IPCHECK -ne 0 ];then
  if [[ $i =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    # Endpoint is an IP address
    ENDPOINT=$i
  elif [[ $i =~ ^[A-Za-z]*\.[A-Za-z]{1,5}$ ]]; then
    # Endpoint is a normal domain
    ENDPOINT=$i
  elif [[ $i =~ ^[A-Za-z]{1,10}\.[A-Za-z]*\.[A-Za-z]{1,5}$ ]]; then
    # Endpoint is a subdomain
    ENDPOINT=$i
  else
    echo "No match for domain '${UNKNOWN}'"
    exit
  fi
fi

LOGLOCATION="${SAVETO}/${NAME}_pinglog_$(date +%Y-%m-%d).log"
touch $LOGLOCATION

if [ ! -z $SANITYCHECK ];then
  SANITYLOGLOCATION="${SAVETO}/${NAME}_sanitycheck_pinglog_$(date +%Y-%m-%d).log"
  touch $SANITYLOGLOCATION
fi

function getPingTime {
  for i in "$@"; do
    if [[ $i == *"time"* ]];then
      echo $i | cut -c 6-
    fi
  done
}


ping $ENDPOINT 2>&1 | while read pong 2>&1;do
  pingdate="$(date +%Y-%m-%d\ %T):"
  
  pingduration=$(getPingTime $pong )
  
  echo "$pingdate $pingduration"
  
#echo $pong;
#  awk -v  \
#    -v minping="$MINPING" \
#    -v pingtime="$(awk '"'"'{ print $7 }'"'"' <<< $pong | cut -c 6-)" \
#    -v dead="$(awk '"'"'{ print $5 }'"'"' <<< $pong )" '"'"'{ if (pingtime > minping) {print date, pong } if ( dead == "unreachable" ) {print date, pong } }'"'"' <<< $pong | tee -a $LOGLOCATION
done

exit



COMMAND="ping $ENDPOINT 2>&1"



if [ $SCREEN -ne 0 ];then
  screen -dm -S $NAME bash -c "$COMMAND"
else
  bash -c "$COMMAND"
fi


echo "Saving log to $PINGLOG"
 printf "\nStarting new ping test at: $(date)\n" | tee -a $PINGLOG








