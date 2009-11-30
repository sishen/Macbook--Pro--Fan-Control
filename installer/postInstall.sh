#!/bin/sh

/usr/bin/killall FanControlDaemon 2>&1 >/dev/null
sleep 2
/sbin/SystemStarter start FanControlDaemon
