#!/bin/bash
# returns a precise but human readable date format
# author:jakimfett

# @todo - split the formatting command into multiple single line additions to a variable, with reasoning and explanation for each piece

date +"%Y_%m_%d%t%H.%M.%S (%Z/GMT%z)%n%A, %d %B%tDay %j"
