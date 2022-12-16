#!/bin/bash

loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`
#currentUser=$(ls -l /dev/console | awk '{print $3}')

## Show HDD
/usr/bin/defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true;

## Show Ext. HDD
/usr/bin/defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true;

## Show Mounted Server
/usr/bin/defaults write com.apple.finder ShowMountedServersOnDesktop -bool true;

## Show Removable Media
/usr/bin/defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true;

#Shows Status Bar
/usr/bin/defaults write com.apple.finder ShowStatusBar -bool true;

#Shows Tab View
/usr/bin/defaults write com.apple.finder ShowTabView -bool true;

#Shows Path Bar
/usr/bin/defaults write com.apple.finder ShowPathbar -bool true;

## Show Desktop HDD Space
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" /Users/$loggedInUser/Library/Preferences/com.apple.finder.plist

killall cfprefsd
killall Finder

exit
