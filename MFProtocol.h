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

#import "MFDefinitions.h"

#define MFDaemonRegisteredName  @"com.lobotomo.MFDaemonRegisteredName"

@protocol MFProtocol
- (int)baseRpm:(FanType)tf;
- (void)setBaseRpm:(int)newBaseRpm Fan:(FanType)tf;
- (float)lowerThreshold:(FanType)tf;
- (void)setLowerThreshold:(float)newLowerThreshold Fan:(FanType)tf;
- (float)upperThreshold:(FanType)tf;
- (void)setUpperThreshold:(float)newUpperThreshold Fan:(FanType)tf;
- (BOOL)fahrenheit;
- (void)setFahrenheit:(BOOL)newFahrenheit;
- (void)cpuTemperature:(float *)cpuTemperature gpuTemperature:(float *)gpuTemperature leftFanRpm:(int *)leftFanRpm rightFanRpm:(int *)rightFanRpm;
- (void)startTimer;
- (void)stopTimer;
- (BOOL)isTimerAvailable;
- (int)getFanCount;
@end