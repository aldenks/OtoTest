//
//  ResultsNavigationController.m
//  OtoTest
//
//  Created by alden on 1/10/13.
//  Copyright (c) 2013 alden. All rights reserved.
//

#import "OTNavigationController.h"

@interface OTNavigationController ()

@end

@implementation OTNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  for (id vc in self.viewControllers) {
    if ([vc respondsToSelector:@selector(setManagedObjectContext:)])
      [vc setManagedObjectContext:self.managedObjectContext];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
