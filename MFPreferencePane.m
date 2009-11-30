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

#import "MFPreferencePane.h"
#import "MFProtocol.h"
#import "MFTemperatureTransformer.h"
#import "MFChartView.h"


@implementation MFPreferencePane


- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super initWithBundle:bundle]) {
        transformer = [MFTemperatureTransformer new];
        [NSValueTransformer setValueTransformer:transformer forName:@"MFTemperatureTransformer"];
    }
    return self;
}

- (void)dealloc
{
    [transformer release];
    [super dealloc];
}

- (void)updateOutput:(NSTimer *)aTimer
{
    float temp;
    int leftFanRpm;
    int rightFanRpm;

    [daemon temperature:&temp leftFanRpm:&leftFanRpm rightFanRpm:&rightFanRpm];
    [leftFanField setIntValue:leftFanRpm];
    [rightFanField setIntValue:rightFanRpm];
    [cpuTemperatureField setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:temp]]];
	[gpuTemperatureField setStringValue:[transformer transformedValue:[NSNumber numberWithFloat:temp]]];
    [leftChartView setCurrentTemp:temp];
	[rightChartView setCurrentTemp:temp];
}

- (void)awakeFromNib
{
    // connect to daemon
    NSConnection *connection = [NSConnection connectionWithRegisteredName:MFDaemonRegisteredName host:nil];
    daemon = [[connection rootProxy] retain];
    [(id)daemon setProtocolForProxy:@protocol(MFProtocol)];

    // set transformer mode
    [transformer setFahrenheit:[self fahrenheit]];

    // connect to object controller
    [fileOwnerController setContent:self];
}

// sent before preference pane is displayed
- (void)willSelect
{
    // update chart
    [leftChartView setBaseRpm:[self leftBaseRpm]];
    [leftChartView setLowerThreshold:[self leftLowerThreshold]];
    [leftChartView setUpperThreshold:[self leftUpperThreshold]];
	[rightChartView setBaseRpm:[self rightBaseRpm]];
	[rightChartView setLowerThreshold:[self rightLowerThreshold]];
	[rightChartView setUpperThreshold:[self rightUpperThreshold]];
	
    // update output immediatly, then every 5 seconds
    [self updateOutput:nil];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateOutput:)
                     userInfo:nil repeats:YES];
}

// sent after preference pane is ordered out
- (void)didUnselect
{
    // stop updates
    [timer invalidate];
    timer = nil;
}

// accessors (via daemon)
- (int)leftBaseRpm {
	return [daemon baseRpm:LeftFan];
}

- (int)rightBaseRpm {
	return [daemon baseRpm:RightFan];
}

- (void)setLeftBaseRpm:(int)newBaseRpm {
	[daemon setBaseRpm:newBaseRpm Fan:LeftFan];
	[leftChartView setBaseRpm:newBaseRpm];
}

- (void)setRightBaseRpm:(int)newBaseRpm {
	[daemon setBaseRpm:newBaseRpm Fan:RightFan];
	[rightChartView setBaseRpm:newBaseRpm];
}

- (float)leftLowerThreshold {
	return [daemon lowerThreshold:LeftFan];
}

- (float)rightLowerThreshold {
	return [daemon lowerThreshold:RightFan];
}

- (void)setLeftLowerThreshold:(float)newLowerThreshold {
	[daemon setLowerThreshold:newLowerThreshold Fan:LeftFan];
	[leftChartView setLowerThreshold:newLowerThreshold];
}

- (void)setRightLowerThreshold:(float)newLowerThreshold {
	[daemon setLowerThreshold:newLowerThreshold Fan:RightFan];
	[rightChartView setLowerThreshold:newLowerThreshold];
}

- (float)leftUpperThreshold {
	return [daemon upperThreshold:LeftFan];
}

- (float)rightUpperThreshold {
	return [daemon upperThreshold:RightFan];
}

- (void)setLeftUpperThreshold:(float)newUpperThreshold {
	[daemon setUpperThreshold:newUpperThreshold Fan:LeftFan];
	[leftChartView setUpperThreshold:newUpperThreshold];
}

- (void)setRightUpperThreshold:(float)newUpperThreshold {
	[daemon setUpperThreshold:newUpperThreshold Fan:RightFan];
	[rightChartView setUpperThreshold:newUpperThreshold];
}

- (BOOL)fahrenheit
{
	return [daemon fahrenheit];
}

- (void)setFahrenheit:(BOOL)newFahrenheit
{
	[daemon setFahrenheit:newFahrenheit];
    [transformer setFahrenheit:newFahrenheit];
    // force display update
    [self updateOutput:nil];
    [fileOwnerController setContent:nil];
    [fileOwnerController setContent:self];
}

@end
