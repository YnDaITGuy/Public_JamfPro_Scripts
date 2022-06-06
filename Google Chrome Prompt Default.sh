#!/bin/bash

osascript <<EOD
set result to button returned of (display dialog "Set default browser to Chrome")
if result = "OK" then
	do shell script ("open -a 'Google Chrome' --args --make-default-browser")
else
	display dialog "No change in the default web browser"
end if
EOD
