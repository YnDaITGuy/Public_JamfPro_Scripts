#!/bin/bash

loggedInUser=$( ls -l /dev/console | awk '{print $3}' )

## Big Sur and above

## Display Bluetooth on Menu Bar
sudo -u ${loggedInUser} defaults write /Users/${loggedInUser}/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18

## Display Sound on Menu Bar
sudo -u ${loggedInUser} defaults write /Users/${loggedInUser}/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18

## Display Battery Precentage on Menu Bar
sudo -u ${loggedInUser} defaults write /Users/${loggedInUser}/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true

exit 0
