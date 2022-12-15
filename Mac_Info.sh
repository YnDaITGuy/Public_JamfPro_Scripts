#/bin/sh

########## macOS Version ##########
macosVersion=$(sw_vers -productVersion)
echo $macosVersion

########## Model Id & Serial Number ##########
# List Data Type 
system_profiler -listDataTypes

modelName=$(system_profiler SPHardwareDataType | awk '/Name/ {print $3}')
echo "Model Name: $modelName"

serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
echo $serialNumber

########## Network Interface & SSID List##########

Interface=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $NF}')
ssidList=$( networksetup -listpreferredwirelessnetworks ${Interface} | sed 's/^[    ]*//g;1d' )
echo $Interface
echo $ssidList

########## Last Reboot ##########

lastreboot=$(who -b | sed -E 's/^[^,]*boot *'//)
echo $lastreboot

########## Uptime ##########

UP=$(uptime | sed -E 's/^[^,]*up *//; s/mins/minutes/; s/hrs?/hours/;
s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/;
s/^1 hours/1 hour/; s/ 1 hours/ 1 hour/;
s/min,/minutes,/; s/ 0 minutes,/ less than a minute,/; s/ 1 minutes/ 1 minute/;
s/  / /; s/, *[[:digit:]]* users?.*//')

echo $UP

########## Free Disk Space ##########

## Display Free Space - Big Sur
FreeSpace=$( /usr/sbin/diskutil info / | /usr/bin/grep  -E 'Free Space|Available Space|Container Free Space' | /usr/bin/awk -F ":\s*" '{ print $2 }' | awk -F "(" '{ print $1 }' | xargs )
FreeBytes=$( /usr/sbin/diskutil info / | /usr/bin/grep -E 'Free Space|Available Space|Container Free Space' | /usr/bin/awk -F "(\\\(| Bytes\\\))" '{ print $2 }' )
DiskBytes=$( /usr/sbin/diskutil info / | /usr/bin/grep -E 'Total Space' | /usr/bin/awk -F "(\\\(| Bytes\\\))" '{ print $2 }' )
FreePercentage=$(echo "scale=2; $FreeBytes*100/$DiskBytes" | bc)
diskSpace="Disk Space: $FreeSpace free (${FreePercentage}% available)"

echo $diskSpace

## Display Free Space - Monterey 12.6+
free_disk_space=$(osascript -l 'JavaScript' -e "ObjC.import('Foundation'); var freeSpaceBytesRef=Ref(); $.NSURL.fileURLWithPath('/').getResourceValueForKeyError(freeSpaceBytesRef, 'NSURLVolumeAvailableCapacityForImportantUsageKey', null); Math.round(ObjC.unwrap(freeSpaceBytesRef[0]) / 1000000000)")  

echo $free_disk_space
