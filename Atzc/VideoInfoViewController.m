//
//  VideoInfoViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-7.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "VideoInfoViewController.h"
#import "ALMoviePlayerController.h"

@interface VideoInfoViewController ()<ALMoviePlayerControllerDelegate>


@end

@implementation VideoInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"视频详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initSubViews];
}

-(void)initSubViews
{
    //创建播放器
    moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,200)];
    moviePlayer.view.alpha = 0.0f;
    moviePlayer.delegate = self;
    
    //创建操作面板
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:moviePlayer style:ALMoviePlayerControlsStyleDefault];
    //[movieControls setAdjustsFullscreenImage:NO];
    [movieControls setBarColor:Color(100, 100, 100, 0.5)];
    movieControls.barHeight=28.0f;
    [movieControls setTimeRemainingDecrements:YES];
    
    //呈现播放器
    [moviePlayer setControls:movieControls];
    [self.view addSubview:moviePlayer.view];
    
    //视频地址
    [moviePlayer setContentURL:[NSURL URLWithString:@"http://img.atzc.net/uploads/video/vid_20131030_115443_13110556.mp4"]];
    
    //delay initial load so statusBarOrientation returns correct value
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self configureViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            moviePlayer.view.alpha = 1.f;
        } completion:nil];
    });
}

//IMPORTANT!
- (void)moviePlayerWillMoveFromWindow {
    //退出全部模式，播放器重新加到视图上
    if (![self.view.subviews containsObject:moviePlayer.view])
        [self.view addSubview:moviePlayer.view];
    
    [moviePlayer setFrame:self.defaultFrame];
}

//配置视图 通过方向
- (void)configureViewForOrientation:(UIInterfaceOrientation)orientation {
    CGFloat videoWidth = 0;
    CGFloat videoHeight = 0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {//横屏时
        videoWidth = 700.f;
        videoHeight = 535.f;
    } else {
        videoWidth = self.view.frame.size.width;
        videoHeight = 268.f;
    }

    self.defaultFrame=CGRectMake(0, 0, videoWidth,videoHeight);
    
    //只有管理电影播放帧时，它不是在全屏。当在全屏模式，该帧被自动管理
    if (moviePlayer.isFullscreen)
        return;
    
    [moviePlayer setFrame:self.defaultFrame];
}

//视频播放完毕
- (void)movieTimedOut {
    NSLog(@"MOVIE TIMED OUT");
}

//屏幕旋转
- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self configureViewForOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    
    [moviePlayer release];moviePlayer=nil;
}

@end
