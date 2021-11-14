#/bin/bash

#A Common Wordpress hack injects malicious code into .htaccess files placed in random directories
#This script delets all htaccess files which contain FileMatch keyword

echo "Starting Script"

find ./public_html -name ".htaccess" | while read line ;
        do
                grep -q "FilesMatch" $line
                if [ $? == 0 ]; then
                rm $line
                else
                echo not found
                fi
        done
