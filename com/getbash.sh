#!/bin/bash
# @author:'@jakimfett'
# @license;'cc-by-sa'

# @todo allow targeting?
fileName="${1}"
if [ ! "${fileName}" == '' ]; then
  BASHPLACE=`which bash`
  bashLine=`head -1 ${fileName}`
  echo ${bashLine}
  if [[ "${bashLine}" == *"# !/"* ]]; then
    tail -n +2 "${fileName}" > "${fileName}.bak" && mv "${fileName}.bak" "${fileName}" && sed -i.bak "1s;^;# !${BASHPLACE}\n;" f.sh
    echo
    echo "Replaced:"
    echo "'${bashLine}' with '# !${BASHPLACE}'"
    echo "in '${fileName}'"
    echo
  else
    sed -i.bak "1s;^;# !${BASHPLACE}\n;" f.sh
    echo
    echo "Added '${BASHPLACE}'"
    echo "to '${fileName}'"
  fi

  exit 0
else
  echo "specify a filename, please"
fi
