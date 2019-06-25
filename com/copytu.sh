#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# @function.desc
# copies the current functions.sh environment to a different location, preserving git history and current modifications.
#
# @function.syntax
# 	`copyto.sh "directory"` <-- copy to a locally writeable directory
# 	`copyto.sh "user@server.tld"` <-- copy to an SSH-able remote
# 	`copyto.sh --device "device_id"` <-- mount and write to an unmounted device
#
#	`function "location" --delta` <-- default option, using rsync, warns on overwrite
#	`function "location" --hard --yes --quiet` <-- empties the remote location if necessary before performing a full copy
#
# @function.returns
# 	* = standard
#
# @function.comment
#	Intended to facilitate nomadic programming styles.
function templateFunction {
	exit 0
}
