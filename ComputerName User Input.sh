#!/bin/bash

ComputerName=`/usr/bin/osascript <<EOT
set ComputerName to text returned of (display dialog "Rename The Mac" default answer "" with icon 1 buttons {"OK"} default button "OK")
EOT`

echo $ComputerName

## Set New Computer Name
scutil --set HostName $ComputerName
sleep 5
scutil --set LocalHostName $ComputerName
sleep 5
scutil --set ComputerName $ComputerName
sleep 5

jamf recon

#echo $ComputerName
