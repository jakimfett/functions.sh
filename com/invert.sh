#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# Take a text file and reverse the order of (lines|entries)


# prototype: dump whole file into a variable, then manually reverse it.
# this is bad, don't do this.
# objective: per-chunk (eg, single line, or delimited section of the file) re-writing of the file, with transactional logging
echo "failmuffins"
exit 1

TEXTFILE=`cat <filepath/filename>`
DELIMITER='{=,5+}'