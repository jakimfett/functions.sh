#!/bin/bash
# returns a precise but human readable date format
# author:jakimfett

# @todo - split the formatting command into multiple single line additions to a variable, with reasoning and explanation for each piece
# @todo - add a variable for an optional line pre- and -post addition, eg '`#`' or '`;`'
echo
date +"%Y_%m_%d%t%t%t%H.%M.%S (%Z/GMT%z)%n%A, %d %B%t%tDay %j"
