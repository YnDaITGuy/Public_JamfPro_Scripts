#!/bin/sh

open /System/Library/CoreServices/Menu\ Extras/VPN.menu

sleep 5

defaults write com.apple.networkConnect VPNShowTime 1; 

killall SystemUIServer
