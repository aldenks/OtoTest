//
//  SecondViewController.m
//  OtoTest
//
//  Created by alden on 12/21/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self presentMailer:nil];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Mail
- (IBAction)presentMailer:(id)sender
{
  if (![MFMailComposeViewController canSendMail]) {
    [[[UIAlertView alloc] initWithTitle:@"Please Configure Mail"
                               message:@"No email account configured on this device, please go to the mail app and connect an email account."
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil] show];
    return;
  }
  MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
  [mailer setMailComposeDelegate:self];
  [mailer setSubject:@"Test Results"];
  [mailer setToRecipients:@[@"aldenkeefesampson@gmail.com"]];
  [mailer setMessageBody:@"body text yoo" isHTML:NO];
  [self presentViewController:mailer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  NSLog(@"compose result: %u", result);
  if (result == MFMailComposeResultFailed) {
    NSString *msg = [NSString stringWithFormat:@"Sorry :( The error is: %@", [error localizedDescription]];
    [[[UIAlertView alloc] initWithTitle:@"Oh No! Sending Failed" message:msg
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
  }
  [self dismissModalViewControllerAnimated:YES];
}

@end
