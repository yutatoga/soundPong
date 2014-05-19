//
//  SecondViewController.m
//  Sound Pong
//
//  Created by SystemTOGA on 8/5/12.
//  Copyright (c) 2012 Yuta Toga. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
@interface SecondViewController ()

@end

@implementation SecondViewController



- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
		
		// message
		CGRect messageLabelFrame = messageLabel.frame;
		messageLabelFrame.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-messageLabel.frame.size.width)/2.0, [UIScreen mainScreen].bounds.size.height*0.02);
		messageLabelFrame.size = messageLabel.frame.size;
		messageLabel.frame = messageLabelFrame;
		
		// score title
		CGRect scoreTitleLabelFrame = scoreTitleLabel.frame;
		scoreTitleLabelFrame.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-scoreTitleLabel.frame.size.width)/2.0, messageLabel.frame.origin.y+messageLabel.frame.size.height+10);
		scoreTitleLabelFrame.size = scoreTitleLabel.frame.size;
		scoreTitleLabel.frame = scoreTitleLabelFrame;
		
		// score
		CGRect scoreLabelFrame = scoreLabel.frame;
		scoreLabelFrame.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-scoreLabel.frame.size.width)/2.0, scoreTitleLabel.frame.origin.y+scoreTitleLabel.frame.size.height+5);
		scoreLabelFrame.size = scoreLabel.frame.size;
		scoreLabel.frame = scoreLabelFrame;
    scoreLabel.text = [NSString stringWithFormat:@"%d", myAppDelegate.hitCounter.intValue];
		
		// loading message
		loadingLabel.numberOfLines = 2;
		loadingLabel.text = @"Loading...";
		loadingLabel.textAlignment = UITextAlignmentCenter;
		CGRect loadingLabelFrame = loadingLabel.frame;
		loadingLabelFrame.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-loadingLabel.frame.size.width)/2.0, ([UIScreen mainScreen].bounds.size.height-loadingLabel.frame.size.height)/2.0);
		loadingLabel.frame = loadingLabelFrame;
		
		// retry button
		CGRect retryButtonFrame = retryButton.frame;
		retryButtonFrame.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-retryButton.frame.size.width)/2.0, [UIScreen mainScreen].bounds.size.height*0.85);
		retryButton.frame = retryButtonFrame;
		
		
		retryButton.hidden = true;
//		retryButton.enabled = false;
//		[retryButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//		[retryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
		
		// image view
		CGRect imageViewFrame = imageView.frame;
		imageViewFrame.size = CGSizeMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*0.5);
		imageViewFrame.origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-imageViewFrame.size.width)/2.0, ([UIScreen mainScreen].bounds.size.height-imageViewFrame.size.height)/2.0+15);
		imageView.frame = imageViewFrame;
		
    [self performSelector:@selector(share) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(playMovie) withObject:nil afterDelay:10.0];;

}


-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)foo{
    NSLog(@"foo");
}

-(void)share{
    NSLog(@"share");
    [self removeFileWithName:@"av.mp4"];
    
    NSString *videoPath = [[NSString alloc] initWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"output.mp4"];
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"av.mp4"];
    
    [self addAudioToFileAtPath:videoPath toPath:outputPath];
}

//ファイル一覧の取得
- (NSArray*)fileNames:(NSString*)fileName {
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	path=[path stringByAppendingPathComponent:fileName];
    //	return [[NSFileManager defaultManager] directoryContentsAtPath:path];
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
}

//ファイル・ディレクトリが存在するか
- (BOOL)existsFileWithName:(NSString*)fileName {
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	path=[path stringByAppendingPathComponent:fileName];
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//ディレクトリの生成
- (void)makeDir:(NSString*)fileName {
    if ([self existsFileWithName:fileName]) return;
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	path=[path stringByAppendingPathComponent:fileName];
    //	[[NSFileManager defaultManager] createDirectoryAtPath:path attributes:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
}

//ファイル・ディレクトリの削除
- (void)removeFileWithName:(NSString*)fileName {
    if (![self existsFileWithName:fileName]) return;
    NSString* path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	path=[path stringByAppendingPathComponent:fileName];
	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

-(void) addAudioToFileAtPath:(NSString *)filePath toPath:(NSString *)outFilePath
{
    NSError * error = nil;
    
    AVMutableComposition * composition = [AVMutableComposition composition];
    
    
    AVURLAsset * videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    
    AVAssetTrack * videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    AVMutableCompositionTrack *compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                preferredTrackID: kCMPersistentTrackID_Invalid];
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,videoAsset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero
                                     error:&error];
    
    //CMTime audioStartTime = kCMTimeZero;
    
    
    NSString *docFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/sound.caf",docFolder];
    
    
    
    
    AVURLAsset * urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:soundFilePath] options:nil];
    
    AVAssetTrack * audioAssetTrack = [[urlAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                preferredTrackID: kCMPersistentTrackID_Invalid];
    
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero,urlAsset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:&error];
    
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetMediumQuality];
    //assetExport.videoComposition = mutableVideoComposition;
    
    assetExport.outputFileType =AVFileTypeQuickTimeMovie;// @"com.apple.quicktime-movie";
    assetExport.outputURL = [NSURL fileURLWithPath:outFilePath];
    
    [assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         switch (assetExport.status)
         {
             case AVAssetExportSessionStatusCompleted:
                 //export complete
                 NSLog(@"Export Complete");
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"Export Failed");
                 NSLog(@"ExportSessionError: %@", [assetExport.error localizedDescription]);
                 //export error (see exportSession.error)
                 break;
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"Export Failed");
                 NSLog(@"ExportSessionError: %@", [assetExport.error localizedDescription]);
                 //export cancelled
                 break;
         }
     }];    
}

-(IBAction)showShareMenu{
		float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (osVersion > 6.0) {
				AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
				NSString *scoreMessage = [NSString stringWithFormat:@"I got score %d in Sound Pong!\nSound Pong\nhttp://yutatoga.com/soundpong", myAppDelegate.hitCounter.intValue];
				NSMutableArray *myActivityItemsArray = [[NSMutableArray alloc] init];
				[myActivityItemsArray addObject:scoreMessage];
				
				
				/*
				 Attach video or audio feature is not available in iOS6 beta. 2012_08_06
				 https://devforums.apple.com/message/682579#682579
				 NSString * file = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"mov"];
				 NSData * video = [NSData dataWithContentsOfFile:file];
				 [myActivityItemsArray addObject:video];
				 
				 NSString *foo = [[NSBundle mainBundle] pathForResource:@"ball" ofType:@"png"];
				 NSData * foobar = [NSData dataWithContentsOfFile:foo];
				 [myActivityItemsArray addObject:foobar];
				 
				 NSString *bar = [[NSBundle mainBundle] pathForResource:@"pong" ofType:@"wav"];
				 NSData * barbar = [NSData dataWithContentsOfFile:bar];
				 [myActivityItemsArray addObject:barbar];
				 */
				
				
				
				
				UIActivityViewController *sharing = [[UIActivityViewController alloc] initWithActivityItems:myActivityItemsArray applicationActivities:nil];
				[self presentViewController:sharing animated:YES completion:nil];
		}
}

-(IBAction)playMovie{
    
    /*
    NSString *moviePath = [[NSString alloc] initWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"av.mp4"];
    NSURL *movieURL = [NSURL URLWithString:moviePath];
    
    NSString * file = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"mov"];
    NSURL *foo  = [NSURL URLWithString:file];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:foo];
    [player.view setFrame:imageView.bounds];
    [imageView addSubview:player.view];
    [player play];
    */
    
    NSLog(@"playMovie");
    
    
    NSString *moviePath = [[NSString alloc] initWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"av.mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    
    
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    if (setCategoryError) {
        NSLog(@"error");
    }
    
    player = [[MPMoviePlayerController alloc] initWithContentURL: movieURL];
    [player prepareToPlay];
    [player.view setFrame:imageView.bounds];  // player's frame must match parent's
    [imageView addSubview: player.view];
    [player setControlStyle:MPMovieControlStyleNone];
    [player play];
		[self performSelector:@selector(shwoRetryButton) withObject:nil afterDelay:1];
}

- (void)shwoRetryButton{
		retryButton.hidden = false;
}

@end
