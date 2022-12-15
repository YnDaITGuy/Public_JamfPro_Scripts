#/bin/sh

macosVersion=$(sw_vers -productVersion)
echo $macosVersion

modelID=$(system_profiler SPHardwareDataType | awk '/Name/ {print $3}')
echo "Model ID: $modelID"

serialNumber=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
echo "$serialNumber"

lastreboot=$(who -b | sed -E 's/^[^,]*boot *'//)
echo "$lastreboot"

UP=$(uptime | sed -E 's/^[^,]*up *//; s/mins/minutes/; s/hrs?/hours/;
s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/;
s/^1 hours/1 hour/; s/ 1 hours/ 1 hour/;
s/min,/minutes,/; s/ 0 minutes,/ less than a minute,/; s/ 1 minutes/ 1 minute/;
s/  / /; s/, *[[:digit:]]* users?.*//')

echo "$UP"

free_disk_space=$(osascript -l 'JavaScript' -e "ObjC.import('Foundation'); var freeSpaceBytesRef=Ref(); $.NSURL.fileURLWithPath('/').getResourceValueForKeyError(freeSpaceBytesRef, 'NSURLVolumeAvailableCapacityForImportantUsageKey', null); Math.round(ObjC.unwrap(freeSpaceBytesRef[0]) / 1000000000)")  

echo "$free_disk_space"
