#!/bin/bash

ComputerName=`/usr/bin/osascript <<EOT
set ComputerName to text returned of (display dialog "Rename The Mac" default answer "" with icon 1 buttons {"OK"} default button "OK")
EOT`

## Set New Computer Name - Monterey
scutil --set HostName $ComputerName
sleep 5
scutil --set LocalHostName $ComputerName
sleep 5
scutil --set ComputerName $ComputerName
sleep 5

## Set New Computer Name - Jamf
jamf setComputerName -name $ComputerName

jamf recon
