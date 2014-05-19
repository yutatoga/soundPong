//
//  AppDelegate.h
//  Sound Pong
//
//  Created by SystemTOGA on 8/3/12.
//  Copyright (c) 2012 Yuta Toga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSNumber *hitCounter;
    BOOL writingMovieDone;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSNumber *hitCounter;
@property (nonatomic, assign) BOOL writingMovieDone;
@end
