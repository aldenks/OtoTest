//
//  ResultsTableViewController.h
//  OtoTest
//
//  Created by alden on 12/31/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/Models.h"

@interface ResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property NSMutableArray *results;

@end