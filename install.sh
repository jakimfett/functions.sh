#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# A jumble of things meant to configure, set up, and otherwise assemble the functions.sh framework.


# https://help.github.com/articles/signing-commits-using-gpg/
git config commit.gpgsign true


mkdir -p microsite;cd microsite;git config user.email script@user.system.tld
git config user.name autogen
wget http://functions.sh -O functions.sh.online
diff functions.sh.online functions.sh
