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

#import "MFChartView.h"
#import "MFDefinitions.h"

// definitions depending on view size and labels - adjust when changing graph view
#define MFPixelPerDegree    2.5
#define MFPixelPerRpm       0.021
#define MFGraphMinTemp      25.0
#define MFGraphMaxTemp      95.0
#define MFGraphMinRpm       700
#define MFGraphMaxRpm       6500


@implementation MFChartView

- (id)initWithFrame:(NSRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code here.
    }
    return self;
}

- (NSPoint)coordinateForTemp:(float)temp andRpm:(int)rpm
{
    NSPoint coordinate = [self bounds].origin;
    coordinate.x += roundf((temp - MFGraphMinTemp) * MFPixelPerDegree);
    coordinate.y += roundf((rpm - MFGraphMinRpm) * MFPixelPerRpm);
    return coordinate;
}

- (void)drawRect:(NSRect)rect
{
    int targetRpm;
    // draw background and border
    [[NSColor whiteColor] set];
    NSRectFill([self bounds]);
    [[NSColor blackColor] set];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:[self bounds]];
    [path stroke];

    // draw graph
    [[NSColor redColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:baseRpm]];
    [path lineToPoint:[self coordinateForTemp:lowerThreshold andRpm:baseRpm]];
    [path lineToPoint:[self coordinateForTemp:upperThreshold andRpm:MFMaxRpm]];
    [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:MFMaxRpm]];
    [path setLineWidth:2.0];
    [path stroke];
    
    // draw temperature line
    [[NSColor greenColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:currentTemp andRpm:MFGraphMinRpm]];
    [path lineToPoint:[self coordinateForTemp:currentTemp andRpm:MFGraphMaxRpm]];
    [path stroke];

    // draw target RPM line
    if (currentTemp < lowerThreshold) {
        targetRpm = baseRpm;
    } else if (currentTemp > upperThreshold) {
        targetRpm = MFMaxRpm;
    } else {
        targetRpm = baseRpm + (currentTemp - lowerThreshold) / (upperThreshold - lowerThreshold) * (MFMaxRpm - baseRpm);
    }
    [[NSColor blueColor] set];
    path = [NSBezierPath bezierPath];
    [path moveToPoint:[self coordinateForTemp:MFGraphMinTemp andRpm:targetRpm]];
    [path lineToPoint:[self coordinateForTemp:MFGraphMaxTemp andRpm:targetRpm]];
    [path stroke];
}

// accessors
- (void)setBaseRpm:(int)newBaseRpm
{
	baseRpm = newBaseRpm;
    [self setNeedsDisplay:YES];
}

- (void)setLowerThreshold:(float)newLowerThreshold
{
	lowerThreshold = newLowerThreshold;
    [self setNeedsDisplay:YES];
}

- (void)setUpperThreshold:(float)newUpperThreshold
{
	upperThreshold = newUpperThreshold;
    [self setNeedsDisplay:YES];
}

- (void)setCurrentTemp:(float)newCurrentTemp
{
    currentTemp = newCurrentTemp;
    [self setNeedsDisplay:YES];
}

@end
