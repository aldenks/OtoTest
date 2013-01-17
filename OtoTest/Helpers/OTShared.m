//
//  OTShared.m
//  OtoTest
//
//  Created by alden on 1/2/13.
//  Copyright (c) 2013 alden. All rights reserved.
//

#import "OTShared.h"

static NSArray *_toneFiles;

@implementation OTShared

+ (NSArray *)toneFiles
{
  if (!_toneFiles)
    // TODO revert
    //_toneFiles = @[@"8000Hz", @"9000Hz", @"10000Hz", @"11200Hz", @"12500Hz", @"14000Hz", @"16000Hz"];
    _toneFiles = @[@"8000Hz", @"9000Hz"];
  return _toneFiles;
}

@end
