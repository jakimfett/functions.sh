#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'


declare -A config stateVar doneList


config['dictPath']='dict/names.list'
config['dictSize']=`wc -l "${config['dictPath']}" | awk '{print $1}'`

if [ $1 ];then
  config['length']=$1
else
  config['length']=1
fi

function reseed {
  stateVar['seed']=$((1 + RANDOM % "${config['dictSize']}"))
}

function addName {
  stateVar['partial']="${doneList['result']}"
  reseed
  doneList['result']="${stateVar['partial']}`sed "${stateVar['seed']}q;d" ${config['dictPath']}`"
}

while [[ ${config['length']} -gt 0 ]]; do
  addName
  config['length']=$(( ${config['length']} - 1 ))
done

echo ${doneList['result']}
