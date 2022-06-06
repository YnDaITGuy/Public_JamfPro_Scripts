!#/bin/sh

## Show the Set Chrome As Default Browser button in Chrome if it's not default browser

currentUser=$(ls -l /dev/console | awk '{print $3}')

/usr/libexec/PlistBuddy -c "Add :DefaultBrowserSettingEnabled bool true" /Users/$currentUser/Library/Preferences/com.google.Chrome.plist

exit
