#!/bin/bash

currentUser=$(ls -l /dev/console | awk '{print $3}')
OSASCRIPT="/usr/bin/osascript"
JAMF="/usr/local/bin/jamf"
time=$(date +"%r")

##########  ##########

## You can put the notificatio/message on screen to show user what's going on

## This is notification banner if you want to use it for each policy
#"$OSASCRIPT" -e 'display notification  "Downloading Something"'

## This is a message/dialog window, auto close after certain seconds 
#"$OSASCRIPT" -e 'display dialog  "Downloading Something" buttons {"OK"} default button 1 giving up after 4'

## all policies are set to "Ongoing" and use "Custom Event" to run.
## this script is set to "Enrollment Complete" and "Once For Computer".
## set "Restart Options" to "Restart Immediately" force restart if some policies require it.
## sleep is to wait before running the next custom trigger.
## you can add & (ampersand) after the policy to run both simultaneously.
## take out $timeout if you don't want it to auto close the jamfHelper window. 

## You can use this one line to install Rosetta if you like
# [ $( /usr/bin/arch ) = "arm64" ] && /usr/sbin/softwareupdate --install-rosetta --agree-to-license

## Check if Setup Assistance is Running. Run Policies after Setup Assistance is completed.

SetupAssistance_process=$(/bin/ps auxww | grep -q "[S]etup Assistant.app")
while [ $? -eq 0 ]
do
    /bin/echo "Setup Assistant Still Running... Sleep for 2 seconds..."
    /bin/sleep 2
    SetupAssistance_process=$(/bin/ps auxww | grep -q "[S]etup Assistant.app")
done

########## Policies Start ##########

## Download Rosetta. I'm using the notification and dialog to show what it looks like.
"$OSASCRIPT" -e 'display notification  "Downloading Rosetta2"'
"$OSASCRIPT" -e 'display dialog  "Downloading Rosetta2" buttons {"OK"} default button 1 giving up after 4'
"$JAMF" policy -event rosetta

## Download installomator
"$JAMF" policy -event installomator

## Enable Location Service if you have "Automatically advance through Setup Assistant" Enabled in Pre-Stage
"$JAMF" policy -event locationservice

## Jamf Protect Detect and Install If Missing (Just In Case) 
"$JAMF" policy -event jamfprotect

## Bootstrap Token (Just In Case) 
"$JAMF" policy -event bootstrap

## Download Google Chrome
"$JAMF" policy -event installchrome

## Download Printer Driver
"$JAMF" policy -event printerdriver

## Prompt Select Default Browser Message
## You'll need this script set up.
"$JAMF" policy -event chromedefault
sleep 3

## Download Microsoft Word
"$JAMF" policy -event installword &

## Download Microsoft Excel
"$JAMF" policy -event installexcel &

## Download Microsoft PowerPoint
"$JAMF" policy -event installpowerpoint

## Add Username@Domain.org to Microsoft 365 (Office)
"$JAMF" policy -event officelogin

## Setting Up Dock With Web Clip
"$JAMF" policy -event dock

sleep 7
## Double check all policies in case they are stuck or didn't run
"$JAMF" policy

## You can run recon and 
$JAMF recon

## Sync Jamf Protect insights if you have it
protectctl checkin --insights

## You can have it say a word or play a sound when it's completed
say "Finished!"


########## App Name & Version ##########
## You can add more. This displays version of macOS, Chrome, Word, & PowerPoint. 
## Remember to put those in $description

macOS=$(sw_vers -productVersion)
chromeAppname="Google Chrome: "
chromeVersion=$(mdls /Applications/Google\ Chrome.app -name kMDItemVersion | awk -F'"' '{print $2}')
wordAppname="Word: "
wordVersion=$(mdls /Applications/Microsoft\ Word.app -name kMDItemVersion | awk -F'"' '{print $2}')
pptAppname="PowerPoint: "
pptVersion=$(mdls /Applications/Microsoft\ PowerPoint.app -name kMDItemVersion | awk -F'"' '{print $2}')


########## jamfHelper ##########
## You can choose other icons
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
-countdown \ 
-iconSize 120)

## Display Installed App and Version jamfHelper message, recon, and sync Jamf Protect insights (if you have it)
## It auto close and click OK after 10 seconds base on the $timeout
## You can restart the Mac after timeout
if [ "$userChoice" == "0" ]; then
    echo $userChoice
   
  
# If user selects button2. Use this if you want to run other policies
#elif [ "$userChoice" == "2" ]; then
#   echo "User selected Cancel"
fi

exit 0
