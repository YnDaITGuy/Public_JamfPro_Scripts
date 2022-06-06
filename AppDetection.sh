#!/bin/bash

OSASCRIPT="/usr/bin/osascript"
jamfprotectPath="/Applications/jamfprotect.app"

## Check Version
jamfprotectVersion=$(defaults read "$jamfprotectPath/Contents/Info.plist" CFBundleShortVersionString)

if [ $jamfprotectPath != "" ]; then
"$OSASCRIPT" -e 'display dialog  "Jamf Protect '$jamfprotectVersion' is INSTALLED." buttons {"OK"} default button 1'
else
"$OSASCRIPT" -e 'display dialog  "Jamf Protect is MISSING." buttons {"OK"} default button 1'
fi
exit 0 
