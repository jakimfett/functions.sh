#!/usr/local/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# Brings a bare server online with vultr.

declare -A config stateVar

# @todo - set this via config file or cli param
config['domain']='rheos.one'

# The vultr api key location, dumped into a variable for later use
config['key']="$(cat ~/.ssh/vultr.api.key)"


# Add the f.sh binaries folder by default
export PATH="$(realpath ~/f.sh/bin):$(realpath ./):${PATH}:`pwd`";

# vultr necessary bits
export VULTR_API_KEY="${config['key']}"
export VULTR_BINARY=$(which vultr-cli)


if [ -z "${VULTR_BINARY}" ];then
	echo "Binary not found, please install from:"
	echo -e "\thttps://github.com/vultr/vultr-cli"
else
	${VULTR_BINARY} version
fi

#${VULTR_BINARY} dns record create
#cat ${config['site']}/conf/dns.txt

function addIP {
	fileSize=$(($(wc -l ${config['site']}/conf/dns.txt | awk '{print $1}')+1))
	for (( i = 0; i < ${fileSize} ; i++ )); do
		line=$(sed "${i}q;d" "${config['site']}/conf/dns.txt")
		ip=$(echo $line | awk '{print $2}')
		url=$(echo $line | awk '{print $1}')

		echo
		${VULTR_BINARY} dns record create --domain "${url}" --type A --data "${ip}" --name "${url}" --ttl '30'
		${VULTR_BINARY} dns record create --domain "${url}" --type A --data "${ip}" --name "www" --ttl '30'

	done
}
addIP

#cat ${config['site']}/conf/dns.txt | awk '{print $2}'

#### This is the spec. Sorta. Modify it with caution and understanding. ####

# @function.desc
# A description of the function, briefly.
#
# @function.syntax
# 	`function "parameter"` <-- short(est?) version of the function command
#	`function "param" <optional>` <-- optional params use brackets.
#	`function "param" <ordered> <sequence> <2> <3>` <-- starts @zero
#
# @function.returns
#	0-2, 126-128, 130, 255+ = [linux standard](http://www.tldp.org/LDP/abs/html/exitcodes.html)
# 	n = custom return code
#
# @function.comment
#	Meta information on the function.
# 	This function is for the template, and exists primarily for informational purposes.
function templateFunction {
	exit 0
}
