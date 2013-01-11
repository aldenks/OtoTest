//
//  ResultDetailTableViewController.h
//  OtoTest
//
//  Created by alden on 1/10/13.
//  Copyright (c) 2013 alden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ResultDetailTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

- (IBAction)presentMailer;
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

@property OTResult *result;
@property NSArray *freqResults;

@end
