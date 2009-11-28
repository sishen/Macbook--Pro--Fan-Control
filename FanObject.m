//
//  FanObject.m
//  Fan Control
//
//  Created by Ye Dingding on 09-11-28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FanObject.h"
#import "MFDefinitions.h"

@implementation FanObject

@synthesize type, baseRpm, lowerThreshold, upperThreshold, currentRpm;

+ (FanObject *)fanObjectWithFanType:(FanType)ft Dictionary:(NSDictionary *)dictionary {
	NSNumber *bp = [dictionary objectForKey:@"baseRpm"];
	NSNumber *lts = [dictionary objectForKey:@"lowerThreshold"];
	NSNumber *uts = [dictionary objectForKey:@"upperThreshold"];
	
	return [[[FanObject alloc] initWithFanType:ft BaseRpm:[bp intValue] LowerThreshold:[lts floatValue] UpperThreshold:[uts floatValue]] autorelease];
}

- (id)init:(FanType)ft {
	return [self initWithFanType:ft BaseRpm:MFBaseRpm LowerThreshold:MFLowerThreshold UpperThreshold:MFUpperThreshold];
}

- (id)initWithFanType:(FanType)ft BaseRpm:(int)br LowerThreshold:(float)lts UpperThreshold:(float)uts {
	if (self = [super init]) {
		self.type = ft;
		self.baseRpm = br;
		self.lowerThreshold = lts;
		self.upperThreshold = uts;
	}
	return self;
}

- (NSMutableDictionary *)dictionary {
	NSArray *keys = [NSArray arrayWithObjects:@"baseRpm", @"lowerThreshold", @"upperThreshold", nil];
	NSArray *values = [NSArray arrayWithObjects:[NSNumber numberWithInt:baseRpm], [NSNumber numberWithFloat:lowerThreshold],
					   [NSNumber numberWithFloat:upperThreshold], nil];
	return [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
}

- (NSInteger)calculateTargetRpm:(double)cpu_temp {
	int targetRpm;
    int step;
	
	if (cpu_temp < lowerThreshold) {
        targetRpm = baseRpm;
    } else if (cpu_temp > upperThreshold) {
        targetRpm = MFMaxRpm;
    } else {
        targetRpm = baseRpm + (cpu_temp - lowerThreshold) / (upperThreshold - lowerThreshold) * (MFMaxRpm - baseRpm);
    }
	
    // adjust fan speed in reasonable steps - no need to be too dynamic
    if (currentRpm == 0) {
        step = targetRpm;
    } else {
        step = (targetRpm - currentRpm) / 6;
        if (abs(step) < 20) {
            step = 0;
        }
    }
    targetRpm = currentRpm = currentRpm + step;
	return targetRpm;
}

@end
