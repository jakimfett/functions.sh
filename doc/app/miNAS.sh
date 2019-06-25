#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# Automagic online script for the SeaFile microNAS

# adding the prerequisites from the [seafile docs](https://archive.fo/bQPHi)
depList['apt']="autoconf automake libtool libevent-dev libcurl4-openssl-dev libgtk2.0-dev uuid-dev intltool libsqlite3-dev valac libjansson-dev cmake qtchooser qtbase5-dev libqt5webkit5-dev qttools5-dev qttools5-dev-tools libssl-dev python-setuptools"

depList['git']="https://github.com/haiwen/libsearpc.git "



declare depListDev=('man-db' 'etckeeper' 'fdisk')
declare -A autoCompile=('capn-proto')
