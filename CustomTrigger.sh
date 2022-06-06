#!/bin/bash

currentUser=$(ls -l /dev/console | awk '{print $3}')
OSASCRIPT="/usr/bin/osascript"
JAMF="/usr/local/bin/jamf"
time=$(date +"%r")

##########  ##########

## This is notification, doesn't show anymore since Big Sur
#"$OSASCRIPT" -e 'display notification  "Downloading Something"'

## This is a message/dialog window, auto close after certain seconds 
#"$OSASCRIPT" -e 'display dialog  "Downloading Something" buttons {"OK"} default button 1 giving up after 4'

## All policies set to "Ongoing"
## This policy/script is set to "Enrollment Complete" and "Once For Computer"
## Set "Restart Options" to "Restart Immediately" force restart if some policies required 

########## Policies Start ##########

## Download Rosetta2
"$OSASCRIPT" -e 'display notification  "Downloading Rosetta2"'
"$OSASCRIPT" -e 'display dialog  "Downloading Rosetta2" buttons {"OK"} default button 1 giving up after 4'
"$JAMF" policy -event rosetta
sleep 10

## Download installomator
"$JAMF" policy -event installomator
sleep 3 

## Bootstrap Token
"$JAMF" policy -event bootstrap

## Download Google Chrome
"$JAMF" policy -event installchrome

## Download Printer Driver
"$JAMF" policy -event printerdriver

## Prompt Default Browser Message
"$JAMF" policy -event chromedefault
sleep 3

## Setting Up Dock With Web Clip
"$JAMF" policy -event dock

## Download Microsoft Word
"$JAMF" policy -event installword

## Download Microsoft PowerPoint
"$JAMF" policy -event installpowerpoint

## Add Username@Domain.org
"$JAMF" policy -event officelogin

sleep 10
"$JAMF" policy


########## Name & Version ##########
macOS=$(sw_vers -productVersion)
chromeAppname="Google Chrome: "
chromeVersion=$(mdls /Applications/Google\ Chrome.app -name kMDItemVersion | awk -F'"' '{print $2}')
wordAppname="Word: "
wordVersion=$(mdls /Applications/Microsoft\ Word.app -name kMDItemVersion | awk -F'"' '{print $2}')
pptAppname="PowerPoint: "
pptVersion=$(mdls /Applications/Microsoft\ PowerPoint.app -name kMDItemVersion | awk -F'"' '{print $2}')


########## jamfHelper ##########
## You can choose other icons but I usually use these 2

## Self Service Icon 
#/Applications/Self Service.app/Contents/Resources/AppIcon.icns
## Finder Icon
#/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
icon="/Applications/Self Service.app/Contents/Resources/AppIcon.icns"
title="Download Completed"
timeout="10"
description="Complete At: $time 
macOS $macOS
$chromeAppname $chromeVersion
$wordAppname $wordVersion
$pptAppname $pptVersion"

button1="OK"


userChoice=$("$jamfHelper" \
-windowType "$windowType" \
-lockHUD \
-title "$title" \
-icon "$icon" \
-description "$description" \
-button1 "$button1" \
-defaultButton 1 \
-timeout "$timeout" \
-iconSize 120)

# User Selects "OK"
if [ "$userChoice" == "0" ]; then
    echo $userChoice; $JAMF recon; "$JAMF" policy -event insights;
   
  
# If user selects button2
#elif [ "$userChoice" == "2" ]; then
#   echo "User selected Cancel"
fi

exit 0
