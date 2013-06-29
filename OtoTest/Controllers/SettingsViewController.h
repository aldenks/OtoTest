//
//  SettingsViewController.h
//  OtoTest
//
//  Created by alden on 6/27/13.
//  Copyright (c) 2013 alden. All rights reserved.
//

#import "OTViewController.h"

@interface SettingsViewController : OTViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *toEmailAddressTextField;
@property UIAlertView *dbSeedAlertView;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
