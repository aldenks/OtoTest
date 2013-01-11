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

@property (nonatomic, strong) NSString *freq;
@property (nonatomic, strong) NSNumber *dB;
@property (nonatomic, strong) OTResult *result;

@end
