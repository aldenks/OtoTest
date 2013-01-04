//
//  SecondViewController.h
//  OtoTest
//
//  Created by alden on 12/21/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "OTViewController.h"

@interface SecondViewController : OTViewController <MFMailComposeViewControllerDelegate>

- (IBAction)presentMailer:(id)sender;
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

@end
