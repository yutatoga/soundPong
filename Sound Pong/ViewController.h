//
//  ViewController.h
//  Sound Pong
//
//  Created by SystemTOGA on 8/3/12.
//  Copyright (c) 2012 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController : UIViewController<AVAudioRecorderDelegate, AVAudioSessionDelegate, AVAudioPlayerDelegate>{
    AVAudioRecorder *recorder;
    IBOutlet UIProgressView *peakPowerForChannelProgress;
    IBOutlet UIProgressView *averagePowerForChannelProgress;
    IBOutlet UIImageView *blockImageView;
    IBOutlet UIImageView *ballImageView;
    IBOutlet UILabel *firstGuideMessageLabel;
    IBOutlet UILabel *counterLabel;
    IBOutlet UIImageView *checkCircle;
	NSTimer *levelTimer;
    BOOL isThereBall;
    BOOL oneTouchWall;
    int speedX;
    int speedY;
    int counter;
    
    //audio session
    AVAudioPlayer *player;
    AVAudioSession *audioSession;
    int notMoveTimeAfterHit;
}
@end
