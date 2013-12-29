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
    _toneFiles = @[@"8000Hz", @"10000Hz", @"12500Hz", @"16000Hz"];
  return _toneFiles;
}

+ (void)logTestResult:(OTResult *)result
{
  NSLog(@"RESULT %@", result.date);
  for (OTFrequencyResult *fr in result.frequencyResults) {
    NSLog(@"  %@: %@", fr.freq, fr.dB);
  }
  NSLog(@"");
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

@end
