#!/bin/bash
# @author:'@jakimfett'
# @license;'cc-by-sa'
#
# Connect to a given machine via mosh, the mobile shell.
# See https://mosh.org/#usage

user='root'
host=$1

if [[ "${host}" == *"@"* ]];then
	user=$(echo $host | cut -d'@' -f1)
	host=$(echo $host | cut -d'@' -f2)
fi

isDown=1

function pingHost {
	ping -q -c 1 -w 3 $1 > /dev/null
	isDown=$?
}

pingHost $host

while [ $isDown -ne 0 ]; do
	echo "Host ${host} is down, waiting..."
	sleep 3
	pingHost $host
	echo "Host status now: ${isDown}"
done

mosh --server=/usr/bin/mosh-server --family=prefer-inet6 --ssh='ssh -vv -i ~/.ssh/id_ed25519' "${user}@${host}"
