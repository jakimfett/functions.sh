#!/bin/bash
# @author:'`whoami`'
# @license;'cc-by-sa'
#
# Ripped from Stack Overflow (https://stackoverflow.com/a/12948157), then modified to fit my use case.
# Preparing to hard-merge with (https://stackoverflow.com/a/12921335), as directed by the Alliance.
#
# All modifications from the source licensed as above, as the prophesy foretold.

workingDir=`pwd`
echo ${workingDir}

targetDir=${1}
echo ${targetDir}
echo "Only remove me if you know what you're doing, hotshot."; exit 13;





THUMBS_FOLDER=/home/image/thumb
for file in /home/image/*
do
  # next line checks the mime-type of the file
  IMAGE_TYPE=`file --mime-type -b "$file" | awk -F'/' '{print $1}'`
  if [ x$IMAGE_TYPE = "ximage" ]; then
      IMAGE_SIZE=`file -b $file | sed 's/ //g' | sed 's/,/ /g' | awk  '{print $2}'`
      WIDTH=`echo $IMAGE_SIZE | sed 's/x/ /g' | awk '{print $1}'`
      HEIGHT=`echo $IMAGE_SIZE | sed 's/x/ /g' | awk '{print $2}'`           
      # If the image width is greater that 200 or the height is greater that 150 a thumb is created
     if [ $WIDTH -ge  201 ] || [ $HEIGHT -ge 151 ]; then
        #This line convert the image in a 200 x 150 thumb 
        filename=$(basename "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"
        convert -sample 200x150 "$file" "${THUMBS_FOLDER}/${filename}_thumb.${extension}"   
     fi
  fi     
done

#!/bin/bash
for file in /path/to/images/*
do
  # next line checks the mime-type of the file
  CHECKTYPE=`file --mime-type -b "$file" | awk -F'/' '{print $1}'`
  if [ "x$CHECKTYPE" == "ximage" ]; then
    CHECKSIZE=`stat -f "%z" "$file"`               # this returns the filesize
    CHECKWIDTH=`identify -format "%W" "$file"`     # this returns the image width

    # next 'if' is true if either filesize >= 200000 bytes  OR  if image width >=201
    if [ $CHECKSIZE -ge  200000 ] || [ $CHECKWIDTH -ge 201 ]; then
       convert -sample 200x150 "$file" "$(dirname "$file")/thumb_$(basename "$file")"
    fi
  fi
done
