#!/bin/sh
#set -x   # uncomment for a trace

cd build/Release

if test "`ls FanControlDaemon 2>&1 | sed -e '/^FanControlDaemon$/d'`"  -o \
        "`ls -d 'Fan Control.prefPane' 2>&1 | sed -e '/^Fan Control\.prefPane$/d'`" -o \
        "`ls -d 'Fan Control.prefPane' 2>&1 | sed -e '/^Fan Control\.prefPane$/d'`"
then
   echo 'copyToInstaller.sh must be run from the Release directory containing the'
   echo '"FanControlDaemon", "Fan Control.prefPane" and "StartupParameters.plist" files'
   exit 1
fi

echo
/bin/echo -n 'Copying to Installer directories ... '

/bin/cp FanControlDaemon '../../installer/Library/StartupItems/FanControlDaemon/'
/bin/rm -rf 'installer/Library/PreferencePanes/Fan Control.prefPane'
/bin/cp -R 'Fan Control.prefPane' '../../installer/Library/PreferencePanes/'

cd ../../

/usr/sbin/chown -R root:wheel 'installer/Library/StartupItems/FanControlDaemon/'
/bin/chmod 755 'installer/Library/StartupItems/FanControlDaemon/FanControlDaemon'
/bin/chmod 644 'Installer/Library/StartupItems/FanControlDaemon/StartupParameters.plist'

/usr/sbin/chown -R root:wheel 'installer/Library/PreferencePanes/Fan Control.prefPane'

echo 'completed'
