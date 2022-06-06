#!/bin/bash 

currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{print $3}')
domain=$"@BlahBlahBlahBlah.org"

sudo -u $currentUser defaults write com.microsoft.office OfficeActivationEmailAddress -string "$currentUser$domain"
sleep 2

## Remove the # below if you want to open an Office app
#sudo -u $currentUser open "/Applications/Microsoft Outlook.app"

exit 0
