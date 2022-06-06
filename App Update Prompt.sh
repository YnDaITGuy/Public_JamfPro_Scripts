#!/bin/sh

## Parameters for new software version
appPath="$4"		    # /Applications/Microsoft\ Excel.app
appName="$5" 		    # Microsoft Excel
newVersion="$6" 	  # 16.55.21111400
policyTrigger="$7"	# installExcel

OSASCRIPT="/usr/bin/osascript"

## Check installed version
version=$(defaults read $appPath/Contents/Info CFBundleShortVersionString)
if [[ $version != $newVersion ]]

## If you want to display dialog
#then $OSASCRIPT -e 'display dialog "'"$appName"' is outdated. Please quit '"$appName"', then click OK to update." buttons {"OK"} default button 1'; killall $appName; jamf policy -event $policyTrigger

then 
killall $appName; jamf policy -event $policyTrigger

fi

exit 0
