//
//  FirstViewController.m
//  OtoTest
//
//  Created by alden on 12/21/12.
//  Copyright (c) 2012 alden. All rights reserved.
//
//  This controller administrates the Hughson-Westlake hearing test procedure.
//  A good flowchart of this test is available at
//  http://www.who.int/occupational_health/publications/noise8.pdf
//  on page 194, although the decible increments are slightly different here.

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
  // Do any additional setup after loading the view, typically from a nib.
  [super viewDidLoad];
  self.frequencies = [OTShared toneFiles];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self beginTest];
}

- (void)viewDidUnload {
  [self setHeardItButton:nil];
  [self setPauseButton:nil];
  [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)popTestUI
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Testing

- (void)beginTest
{
  OTResult *result = (OTResult *)[NSEntityDescription insertNewObjectForEntityForName:@"OTResult"
                                                               inManagedObjectContext:self.managedObjectContext];
  result.date = [NSDate date];
  self.result = result;
  self.frequencyIndex = INITIAL_FREQ_IDX;
  self.paused = false;
  [self beginNextFrequency];
}

- (void)finishTest
{
  [OTShared logTestResult:self.result];
  // TODO clean up other vars

  // allow self.result and its related frequency results to be released
  [self.managedObjectContext refreshObject:self.result mergeChanges:NO];
  self.result = nil;
  [self popTestUI];
}

- (void)cancelTest
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];

  if (self.result) {
    [self.managedObjectContext deleteObject:self.result];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
      [NSException raise:@"Managed Object Context Save Failed" format:@"%@", [error localizedDescription]];
    }
    self.result = nil;
  }
  [self popTestUI];
  NSLog(@"Canceled test");
}

- (void)pauseTest
{
  self.paused = true;
  self.heardItButton.enabled = NO;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                    target:self action:@selector(pauseButtonPressed:)];
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  NSLog(@"Pausing test");
}

- (void)resumeTest
{
  // needed so that double tapping the play/pause button won't cause two tones
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  self.heardItButton.enabled = YES;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                    target:self action:@selector(pauseButtonPressed:)];
  [self performSelector:@selector(doToneForTest) withObject:nil afterDelay:1];
  NSLog(@"Resuming test");
}

// Main test function. called once every INTER_TONE_TIME seconds
- (void)doToneForTest
{
  if (!self.paused) {
    if (self.testPhase == OTTestPhaseSecond) {
      // maintain a history of the 4 most recent "heard it?" results for each dB value
      NSString *dBString = [NSString stringWithFormat:@"%.1f", self.dBVolume];
      NSMutableArray *toneHeardHistoryForDB = self.toneHeardHistory[dBString];
      if (!toneHeardHistoryForDB) {
        toneHeardHistoryForDB = [NSMutableArray arrayWithCapacity:4];
        self.toneHeardHistory[dBString] = toneHeardHistoryForDB;
      }
      if (toneHeardHistoryForDB.count > 4)
        [toneHeardHistoryForDB removeObjectAtIndex:0];
      [toneHeardHistoryForDB addObject:[NSNumber numberWithBool:self.heardLastTone]];
      NSLog(@"heard history:%@", self.toneHeardHistory);
    }

    if (self.heardLastTone) {
      if ([self isDoneWithFrequency]) {
        [self finishFrequency];
        return;
      } else {
        if (self.testPhase == OTTestPhaseFirst) {
          NSLog(@"Entering 2nd phase");
        }
        NSLog(@"heard it, but not done with frequency: decreasing vol by %f", DECREASE_DB_AMT);
        self.dBVolume -= DECREASE_DB_AMT;
        self.testPhase = OTTestPhaseSecond;
      }
    }
    else {
      double dBIncrease = self.testPhase == OTTestPhaseFirst ? FIRST_INCREASE_DB_AMT : SECOND_INCREASE_DB_AMT;
      self.dBVolume += dBIncrease;
      NSLog(@"didn't hear it, increasing vol by %f", dBIncrease);
    }

    if ([self volumeFromDecibles:self.dBVolume] > 1.0 ||
        [self volumeFromDecibles:self.dBVolume] <=  0 ) {
      [self finishFrequency]; // give up and try next frequency
      return;
    }
  }

  self.paused = false;
  [self playCurrentTone];
  self.heardLastTone = NO;
  self.lastToneTime  = [NSDate date];
  [self performSelector:@selector(doToneForTest) withObject:nil afterDelay:INTER_TONE_TIME];
}

