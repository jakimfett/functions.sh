#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# find where you've been, and see if you can get back there.

hist=`realpath ~/.bash_history`
sshdir=`realpath ~/.ssh`
sshauths=`realpath ${sshdir}/authorized_keys`

declare users hosts

echo ${sshdir}
echo got here
if [ -d "${sshdir}" ];then
  echo ssh directory exists

  if [ -f "${sshauths}" ]; then
    cat ${sshauths} | awk '{print $2,$3}'
  fi
fi


if [ -f "${hist}" ];then
  echo command history exists
  echo

  foundPairs=`egrep --only-matching '[A-Za-z0-9_-]+@([A-Za-z0-9-]{1,63}\.)+[A-Za-z]{2,6}' "${hist}" | grep -v 'localhost' | sort | uniq`

  for pair in $foundPairs; do
    ssh -q -o PasswordAuthentication=no -l "${user}" "${host}"
    users=(${users[@]} "`echo "${pair}" | cut -d'@' -f1`")
    hosts=(${hosts[@]} "`echo "${pair}" | cut -d'@' -f2`")
  done;

  for host in ${hosts[@]}; do
    for user in ${users[@]}; do
      echo "${user}@${host}"
      if [ ]
      ssh -q -o PasswordAuthentication=no -l "${user}" "${host}"
      echo $?
      echo
    done
  done

fi
