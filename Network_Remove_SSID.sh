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