- (void)beginNextFrequency
{
  self.frequencyIndex++;
  if (self.frequencyIndex < [self.frequencies count]) {
    self.testPhase = OTTestPhaseFirst;
    self.dBVolume = INITIAL_DB;
    self.lastToneTime = nil;
    self.heardLastTone = NO;
    self.toneHeardHistory = [NSMutableDictionary dictionaryWithCapacity:10];
    if (self.frequencyIndex == 0) {
      // return control to UI before starting test so it's responsive and wait a second before first tone
      [self performSelector:@selector(doToneForTest) withObject:nil afterDelay:3];
    } else {
      [self doToneForTest];
    }
  } else {
    [self finishTest];
  }
}

- (void)finishFrequency
{
  NSLog(@"done with frequency");
  OTFrequencyResult *fr = (OTFrequencyResult *)[NSEntityDescription insertNewObjectForEntityForName:@"OTFrequencyResult"
                                                                             inManagedObjectContext:self.managedObjectContext];

  fr.freq = self.frequencies[self.frequencyIndex];
  fr.dB = @(self.dBVolume);
  [self.result addFrequencyResultsObject:fr];

  NSError *error;
  if (![self.managedObjectContext save:&error]) {
    [NSException raise:@"Managed Object Context Save Failed" format:@"%@", [error localizedDescription]];
  }

  [self beginNextFrequency];
}

- (BOOL)isDoneWithFrequency
{
  NSString *dBString = [NSString stringWithFormat:@"%.1f", self.dBVolume];
  NSArray *toneHeardHistoryForDB = self.toneHeardHistory[dBString];
  if (self.testPhase != OTTestPhaseSecond || !toneHeardHistoryForDB)
    return NO;
  NSArray *ayes = [toneHeardHistoryForDB select:^(id heard, NSUInteger idx) {
    return [heard boolValue]; }];
  return [ayes count] >= 2;
}

#pragma mark -
#pragma mark Actions

- (IBAction)heardTone
{
  if (self.lastToneTime && ([self.lastToneTime timeIntervalSinceNow]*-1) <= RECOGNITION_WINDOW) 
    self.heardLastTone = YES;
}

- (IBAction)cancelTestButtonPressed
{
  [self pauseTest];
  UIActionSheet * confirmQuitSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                     cancelButtonTitle:@"Resume" destructiveButtonTitle:@"Quit"
                                     otherButtonTitles:nil];
  [confirmQuitSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
  [confirmQuitSheet showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)pauseButtonPressed:(id)sender
{
  self.paused ? [self resumeTest] : [self pauseTest];
}

#pragma mark - Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == actionSheet.destructiveButtonIndex) {
    [self cancelTest];
  } else if (buttonIndex == actionSheet.cancelButtonIndex) {
    [self resumeTest];
  }
}

#pragma mark -
#pragma mark Audio

- (void)playCurrentTone
{
  NSString *resource = [self.frequencies objectAtIndex:self.frequencyIndex];
  [self playAudioResource:resource withExtension:@"mp3"];
}

- (void)playAudioResource:(NSString *)resource withExtension:(NSString *)ext
{
  NSURL *soundURL = [[NSBundle mainBundle] URLForResource:resource withExtension:ext];
  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
  self.player.volume = [self volumeFromDecibles:self.dBVolume];
  [self.player play];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
  [self cancelTest];
}

#pragma mark - Utils
- (double)volumeFromDecibles:(double)decibles
{
  // TODO find actual ratio
  return decibles/100.0;
}

@end
  
