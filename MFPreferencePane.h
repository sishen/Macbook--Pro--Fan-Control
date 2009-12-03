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
    IBOutlet NSTextField *cpuTemperatureField;

	IBOutlet NSTextField *rightFanField;
	IBOutlet NSTextField *gpuTemperatureField;
	
    // chart view
    IBOutlet MFChartView *leftChartView;
	IBOutlet MFChartView *rightChartView;

	// radio buttons
	IBOutlet NSMatrix *serviceControl;
	
    // daemon proxy
    MFDaemon *daemon;

    // temperature transformer
    MFTemperatureTransformer *transformer;

    // update timer
    NSTimer *timer;
}

// accessors
- (int)leftBaseRpm;
- (int)rightBaseRpm;
- (void)setLeftBaseRpm:(int)newBaseRpm;
- (void)setRightBaseRpm:(int)newBaseRpm;
- (float)leftLowerThreshold;
- (float)rightLowerThreshold;
- (void)setLeftLowerThreshold:(float)newLowerThreshold;
- (void)setRightLowerThreshold:(float)newLowerThreshold;
- (float)leftUpperThreshold;
- (float)rightUpperThreshold;
- (void)setLeftUpperThreshold:(float)newUpperThreshold;
- (void)setRightUpperThreshold:(float)newUpperThreshold;
- (BOOL)fahrenheit;
- (void)setFahrenheit:(BOOL)newFahrenheit;

- (IBAction)doService:(id)sender;

@end
