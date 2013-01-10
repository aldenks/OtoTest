//
//  HearingTestTests.m
//  OtoTest
//
//  Created by alden on 1/10/13.
//  Copyright (c) 2013 alden. All rights reserved.
//

#import "HearingTestTests.h"

@implementation HearingTestTests

- (void)testIsDoneWithFrequency
{
  FirstViewController *vc = [[FirstViewController alloc] init];
  NSNumber *tru  = [NSNumber numberWithBool:YES];
  NSNumber *fals = [NSNumber numberWithBool:NO];
  vc.testPhase = OTTestPhaseSecond;
  vc.toneHeardHistory = [NSMutableArray arrayWithArray:@[]];
  STAssertFalse([vc isDoneWithFrequency], @"must not be done with frequency if tone history is empty");
  
  vc.toneHeardHistory = [NSMutableArray arrayWithArray:@[fals,fals,tru]];
  STAssertFalse([vc isDoneWithFrequency], @"must not be done with frequency if heard 1/3 times");
  vc.toneHeardHistory = [NSMutableArray arrayWithArray:@[fals,tru,tru]];
  STAssertTrue([vc isDoneWithFrequency], @"must be done with frequency if heard 2/3 times");
  vc.toneHeardHistory = [NSMutableArray arrayWithArray:@[tru,fals,tru]];
  STAssertTrue([vc isDoneWithFrequency], @"must be done with frequency if heard 2/3 times");
  vc.toneHeardHistory = [NSMutableArray arrayWithArray:@[tru,tru,tru]];
  STAssertTrue([vc isDoneWithFrequency], @"must be done with frequency if heard 3/3 times");
}

@end
