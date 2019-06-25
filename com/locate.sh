#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# For finding where the files are.

# So here's the problem.
# I need a really good autoshim.
# a bash 3-ish liner that gives access to the latest functions.sh stuffs.
#
# Let's unpack that.
#
# I need the system to automagically `find` the location of any installed source files, compare each individiual 'current state' against the (currently unknown) 'latest' version, and then somehow catelogue it so that next time can be a spot check and delta.
#
# Spot check: the process of pinging and validating the metadata of the index entry for a given set of randomized-ish entries, and (if necessary), queuing sections for re-indexing
#
#
# ~~~
# This is the original bit of functions.sh that I found beautiful, and helped me decide to actually write something with this.
#
########### Include functions ###########
# if [[ `find functions.sh 2>&1` == *"No such file"* ]];then echo "functions.sh not found, exiting";exit 1;fi
# clear; source "`dirname "$0"`/functions.sh"; when.sh;echo
# logThis "loaded:'functions.sh'"
########### End include functions #######
##
#
# ~~~
# Let's find a way to do this slightly better.
