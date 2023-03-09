#!/bin/bash

## To Just Open Self Service
#sudo -u $(ls -l /dev/console | awk '{print $3}') /usr/bin/osascript -e 'tell application "Self Service" to activate'

## Current Logged In User
currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')
## User ID
uid=$(id -u "$currentUser")

windowType="hud"	# utility, hud, or fs
icon="/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns"
title="Title Here"
policyID="264"		      # "$4"
policyAction="view" 	  # "$5" view or execute
message="Message Here"	# "$6"
timeout="10"		        # Add time below if needed -timeout "$timeout" \
policy="jamfselfservice://content?entity=policy&id=$policyID&action=$policyAction"

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

userChoice=$("$jamfHelper" \
	-windowType "$windowType" \
	-lockHUD \
	-icon "$icon" \
	-title "$title" \
	-description "$message" \
	-button1 "OK" \
	-button2 "CANCEL" \
	-defaultButton 2)

#echo "$userChoice"

## 0 is button1, 2 is button2

if [[ "$userChoice" == "0" ]];then
	#/bin/launchctl asuser $uid sudo -iu $currentUser /usr/bin/open $policy
	launchctl asuser $uid sudo -iu $currentUser open $policy
else 
exit 0
fi
