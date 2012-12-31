//
//  FrequencyResult.h
//  OtoTest
//
//  Created by alden on 12/30/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Result;

@interface FrequencyResult : NSManagedObject

@property (nonatomic, retain) NSNumber * freqHz;
@property (nonatomic, retain) NSNumber * vol;
@property (nonatomic, retain) Result *result;

@end
