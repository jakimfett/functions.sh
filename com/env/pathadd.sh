#!/bin/bash
# @author:'jakimfett'
# @license;'cc-by-sa'
#
# Adds the working directory to your $PATH variable

# @todo compare variables with diff bash
echo "Old \$PATH contents:"; echo "${PATH}"; export oldPath=${PATH}; export PATH="${oldPath}:`pwd`"; echo "New path:"; echo "${PATH}"; echo; echo "Diff:"; diff `echo ${oldPath}` `echo $PATH`; echo; unset oldPath;
