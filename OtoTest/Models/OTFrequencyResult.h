//
//  FrequencyResult.h
//  OtoTest
//
//  Created by alden on 12/30/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OTResult;

@interface OTFrequencyResult : NSManagedObject

@property (nonatomic, strong) NSNumber *freqHz;
@property (nonatomic, strong) NSNumber *vol;
@property (nonatomic, weak)   OTResult *result;

@end
