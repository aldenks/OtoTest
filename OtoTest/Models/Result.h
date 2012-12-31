//
//  Result.h
//  OtoTest
//
//  Created by alden on 12/30/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FrequencyResult;

@interface Result : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *frequencyResults;
@end

@interface Result (CoreDataGeneratedAccessors)

- (void)addFrequencyResultsObject:(FrequencyResult *)value;
- (void)removeFrequencyResultsObject:(FrequencyResult *)value;
- (void)addFrequencyResults:(NSSet *)values;
- (void)removeFrequencyResults:(NSSet *)values;

@end
