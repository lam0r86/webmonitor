#!/bin/bash
## Purpose:         Monitor Changes of Specified Webpage
## Author:          Matthias Skaletz rcfiles-webmonitor@skaletz.me
## WEB:             https://www.skaletz.me/setup/myscripts/webmonitor
## Last Modified:   Fri 2017-10-27 12:24:01
## Best Execute with Cronjob every X Minutes!

PAGE="$1"                           #Page Name
URL="$2"                            #Monitoring Page
FROM="webmon-$1@skaletz.me"         #Email From
TO="webmon@skaletz.me"              #Email TO
WEBPATH="$HOME/myscripts/.pages"    #Path of htmlfiles and script

# Check for folder, else Create
if ! [ -d "$WEBPATH" ];
    then mkdir -p "$WEBPATH";
fi

# Execute Command if $1 and $2 are set
if [[ "$1" != "" && "$2" != "" ]];
then {
        mv $WEBPATH/$1_new.html $WEBPATH/$1_old.html 2> /dev/null
        curl $URL -L --compressed -s > $WEBPATH/$1_new.html
        DOUT="$(diff -I '.*<script src=.*' $WEBPATH/$1_new.html $WEBPATH/$1_old.html)"
        if [ "0" != "${#DOUT}" ]; then
                echo "Visit changes at $URL" | \
                    mail -s "Webpage Update $PAGE" -aFrom:"Webmonitor\<$FROM\>" \
                         "$TO"
        fi
}
else
    echo "Webpage Monitoring Tool"
    echo "Useage:"
    echo "./webmonitor.sh <name> <URL>"
fi
