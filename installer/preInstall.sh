#!/bin/sh

/usr/bin/killall 'FanControlDaemon' 2>&1 >/dev/null
/usr/bin/killall 'System Preferences' 2>&1 >/dev/null
sleep 2

/bin/rm -rf '/Library/PreferencePanes/Fan Control.prefPane'
/bin/rm -rf '/Library/StartupItems/FanControlDaemon/FanControlDaemon' \
            '/Library/StartupItems/StartupParameters.plist'
