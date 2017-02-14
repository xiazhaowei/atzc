//
//  ChatVoiceSelectionView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-19.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ChatVoiceSelectionView.h"
#import "UIView+Animation.h"

#define kCancelOriginY          ([[UIScreen mainScreen]bounds].size.height-70)
#define RECORD_BUTTON_SIZE 100

@implementation ChatVoiceSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //写死面板的高度
        [self setBackgroundColor:Color(233, 233, 233, 1)];
        
        // 初始化代码
        //录音按钮
        _recoredButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_recoredButton setFrame:CGRectMake(ScreenWidth/2-RECORD_BUTTON_SIZE/2, 180/2-RECORD_BUTTON_SIZE/2, RECORD_BUTTON_SIZE , RECORD_BUTTON_SIZE)];
        [_recoredButton setImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
        
        _recoredButton.backgroundColor=[UIColor greenColor];
        
        [_recoredButton addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchDown];
        [_recoredButton addTarget:self action:@selector(btnUp) forControlEvents:UIControlEventTouchUpInside];
        [_recoredButton addTarget:self action:@selector(btnDragUp) forControlEvents:UIControlEventTouchDragExit];
        
        [self addSubview:_recoredButton];
    }
    return self;
}
//录音按钮按下
-(void)btnDown
{
    NSLog(@"按钮按下");
    //[_delegate beginAudio];
}

//录音按钮松开
-(void)btnUp
{
    NSLog(@"按钮松开");
    //[_delegate endAudio];
}

//录音按钮上划取消
-(void)btnDragUp
{
    NSLog(@"按钮取消");
    //[_delegate cancleAudio];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
