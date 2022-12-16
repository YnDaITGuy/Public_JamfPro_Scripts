# discover device name of Wi-Fi network
WF=`networksetup -listnetworkserviceorder | grep "Wi-Fi," | sed "s#^([^:]*:[^:]*:\ \([a-z0-9]*\))#\1#"`

if [ "$DEBUG" == "True" ] ; then
    echo "Got WF: $WF"
fi

# promote Wi-Fi to top of service order
# build list of services
service_list=()
while read service; do
    service_list+=("$service")
done < <(networksetup -listnetworkserviceorder | grep "Hardware Port" | \
    grep -v "Wi-Fi" | sed 's#([^:]*:\ \([^,]*\),.*#\1#')
# do the promote
if [ "$DEBUG" == "True" ] ; then
    echo "Set order to: ${service_list[@]}"
fi
networksetup -ordernetworkservices Wi-Fi "${service_list[@]}"
if [ "$DEBUG" == "True" ] ; then
    echo "Order set"
fi

# promote MobileAnywhere to top of preferred WiFi networks
# note index starts at 0
networksetup -removepreferredwirelessnetwork $WF MobileAnywhere > /dev/null
networksetup -addpreferredwirelessnetworkatindex $WF MobileAnywhere 0 WPA2 > /dev/null
if [ "$DEBUG" == "True" ] ; then
    echo "MA promoted"
fi
