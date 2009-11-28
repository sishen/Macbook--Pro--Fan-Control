//
//  FanObject.h
//  Fan Control
//
//  Created by Ye Dingding on 09-11-28.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFProtocol.h"

@interface FanObject : NSObject {
	FanType type;
    int baseRpm;
    float lowerThreshold;
    float upperThreshold;
    int currentRpm;
}

@property (nonatomic, assign) FanType type;
@property (nonatomic, assign) int baseRpm;
@property (nonatomic, assign) float lowerThreshold;
@property (nonatomic, assign) float upperThreshold;
@property (nonatomic, assign) int currentRpm;

+ (FanObject *)fanObjectWithFanType:(FanType)ft Dictionary:(NSDictionary *)dictionary;

- (id)init:(FanType)ft;
- (id)initWithFanType:(FanType)ft BaseRpm:(int)br LowerThreshold:(float)lts UpperThreshold:(float)uts;

- (NSMutableDictionary *)dictionary;
- (NSInteger)calculateTargetRpm:(double)cpu_temp;

@end
