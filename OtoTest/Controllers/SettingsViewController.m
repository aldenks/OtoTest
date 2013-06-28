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

- (void)viewDidUnload {
  [self setToEmailAddressTextField:nil];
  [super viewDidUnload];
}
@end