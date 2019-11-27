#!/bin/bash
# @author: jakimfett
# @license: cc-by-sa
#
# Autoconfig and backup/export for MikroTik network hardware.

declare -A config stateVar doneList

# Network Config
config['net']='/24'
config['wan']='198.15.4.183'
config['lan']='172.16.0.1'
config['gateway']='198.15.4.1'
config['dns']='198.15.0.2,1.0.0.1,8.8.8.8'

# Identity Config
config['user']='sysadmin'
config['pass']='4khF4wc6qcgUeqga6O3aSqH1uSBVf'

stateVar['routerID']=''

function initialSetup {
	# Create user for scripting
	# Set up user pubkey access
	# Save to config file for later use?
	# @todo decide where to store passphrases & ssh keys for fsh
}

funtions getIdentity {
	ssh
}

function exportConfig {
	echo "Starting export process."
	local exportFile=""
}


# @todo move input processing to core.sh
for i in "$@"; do
	case "$i" in
		-[0-9]*)
			config['length']=${i:1}
		 ;;
		'-n'|'--numeric' )
			config['numeric']=1
		;;
		# -o|--obfuscate )
		# config['obfuscate']=1
		# ;;
		*)
		 ;;
	esac
done
