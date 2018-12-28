#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# Compares currently installed system packages against a template, with tools to save/restore/revert.

# terms:
# state = packages, services, and structure of a stable system, persists across reboots
# default = the "vanilla" or unmodified OS state, as distributed by $publisher
# template = a local file that defines a desired state
# remote = the functions.sh remote repo
# scriptname = the filename of the script being executed

# conditionals (can be nested)
# [,] = defines a mandatory conditional set
# <,> = defines an optional conditional set
# | = an "or" conditional
# & = an "and" conditional

# usage:
#
# read-only
# $scriptname list <-- lists non-standard packages for distribution
#
# read+download-only
# $scriptname get <template> <-- downloads script from http://functions.sh/t/<template>
# $scriptname compare <template> <-- lists packages, compares against <template>
# 
# read+download+modify
# $scriptname set <template> <-- writes current state to disk
# $scriptname restore [default|<template>] <-- uninstalls, installs, and does the needful to move the system to a given state, without reverting to default
# $scriptname revert [default|<template>] <-- reverts system packages to default, OR to local template
# $scriptname sync <template> <-- reverts, then restores