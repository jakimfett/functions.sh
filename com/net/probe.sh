#!/bin/bash
# @author:''
# @license;'cc-by-sa'
#
# @todo - scan the network for open ssh, attempt to auth with provided keypair(s)

# https://stackoverflow.com/questions/1371261/get-current-directory-name-without-full-path-in-a-bash-script
# https://askubuntu.com/questions/893911/when-writing-a-bash-script-how-do-i-get-the-absolute-path-of-the-location-of-th
# https://stackoverflow.com/questions/5265702/how-to-get-full-path-of-a-file
# https://stackoverflow.com/questions/38948782/how-to-properly-make-an-api-request-in-python3-with-base64-encoding
#
# https://stackoverflow.com/questions/3664225/determining-whether-shell-script-was-executed-sourcing-it

# https://unix.stackexchange.com/questions/181676/output-only-the-ip-addresses-of-the-online-machines-with-nmap
# https://askubuntu.com/questions/309668/how-to-discover-the-ip-addresses-within-a-network-with-a-bash-script
net=$(ifconfig | grep "inet " | grep -v 127 | awk '{print $2}')
nmap -n -sn ${net}/24 -oG - | awk '/Up$/{print $2}'


# https://www.techrepublic.com/article/how-to-scan-for-ip-addresses-on-your-network-with-linux/
