#!/bin/bash
# author: @jakimfett
#

FILENAME=`basename "$0"`

alias reload='source $FILENAME'

echo "{$FILENAME}";
exit


m5um() {
  echo "$1" | md5sum | cut -f1 -d" "
}
