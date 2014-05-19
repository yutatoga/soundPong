//
//  SecondViewController.h
//  Sound Pong
//
//  Created by SystemTOGA on 8/5/12.
//  Copyright (c) 2012 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface SecondViewController : UIViewController<UINavigationControllerDelegate, UIActionSheetDelegate>{
    IBOutlet UILabel *scoreLabel;
		IBOutlet UILabel *messageLabel;
		IBOutlet UILabel *scoreTitleLabel;
		IBOutlet UILabel *loadingLabel;
    IBOutlet UIImageView *imageView;
		IBOutlet UIButton *retryButton;
    MPMoviePlayerController *player;
}

@end
