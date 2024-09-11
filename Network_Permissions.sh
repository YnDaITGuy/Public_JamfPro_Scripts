#!/bin/sh

# Monterey >=
## Change each YES/NO whatever you want
#RequireAdminIBSS
#RequireAdminNetworkChange
#RequireAdminPowerToggle

## Allow/Disallow 
#/usr/libexec/airportd prefs RequireAdminIBSS=YES RequireAdminNetworkChange=YES RequireAdminPowerToggle=YES

# Ventura =<
/usr/bin/security authorizationdb write system.preferences.network allow 
/usr/bin/security authorizationdb write system.services.systemconfiguration.network allow
/usr/bin/security authorizationdb write com.apple-wifi allow
