#!/bin/bash
# @author:''
# @license;'cc-by-sa'
#
# @todo - scan the network for open ssh, attempt to auth with provided keypair(s)

net=$(ifconfig | grep "inet " | grep -v 127 | awk '{print $2}')
nmap -n -sn ${net}/24 -oG - | awk '/Up$/{print $2}'
