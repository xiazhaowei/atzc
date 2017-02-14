//
//  ChatVoiceSelectionView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-19.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

//开始录音结束录音的代理
@protocol ShareVoiceDelegate <NSObject>

@optional
-(void)beginAudio;
-(void)endAudio;
-(void)cancleAudio;
@end

@interface ChatVoiceSelectionView : UIView


@property (nonatomic,assign) id<ShareVoiceDelegate> delegate;
@property (nonatomic,retain) UIButton *recoredButton;
@end
