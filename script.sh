#!/bin/sh

linesCount="0"
loc="/media/hdd/home/Movies"
selfLoc="/home/chadidi/files/downloader/"

moveTo() {
    head -n $3 $1 >> $2 # Move to a new file
    sed -i -e "1,$3 d" $1 # remove from the old file
}

count() {
    linesCount=$(wc -l $1 | awk '{ print $1 }')
    echo $linesCount
}

download() {
    url=$(head -1 $selfLoc"inQueue.txt" | tr -d '\r')
    echo "downloading: ${url##*/}"
    wget -c $url --directory-prefix=$loc
    if [ $? -ne 0 ]
    then
        moveTo $selfLoc"inQueue.txt" $selfLoc"failed.txt" 1
    else
        mv $selfLoc"${url##*/}" loc
        moveTo $selfLoc"inQueue.txt" $selfLoc"downloaded.txt" 1
    fi
}

count $selfLoc"inQueue.txt"

if [ $linesCount != 0 ]
then
    download
else
    count $selfLoc"toDownload.txt"

    if [ $linesCount != 0 ]
    then
        moveTo $selfLoc"toDownload.txt" $selfLoc"inQueue.txt" 1
        download
    fi
fi

exit