#!/bin/bash

# Display Uptime
runCommand=$( /usr/bin/uptime | /usr/bin/awk -F "(up |, [0-9] users)" '{ print $2 }' )
if [[ "$runCommand" = *day* ]] || [[ "$runCommand" = *sec* ]] || [[ "$runCommand" = *min* ]] ; then
	upTime="Uptime: $runCommand"
else
	upTime="Uptime: $runCommand hrs/min"
fi


# Display diskSpace
FreeSpace=$( /usr/sbin/diskutil info / | /usr/bin/grep  -E 'Free Space|Available Space|Container Free Space' | /usr/bin/awk -F ":\s*" '{ print $2 }' | awk -F "(" '{ print $1 }' | xargs )
FreeBytes=$( /usr/sbin/diskutil info / | /usr/bin/grep -E 'Free Space|Available Space|Container Free Space' | /usr/bin/awk -F "(\\\(| Bytes\\\))" '{ print $2 }' )
DiskBytes=$( /usr/sbin/diskutil info / | /usr/bin/grep -E 'Total Space' | /usr/bin/awk -F "(\\\(| Bytes\\\))" '{ print $2 }' )
FreePercentage=$(echo "scale=2; $FreeBytes*100/$DiskBytes" | bc)
diskSpace="Disk Space: $FreeSpace free (${FreePercentage}% available)"


displayInfo="----------------------------------------------
MONTHLY CHECKUP 
$upTime
*Your Message Here
----------------------------------------------
HARDDRIVE
$diskSpace
*Your Message Here
----------------------------------------------"

runCommand="button returned of (display dialog \"$displayInfo\" with title \"Computer Information\" with icon file posix file \"/System/Library/CoreServices/Finder.app/Contents/Resources/Finder.icns\" buttons {\"OK\"} default button {\"OK\"})"

clickedButton=$( /usr/bin/osascript -e "$runCommand" )

exit 0
