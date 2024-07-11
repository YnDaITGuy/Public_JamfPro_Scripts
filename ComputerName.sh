#!/bin/sh

## Get Positio, Location & Asset from API

# Bearer token for API user
jssurl="jamf url"
username="apiuser"
password="paipassword" 

# request auth token
authToken=$( /usr/bin/curl \
--request POST \
--silent \
--url "$jssurl/api/v1/auth/token" \
--user "$username:$password" )

# parse auth token
token=$( /usr/bin/plutil \
-extract token raw - <<< "$authToken" )
tokenExpiration=$( /usr/bin/plutil \
-extract expires raw - <<< "$authToken" )
localTokenExpirationEpoch=$( TZ=GMT /bin/date -j \
-f "%Y-%m-%dT%T" "$tokenExpiration" \
+"%s" 2> /dev/null )
echo "Got bearer token successfully."

serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
theXML=$( /usr/bin/curl \
--silent \
--header "Authorization: Bearer $token" \
--header "Accept: text/xml" \
--url $jssurl/JSSResource/computers/serialnumber/$serial )

position=$( /usr/bin/xpath -e "/computer/location/position/text()" 2>/dev/null <<< "$theXML" )
location=$( /usr/bin/xpath -e "/computer/location/building/text()" 2>/dev/null <<< "$theXML" )
asset=$( /usr/bin/xpath -e "/computer/general/asset_tag/text()" 2>/dev/null <<< "$theXML" )


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
modelName="/usr/bin/defaults read ~/Library/Preferences/com.apple.SystemProfiler.plist 'CPU Names' | cut -sd '"' -f 4 | uniq"
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
