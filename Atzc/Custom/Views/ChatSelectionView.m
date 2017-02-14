//
//  ChatSelectionView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ChatSelectionView.h"

#define CHAT_BUTTON_SIZE 80
#define INSETS 0

@implementation ChatSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //写死面板的高度
        [self setBackgroundColor:Color(233, 233, 233, 1)];
        
        // 初始化代码
        //图片
        _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_photoButton setImage:[UIImage imageNamed:@"sharemore_pic"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(pickPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoButton];
        //拍照
        _cameraButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraButton setFrame:CGRectMake(_photoButton.right+ INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_cameraButton setImage:[UIImage imageNamed:@"sharemore_video"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(pickPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraButton];
        
        //位置
        _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setFrame:CGRectMake(_cameraButton.right+ INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_locationButton setImage:[UIImage imageNamed:@"sharemore_location"] forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(pickPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locationButton];
        
        //名片
        _vcardButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_vcardButton setFrame:CGRectMake(_locationButton.right+ INSETS, INSETS, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_vcardButton setImage:[UIImage imageNamed:@"sharemore_friendcard"] forState:UIControlStateNormal];
        [_vcardButton addTarget:self action:@selector(pickPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_vcardButton];
        
    }
    return self;
}

-(void)pickPhoto
{
    [_delegate pickPhoto];
}

//-(UIImage *)imageDidFinishPicking
//{
//
//}
//-(UIImage *)cameraDidFinishPicking
//{
//
//}
//-(CLLocation *)locationDidFinishPicking
//{
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
