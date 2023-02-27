#!/bin/bash

## Current Logged In User, use either one
currentUser=$(ls -l /dev/console | awk '{print $3}')
loggedInUser=$(stat -f%Su /dev/console)

## Prompt User Input
ComputerName=`/usr/bin/osascript <<EOT
set ComputerName to text returned of (display dialog "Rename The Mac" default answer "" with icon 1 buttons {"OK"} default button "OK")
EOT`

## Get First & Last Name
firstName=$(finger -s $getUser | head -2 | tail -n 1 | awk '{print tolower($2)}')
lastName=$(finger -s $getUser | head -2 | tail -n 1 | awk '{print tolower($3)}')

## Model Identifier, also can use print $NF
modelID="/usr/sbin/sysctl hw.model | awk '{print $2}'"
-> Macmini9,1

## Model Name
modelNAme="/usr/bin/defaults read ~/Library/Preferences/com.apple.SystemProfiler.plist 'CPU Names' | cut -sd '"' -f 4 | uniq"
-> Mac mini (M1, 2020)

## Chip
chip="/usr/sbin/sysctl -n machdep.cpu.brand_string"
-> Apple M1

## Model ID and Prefix
modelID=$(sysctl hw.model | awk '{print $NF}')
#echo "$modelID"

## Determine the Model Prefix based on the Model ID
case "$modelID" in
    iMac*)
    modelPrefix="iMac" ;;
    MacBook*)
    modelPrefix="MBA" ;;
    MacPro*)
    modelPrefix="MBP" ;;
    Macmini*)
    modelPrefix="Mini" ;;
    *)
    modelPrefix="Mac" ;;
esac

echo "$modelPrefix"

## UDID
/usr/local/bin/jamf setComputerName -name "Mac-$(ioreg -d2 -c IOPlatformExpertDevice | awk -F\" '/IOPlatformUUID/{print $(NF-1)}')"

## MAC Address
/usr/local/bin/jamf setComputerName -name "Mac-$(ifconfig en0 | awk '/ether/{print $2}' | tr -d :’)"


#### Pick either scutil or jamf to rename ####

## Set Computer Name
## Add sleep 3 in between for more reliable results
scutil --set HostName $ComputerName
sleep 3
scutil --set LocalHostName $ComputerName
sleep 3
scutil --set ComputerName $ComputerName
sleep 3

## Set Computer Name - Jamf
jamf setComputerName -name $ComputerName
