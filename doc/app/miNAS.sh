#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# Automagic online script for the SeaFile microNAS

# adding the prerequisites from the [seafile docs](https://archive.fo/bQPHi)

declare -A depList

depList['apt']="autoconf automake libtool libevent-dev libcurl4-openssl-dev libgtk2.0-dev uuid-dev intltool libsqlite3-dev valac libjansson-dev cmake qtchooser qtbase5-dev libqt5webkit5-dev qttools5-dev qttools5-dev-tools libssl-dev python-setuptools man-db etckeeper fdisk"

depList['git']="https://github.com/haiwen/libsearpc.git"

depList['autoCompile']='capn-proto'