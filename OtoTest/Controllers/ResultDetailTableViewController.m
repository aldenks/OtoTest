//
//  ResultDetailTableViewController.m
//  OtoTest
//
//  Created by alden on 1/10/13.
//  Copyright (c) 2013 alden. All rights reserved.
//

#import "ResultDetailTableViewController.h"

@interface ResultDetailTableViewController () {
  NSDateFormatter *_dateFormatter;
}

@end

@implementation ResultDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
  self.title = [[self dateFormatter] stringFromDate:self.result.date];
  
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"freq" ascending:YES selector:@selector(localizedStandardCompare:)];
  self.freqResults = [self.result.frequencyResults sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section) {
    case 0:
      return [self.freqResults count];
    case 1:
      return 1;
    default:
      return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case 0: {
      OTFrequencyResult *fr = self.freqResults[indexPath.row];
      static NSString *CellIdentifier = @"FrequencyResultCell";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

      cell.textLabel.text = fr.freq;
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ dB", fr.dB];
      
      return cell;
    }
    case 1: {
      static NSString *CellIdentifier = @"EmailButtonCell";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
      return cell;
    }
    default:
      return nil;
  }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Email

- (IBAction)presentMailer
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
  NSString *dateString = [[self dateFormatter] stringFromDate:self.result.date];
  NSString *subject = [NSString stringWithFormat:@"Hearing Test Results %@", dateString];
  NSMutableString *body = [NSMutableString stringWithCapacity:100];
  [body appendFormat:@"My ototoxicity hearing test results from %@.\n\n", dateString];
  for (OTFrequencyResult *fr in self.freqResults) {
    [body appendFormat:@"%@: %@ dB\n", fr.freq, fr.dB];
  }
  [mailer setMailComposeDelegate:self];
  [mailer setSubject:subject];
  NSString *toEmail = [[NSUserDefaults standardUserDefaults] stringForKey:@"results_to_email"];
  [mailer setToRecipients:@[toEmail]];
  [mailer setMessageBody:body isHTML:NO];
  [self presentViewController:mailer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  if (result == MFMailComposeResultFailed) {
    NSString *msg = [NSString stringWithFormat:@"Sorry :( The error is: %@", [error localizedDescription]];
    [[[UIAlertView alloc] initWithTitle:@"Oh No! Email Sending Failed" message:msg
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
  }
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Lazy Loaders

- (NSDateFormatter *)dateFormatter
{
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  }
  return _dateFormatter;
}

@end
