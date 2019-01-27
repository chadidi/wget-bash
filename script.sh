#!/bin/sh

linesCount="0"
loc="$1"
selfLoc="/home/chadidi/files/downloader/"

moveTo() {
    head -n $3 $selfLoc$1 >> $selfLoc$2 # Move to a new file
    sed -i -e "1,$3 d" $selfLoc$1 # remove from the old file
}

count() {
    linesCount=$(wc -l < $selfLoc$1)
}

download() {
    url=$(head -1 $selfLoc"inQueue.txt" | tr -d '\r')
    echo "downloading: ${url##*/}"
    wget -c $url --directory-prefix=$loc
    if [ $? -ne 0 ]
    then
        moveTo "inQueue.txt" "failed.txt" 1
    else
        mv "${url##*/}" $loc
        moveTo "inQueue.txt" "downloaded.txt" 1
    fi
}

# check if script is already running
dupe_script=$(ps -ef | grep $selfLoc"script.sh" | grep -v grep | wc -l)
if [ $dupe_script -gt 3 ]
then
    echo -e "The script was already running."
    exit 0
fi

count "inQueue.txt"

if [ $linesCount -gt 0 ]
then
    download
else
    count "toDownload.txt"

    if [ $linesCount -gt 0 ]
    then
        moveTo "toDownload.txt" "inQueue.txt" 1
        download
    fi
fi

exit