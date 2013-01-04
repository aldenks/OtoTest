//
//  FirstViewController.m
//  OtoTest
//
//  Created by alden on 12/21/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import "FirstViewController.h"

#define INTER_TONE_TIME 3.0
#define RECOGNITION_WINDOW 3.0

@interface FirstViewController ()

@property AVAudioPlayer *player;
@property OTResult *result;      // The result object for the current test

@property NSDate *lastToneTime;      // time at which the most recent tone was played
@property BOOL heardLastTone;    // has user heard most recent tone

@end

@implementation FirstViewController

@synthesize player;

- (IBAction)beginTest:(UIButton *)sender {
  
  
  OTResult *result = (OTResult *)[NSEntityDescription insertNewObjectForEntityForName:@"OTResult"
                                                               inManagedObjectContext:self.managedObjectContext];
  result.date = [NSDate date];
  
  // TODO handle error
  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"Failed to save MOC");
  }
}


- (IBAction)soundButtonPressed:(UIButton *)sender {
  for (NSString *fileName in [OTShared toneFiles]) {
    [self playAudioResource:fileName withExtension:@"mp3"];
    sleep(1);
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Audio

- (void)playAudioResource:(NSString *)resource withExtension:(NSString *)ext {
  NSURL *soundURL = [[NSBundle mainBundle] URLForResource:resource withExtension:ext];
  // TODO handle error
  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
  [self.player play];
}

#pragma mark -
#pragma mark Accessors

//- (AVAudioPlayer *)player
//{
//  if (!_player) {
//    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"9000Hz" withExtension:@"mp3"];
//    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
//  }
//  return _player;
//}

@end
  
