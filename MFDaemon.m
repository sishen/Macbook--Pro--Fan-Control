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

#import "MFDaemon.h"
#import "MFProtocol.h"
#import "MFDefinitions.h"
#import "smc.h"

#define MFApplicationIdentifier     "com.lobotomo.MacProFan"

#pragma mark Helper Method

double SMCGetGPUTemperature() {
	double gpuTemp = SMCGetTemperature(SMC_KEY_GPU_TEMP);
	if (gpuTemp <= 0.001) {
		gpuTemp = SMCGetTemperature(SMC_KEY_GPU_DIODE_TEMP);
	}
	return gpuTemp;
}

@implementation MFDaemon
@synthesize leftFan, rightFan;

- (id)init
{
    if (self = [super init]) {
        // set sane defaults
        self.leftFan = [[FanObject alloc] init:LeftFan];
		self.rightFan = [[FanObject alloc] init:RightFan];
    }
    return self;
}

// store preferences
- (void)storePreferences
{
	CFPreferencesSetValue(CFSTR("Left Fan"), (CFPropertyListRef)[leftFan dictionary],
						  CFSTR(MFApplicationIdentifier), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
	CFPreferencesSetValue(CFSTR("Right Fan"), (CFPropertyListRef)[rightFan dictionary],
						  CFSTR(MFApplicationIdentifier), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    CFPreferencesSetValue(CFSTR("fahrenheit"), (CFPropertyListRef)[NSNumber numberWithBool:fahrenheit],
                          CFSTR(MFApplicationIdentifier), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
	CFPreferencesSetValue(CFSTR("runTimer"), (CFPropertyListRef)[NSNumber numberWithBool:runTimer], 
						  CFSTR(MFApplicationIdentifier), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    CFPreferencesSynchronize(CFSTR(MFApplicationIdentifier), kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
}

// read preferences
- (void)readPreferences
{
    CFPropertyListRef property;
    property = CFPreferencesCopyValue(CFSTR("Left Fan"), CFSTR(MFApplicationIdentifier),
               kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    if (property) {
		self.leftFan = [FanObject fanObjectWithFanType:LeftFan Dictionary:(NSDictionary *)property];
    }
    property = CFPreferencesCopyValue(CFSTR("Right Fan"), CFSTR(MFApplicationIdentifier),
               kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    if (property) {
		self.rightFan = [FanObject fanObjectWithFanType:RightFan Dictionary:(NSDictionary *)property];
    }
    property = CFPreferencesCopyValue(CFSTR("fahrenheit"), CFSTR(MFApplicationIdentifier),
               kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
    if (property) {
        fahrenheit = [(NSNumber *)property boolValue];
    }
	property = CFPreferencesCopyValue(CFSTR("runTimer"), CFSTR(MFApplicationIdentifier), 
			   kCFPreferencesAnyUser, kCFPreferencesCurrentHost);
	if (property) {
		runTimer = [(NSNumber *)property boolValue];
	}
}

// this gets called after application start
- (void)start
{
    [self readPreferences];
	[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
}

- (void)startTimer {
	runTimer = TRUE;
	needWrite = TRUE;
}

- (void)stopTimer {
	runTimer = FALSE;
	needWrite = TRUE;
}

- (BOOL)isTimerAvailable {
	return runTimer;
}

// control loop called by NSTimer
- (void)timer:(NSTimer *)aTimer
{
	if (runTimer) {
		SMCOpen();

		double cpu_temp = SMCGetTemperature(SMC_KEY_CPU_TEMP);
		double gpu_temp = SMCGetGPUTemperature();
		
		SMCSetFanRpm(SMC_KEY_FAN0_RPM_MIN, [leftFan calculateTargetRpm:cpu_temp]);
		SMCSetFanRpm(SMC_KEY_FAN1_RPM_MIN, [rightFan calculateTargetRpm:gpu_temp]);

		SMCClose();
	}

    // save preferences
    if (needWrite) {
        [self storePreferences];
        needWrite = NO;
    }
}

- (void)dealloc
{
	[leftFan release];
	[rightFan release];
	
	[super dealloc];
}

// accessors
- (int)baseRpm:(FanType)ft
{
	switch (ft) {
		case LeftFan:
			return leftFan.baseRpm;
		case RightFan:
			return rightFan.baseRpm;
		default:
			return MFBaseRpm;
	}
}

- (void)setBaseRpm:(int)newBaseRpm Fan:(FanType)ft;
{
	switch (ft) {
		case LeftFan:
			self.leftFan.baseRpm = newBaseRpm;
			break;
		case RightFan:
			self.rightFan.baseRpm = newBaseRpm;
			break;
	}
    needWrite = YES;
}

- (float)lowerThreshold:(FanType)ft;
{
	switch (ft) {
		case LeftFan:
			return leftFan.lowerThreshold;
		case RightFan:
			return rightFan.lowerThreshold;
		default:
			return MFLowerThreshold;
	}
}

- (void)setLowerThreshold:(float)newLowerThreshold Fan:(FanType)ft;
{
	switch (ft) {
		case LeftFan:
			self.leftFan.lowerThreshold = newLowerThreshold;
			break;
		case RightFan:
			self.rightFan.lowerThreshold = newLowerThreshold;
			break;
	}
    needWrite = YES;
}

- (float)upperThreshold:(FanType)ft;
{
	switch (ft) {
		case LeftFan:
			return leftFan.upperThreshold;
		case RightFan:
			return rightFan.upperThreshold;
		default:
			return MFUpperThreshold;
	}
}

- (void)setUpperThreshold:(float)newUpperThreshold Fan:(FanType)ft;
{
	switch (ft) {
		case LeftFan:
			self.leftFan.upperThreshold = newUpperThreshold;
			break;
		case RightFan:
			self.rightFan.upperThreshold = newUpperThreshold;
			break;
	}
    needWrite = YES;
}

- (BOOL)fahrenheit
{
	return fahrenheit;
}

- (void)setFahrenheit:(BOOL)newFahrenheit
{
	fahrenheit = newFahrenheit;
    needWrite = YES;
}

- (void)cpuTemperature:(float *)cpuTemperature gpuTemperature:(float *)gpuTemperature leftFanRpm:(int *)leftFanRpm rightFanRpm:(int *)rightFanRpm
{
    SMCOpen();
    if (cpuTemperature) {
        *cpuTemperature = SMCGetTemperature(SMC_KEY_CPU_TEMP);
    }
	if (gpuTemperature) {
		*gpuTemperature = SMCGetGPUTemperature();
	}
    if (leftFanRpm) {
        *leftFanRpm = SMCGetFanRpm(SMC_KEY_FAN0_RPM_CUR);
    }
    if (rightFanRpm) {
        *rightFanRpm = SMCGetFanRpm(SMC_KEY_FAN1_RPM_CUR);
    }
    SMCClose();
}

- (int)getFanCount {
    SMCOpen();
	int count = getFanCount();
	SMCClose();
	return count;
}

@end
