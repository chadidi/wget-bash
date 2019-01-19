#!/bin/sh

linesCount="0"
loc="/media/hdd/home/Movies"
selfLoc="/home/chadidi/files/downloader/"

moveTo() {
    head -n $3 $selfLoc$1 >> $selfLoc$2 # Move to a new file
    sed -i -e "1,$3 d" $selfLoc$1 # remove from the old file
}

count() {
    linesCount=$(wc -l < $selfLoc$1)
    echo $linesCount
}

download() {
    url=$(head -1 $selfLoc"inQueue.txt" | tr -d '\r')
    echo "downloading: ${url##*/}"
    wget -c $url --directory-prefix=$loc
    if [ $? -ne 0 ]
    then
        moveTo "inQueue.txt" "failed.txt" 1
    else
        # mv "${url##*/}" $loc
        moveTo "inQueue.txt" "downloaded.txt" 1
    fi
}

count "inQueue.txt"

if [ $linesCount != 0 ]
then
    download
else
    count "toDownload.txt"

    if [ $linesCount != 0 ]
    then
        moveTo "toDownload.txt" "inQueue.txt" 1
        download
    fi
fi

exit