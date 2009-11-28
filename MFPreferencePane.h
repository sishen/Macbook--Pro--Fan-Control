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
#import <NSPreferencePane.h>
#import "MFDefinitions.h"

@class MFDaemon, MFChartView, MFTemperatureTransformer;


@interface MFPreferencePane : NSPreferencePane {

    // bindings controller
    IBOutlet NSObjectController *fileOwnerController;
	
    // text fields
    IBOutlet NSTextField *leftFanField;
    IBOutlet NSTextField *rightFanField;
    IBOutlet NSTextField *temperatureField;

    // chart view
    IBOutlet MFChartView *chartView;

    // daemon proxy
    MFDaemon *daemon;

    // temperature transformer
    MFTemperatureTransformer *transformer;

    // update timer
    NSTimer *timer;
}

// accessors
- (int)baseRpm;
- (void)setBaseRpm:(int)newBaseRpm;
- (float)lowerThreshold;
- (void)setLowerThreshold:(float)newLowerThreshold;
- (float)upperThreshold;
- (void)setUpperThreshold:(float)newUpperThreshold;
- (BOOL)fahrenheit;
- (void)setFahrenheit:(BOOL)newFahrenheit;

@end
