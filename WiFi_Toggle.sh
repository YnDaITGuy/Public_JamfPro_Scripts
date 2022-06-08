#!/bin/sh

## Change each YES/NO whatever you want
#RequireAdminIBSS
#RequireAdminNetworkChange
#RequireAdminPowerToggle

## Allow changing network, admin, & On/Off
#/usr/libexec/airportd prefs RequireAdminIBSS=NO RequireAdminNetworkChange=NO RequireAdminPowerToggle=NO

## Disallow changing network, admin, & On/Off
#/usr/libexec/airportd prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES
