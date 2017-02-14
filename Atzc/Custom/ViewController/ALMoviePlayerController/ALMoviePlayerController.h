//
//  ALMoviePlayerController.h
//  ALMoviePlayerController
//
//  Created by Anthony Lobianco on 10/8/13.
//  Copyright (c) 2013 Anthony Lobianco. All rights reserved.
//

#import <MediaPlayer/MPMoviePlayerController.h>
#import "ALMoviePlayerControls.h"

static NSString * const ALMoviePlayerContentURLDidChangeNotification = @"ALMoviePlayerContentURLDidChangeNotification";


@protocol ALMoviePlayerControllerDelegate <NSObject>
@optional
- (void)movieTimedOut;//视频播放完毕
@required
- (void)moviePlayerWillMoveFromWindow;//从窗口关闭播放器
@end

@interface ALMoviePlayerController : MPMoviePlayerController

- (void)setFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<ALMoviePlayerControllerDelegate> delegate;
@property (nonatomic, strong) ALMoviePlayerControls *controls;

@end
