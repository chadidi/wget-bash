# File downloader

You can start downloading files by creating a cron job like this:
`0,10,20,30,40,50 * * * * bash $PATH/script.sh > /tmp/downloader.output $SAVING_AT`
I am running the script every 6 times in 1 hour you can create you custom cron job time by the help of this [website](https://crontab.guru/).
