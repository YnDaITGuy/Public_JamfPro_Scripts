#!/bin/sh

currentUser=$(ls -l /dev/console | awk '{print $3}')

## true = lock, false = unlock
sudo -u "$currentUser" defaults write com.apple.Dock contents-immutable -bool true

killall Dock
