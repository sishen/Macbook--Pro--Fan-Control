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

#import "MFTemperatureTransformer.h"


@implementation MFTemperatureTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)beforeObject
{
    float degrees = [beforeObject floatValue];
    unichar c = 0x00b0;
    NSString *degreeChar = [NSString stringWithCharacters:&c length:1];
    if (fahrenheit) {
        degrees = degrees / 5.0 * 9.0 + 32;
        return [NSString stringWithFormat:@"%.0f %@F", degrees, degreeChar];
    } else {
        return [NSString stringWithFormat:@"%.1f %@C", degrees, degreeChar];
    }
}

// accessors
- (BOOL)fahrenheit
{
	return fahrenheit;
}

- (void)setFahrenheit:(BOOL)newFahrenheit
{
	fahrenheit = newFahrenheit;
}

@end
