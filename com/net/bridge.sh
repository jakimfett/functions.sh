#!/bin/bash
# @author:'jakimfett'
# @license: 'cc-by-sa'
#
# Constructed with bits from http://archive.is/xs4zQ

bridgeFlag="-N -R"
bridgePort=60022
remoteHost='ssh.jakimfett.com'
remoteUser='bridge'

newBridge() {
  /usr/bin/ssh ${bridgeFlag} ${bridgePort}:localhost:22 ${remoteUser}@${remoteHost} &
}

isBridging() {
	ps aux | grep "${bridgeFlag} ${bridgePort}" | awk '{print $2}'
}

if [ ! isBridging ]; then
  echo "no bridge found, creating"
  # newBridge
fi
