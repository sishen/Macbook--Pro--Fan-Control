//
// Fan Control
// Copyright 2006 Lobotomo Software 
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//

#import <Cocoa/Cocoa.h>
#import <unistd.h>
#import "MFDaemon.h"
#import "MFProtocol.h"


int main(int argc, const char *argv[])
{
    // ignore restart and stop
    if (argc == 2 && strcmp(argv[1], "start") == 0) {
        // fork off daemon
        pid_t pid = fork();
        if (pid == 0) {
            // since Leopard we need to exec immediately after fork (can't use Foundation functionality otherwise)
            // exec ourself again here with argument "startnofork" instead of running the daemon directly here
            execl(argv[0], argv[0], "run", NULL);
        }
	} else if (argc == 2 && strcmp(argv[1], "run") == 0) {
		NSAutoreleasePool *pool = [NSAutoreleasePool new];
		MFDaemon *daemon = [MFDaemon new];
		NSConnection *connection = [NSConnection defaultConnection];
            // register connection
		[connection setRootObject:daemon];
		[connection registerName:MFDaemonRegisteredName];

		// run runloop
		[daemon start];
		[[NSRunLoop currentRunLoop] run];

		[daemon release];
		[pool release];
    }
    return 0;
}

