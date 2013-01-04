//
//  Result.h
//  OtoTest
//
//  Created by alden on 12/30/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OTFrequencyResult;

@interface OTResult : NSManagedObject

@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSSet *frequencyResults;
@end

@interface OTResult (CoreDataGeneratedAccessors)

- (void)addFrequencyResultsObject:(OTFrequencyResult *)value;
- (void)removeFrequencyResultsObject:(OTFrequencyResult *)value;
- (void)addFrequencyResults:(NSSet *)values;
- (void)removeFrequencyResults:(NSSet *)values;

@end
