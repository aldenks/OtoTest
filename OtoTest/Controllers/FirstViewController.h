//
//  FirstViewController.h
//  OtoTest
//
//  Created by alden on 12/21/12.
//  Copyright (c) 2012 alden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "OTViewController.h"

#define INTER_TONE_TIME        5.0   // in seconds
#define RECOGNITION_WINDOW     4.0   // in seconds
#define FIRST_INCREASE_DB_AMT  20.0  // in decibles
#define SECOND_INCREASE_DB_AMT 5.0
#define DECREASE_DB_AMT        10.0
#define ACTUAL_INITIAL_DB      30.0
// avoid special cases for first play of a frequency, and first frequency
#define INITIAL_DB             ACTUAL_INITIAL_DB - FIRST_INCREASE_DB_AMT 
#define INITIAL_FREQ_IDX       -1

// Phases of the Hughson-Westlake test. These aren't anything official
// they just help the implementation.
typedef enum {
  OTTestPhaseFirst,  // larger decible changes, going up until first time tone is heard
  OTTestPhaseSecond, // narowing on and finding the threshold
} OTTestPhase;

@interface FirstViewController : OTViewController

@property (weak, nonatomic) IBOutlet UIButton *heardItButton;

@property AVAudioPlayer *player;
@property NSArray *frequencies;

@property OTResult *result;          // The result object for the current test
@property OTTestPhase testPhase;     // current phase of the test
@property NSUInteger frequencyIndex; // current index into the frequencies array
@property double dBVolume;           // last decible volume played
@property NSDate *lastToneTime;      // time at which the most recent tone was played
@property BOOL lastToneWentUp;       // was the volume increased for the last tone?
@property BOOL heardLastTone;        // has user heard most recent tone?
@property NSMutableArray *toneHeardHistory; // heard tone? BOOL array for last 0-3 tones

- (IBAction)beginTest;
- (IBAction)heardTone;

- (void)doToneForTest;
- (void)finishFrequency;
- (void)finishTest;
- (BOOL)isDoneWithFrequency;
- (double)volumeFromDecibles:(double)decibles;

@end
