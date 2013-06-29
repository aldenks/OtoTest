//
//  SettingsViewController.m
//  OtoTest
//
//  Created by alden on 6/27/13.
//  Copyright (c) 2013 alden. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
  self.toEmailAddressTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"results_to_email"];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  // use textField.tag to identify different textFields
  [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:@"results_to_email"];
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - Seed DB Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == alertView.firstOtherButtonIndex) {
    OTResult *result = (OTResult *)[NSEntityDescription insertNewObjectForEntityForName:@"OTResult"
                                                                 inManagedObjectContext:self.managedObjectContext];
    result.date = [NSDate dateWithTimeIntervalSince1970:1340994422];
    for (NSString *hz in [OTShared toneFiles]) {
      OTFrequencyResult *fr = (OTFrequencyResult *)[NSEntityDescription insertNewObjectForEntityForName:@"OTFrequencyResult"
                                                                                 inManagedObjectContext:self.managedObjectContext];

      fr.freq = hz;
      fr.dB = @(10);
      [result addFrequencyResultsObject:fr];
      [self.managedObjectContext save:nil];
    }
  }
  [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
  self.dbSeedAlertView = nil;
}

- (IBAction)userDidRotateGesture:(UIRotationGestureRecognizer *)sender {
  CGFloat r = sender.rotation;
  if ((r > 2.0 || r < -2.0) && !self.dbSeedAlertView) {
    self.dbSeedAlertView = [[UIAlertView alloc] initWithTitle:@"Seed Database With Dummy Data?"
                                                      message:@"This will add a fake test result useful for testing this app. If you don't know how you got here, tap Cancel."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel" otherButtonTitles:@"Seed Data", nil];
    [self.dbSeedAlertView show];
  }
}

- (void)viewDidUnload {
  [self setToEmailAddressTextField:nil];
  [super viewDidUnload];
}
@end