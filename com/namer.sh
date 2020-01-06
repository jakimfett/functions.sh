#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'

declare -A config stateVar doneList

config['length']=3
config['numeric']=0
config['alpha']=1
config['dictPath']="/dict/names.list"
config['obfuscate']=0


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

stateVar['dictPath']="`dirname \"$0\"`${config['dictPath']}"
stateVar['dictSize']=`wc -l "${stateVar['dictPath']}" | awk '{print $1}'`
stateVar['firstNumeric']=1


# reseed the dictionary line grabber (reduces repeat chance to 1/dictSize)
function reseed {
	stateVar['seed']=$(( RANDOM % "${stateVar['dictSize']}"))
}

# Append a name to the return string
function addName {
	# randomize dict grabber
	reseed
	# do the append
	doneList['result']="${stateVar['partial']}$(sed "${stateVar['seed']}q;d" ${stateVar['dictPath']})"
}

# Append a number to the return string
function addNumeric {
	doneList['result']="${stateVar['partial']}$((RANDOM % 10))"
}

# shove the in-progress return string into a stateVar for additional processing.
function doPartial {
	# @todo - uniq, reverse, shuffle, count
	if [ ${config['obfuscate']} -eq 1 ]; then
		stateVar['partial']=$(echo "${doneList['result']}" | rev)
	else
		stateVar['partial']="${doneList['result']}"
	fi
}

# Update the length in the stateVar post-cli options input
stateVar['length']=${config['length']}

while [[ ${stateVar['length']} -gt 0 ]]; do

	# Add numeric bits if the config flag is set, never set numeral as first chunk
	if [ ${config['numeric']} -eq 1 ] && [ ${#doneList['result']} -gt 0 ]; then

		# Add a random 0-9 value to chunk 1/2 the time, avoid double digits by toggling
		if [[ ${stateVar['firstNumeric']} -eq 1 ]] && [ ${stateVar['length']} -gt 1 ]; then
			addNumeric
			stateVar['firstNumeric']=0
		else
			addName
			stateVar['firstNumeric']=1
		fi

	else
		addName
	fi

	# Remove one from the length stateVar
	stateVar['length']=$(( ${stateVar['length']} - 1 ))

	# stash the existing result string in a the stateVar if more iterations are to be run
	if [ ${stateVar['length']} -gt 0 ];then
		doPartial
	fi
done

echo ${doneList['result']}
