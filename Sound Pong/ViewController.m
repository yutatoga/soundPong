//
//  ViewController.m
//  Sound Pong
//
//  Created by SystemTOGA on 8/3/12.
//  Copyright (c) 2012 Yuta Toga. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
    
  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (recorder) {
  		[recorder prepareToRecord];
  		recorder.meteringEnabled = YES;
  		[recorder record];
		levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
  	} else
  		NSLog(@"%@", [error description]);
    
    
    
    //by OtO
    blockImageView.image = [UIImage imageNamed:@"block.png"];
    ballImageView.image = [UIImage imageNamed:@"ball.png"];
    isThereBall = false;
    ballImageView.hidden = true;
    [firstGuideMessageLabel setNumberOfLines:0];
    firstGuideMessageLabel.text = @"Blow here!\n↓";
    do {
        speedX = arc4random()%21-10;
        speedY = arc4random()%21-10;
    } while (speedX == 0 || speedY == 0);
    NSLog(@"speedX:%d speedY:%d", speedX, speedY);
    counter = 0;
    counterLabel.text = @"0";
    checkCircle.image = [UIImage imageNamed:@"redcircle.png"];
    checkCircle.hidden = true;
    oneTouchWall = true;
}

- (void)levelTimerCallback:(NSTimer *)timer {
    if (isThereBall == false) {
        if ([recorder peakPowerForChannel:0] == 0.000000) {
            isThereBall = true;
            ballImageView.hidden = false;
            firstGuideMessageLabel.hidden = true;
            checkCircle.hidden = false;
            ballImageView.center = CGPointMake(160, ballImageView.frame.size.height/2);
        }
    }else{
        ballImageView.center = CGPointMake(ballImageView.center.x+speedX, ballImageView.center.y+speedY);
        if (ballImageView.center.x < self.view.frame.origin.x+ballImageView.frame.size.width/2 || ballImageView.center.x > self.view.frame.origin.x+self.view.frame.size.width-ballImageView.frame.size.width/2) {
            //touch on side wall
            speedX = speedX * -1;
            oneTouchWall = true;
        }
        if (ballImageView.center.y < self.view.frame.origin.y+ballImageView.frame.size.height/2 || ballImageView.center.y > self.view.frame.origin.y+self.view.frame.size.height-ballImageView.frame.size.height/2) {
            //hit on top wall
            speedY = speedY * -1;
            oneTouchWall = true;
        }
        if (ballImageView.center.y > self.view.frame.origin.y+self.view.frame.size.height-ballImageView.frame.size.height/2) {
            //disappear to bottom
            isThereBall = false;
            ballImageView.hidden = true;
            checkCircle.hidden = true;
        }
        //about bound on the bar
        //in "NEXT MOVEMENT", ball collide the bar?
        /*
        if (ballImageView.center.y+ballImageView.frame.size.height/2+speedY >= blockImageView.frame.origin.y) {
            //hit on the top of block
            if (ballImageView.center.x >= blockImageView.frame.origin.x && ballImageView.center.x <= blockImageView.frame.origin.x+blockImageView.frame.size.width) {
                counter++;
                counterLabel.text = [NSString stringWithFormat:@"%d", counter];
                speedY = speedY * -1;
            }
        }
        */
        
        
        //hit on block
        float closestX = closestVal(ballImageView.center.x, blockImageView.frame.origin.x, blockImageView.frame.origin.x+blockImageView.frame.size.width);
        float closestY = closestVal(ballImageView.center.y, blockImageView.frame.origin.y, blockImageView.frame.origin.y+blockImageView.frame.size.height);
        checkCircle.center = CGPointMake(closestX, closestY);
        if(sqrt(pow(ballImageView.center.x-closestX, 2)+pow(ballImageView.center.y-closestY, 2)) < ballImageView.frame.size.width){
            if (oneTouchWall) {
                oneTouchWall = false;
                NSLog(@"hit : %f %f %f", sqrt(pow(ballImageView.center.x-closestX, 2)+pow(ballImageView.center.y-closestY, 2)), closestX, closestY);
                counter ++;
                counterLabel.text = [NSString stringWithFormat:@"%d", counter];
                if (checkCircle.center.y == blockImageView.frame.origin.y) {
                    speedY = speedY * -1;
                }
                if (checkCircle.center.x == blockImageView.frame.origin.x || checkCircle.center.x == blockImageView.frame.origin.x+blockImageView.frame.size.width) {
                    speedX = speedX * -1;
                }
            }
        }
    }
	[recorder updateMeters];
	//NSLog(@"Peak input: %f Average input: %f ", [recorder peakPowerForChannel:0], [recorder averagePowerForChannel:0]);
    peakPowerForChannelProgress.progress = (50+[recorder peakPowerForChannel:0])/50;
    averagePowerForChannelProgress.progress = (50+[recorder averagePowerForChannel:0])/50;
    blockImageView.center = CGPointMake((50+[recorder averagePowerForChannel:0])/50*320, blockImageView.center.y);
}


CGFloat DistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy );
};

float closestVal (float val, float min, float max){
    if (val < min) {
        return min;
    }
    else if(val >= min && val <= max){
        return val;
    }
    else{
        return max;
    }
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
