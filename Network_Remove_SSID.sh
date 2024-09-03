#!/bin/sh

## Get en0 & en1
for interface in $(networksetup -listnetworkserviceorder | grep Hardware | awk '/Wi-Fi/ { print $NF }' | awk -F ")" '{ print $1 }')
do
   # echo "Disconnecting $interface from non-internal device network"
    networksetup -removepreferredwirelessnetwork $interface UnknownWiFi1
    networksetup -removepreferredwirelessnetwork $interface UnknownWiFi2
    networksetup -removepreferredwirelessnetwork $interface UnknownWiFi3
    networksetup -removepreferredwirelessnetwork $interface UnknownWiFi4
done

## Allow standard user to Network & WiFi System Settings pane
## authorizationdb write right-name [allow|deny|rulename]
echo allowing everyone to write to network and wifi services
/usr/bin/security authorizationdb write system.preferences.network allow
/usr/bin/security authorizationdb write system.services.systemconfiguration.network allow
/usr/bin/security authorizationdb write com.apple.wifi allow
