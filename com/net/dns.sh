#!/bin/bash
# @author:'@jakimfett'
# @license;'cc-by-sa'
#
# checks a system's position, and then reports it, via DNS.

# get address

ipv4="`curl -q -4 icanhazip.com 2>/dev/null`"
ipv6="`curl -q -6 icanhazip.com 2>/dev/null`"

echo
echo "your ipv4 is:"
echo ${ipv4}
echo
echo "your ipv6 is:"
echo ${ipv6}
echo
exit 0
