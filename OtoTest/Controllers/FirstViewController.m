//
//  FirstViewController.m
//  OtoTest
//
//  Created by alden on 12/21/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (IBAction)begin:(UIButton *)sender {
  
  Result *result = (Result *)[NSEntityDescription insertNewObjectForEntityForName:@"Result"
                                                  inManagedObjectContext:self.managedObjectContext];
  result.date = [NSDate date];
  
  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"Failed to save MOC");
  }
  
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
