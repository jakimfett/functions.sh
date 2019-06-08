#!/bin/bash
# @author:'`whoami`'
# @license;'cc-by-sa'
#
# Meta script that tries to write itself, and sometimes the universe.

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
