//
//  ChatFaceSelectionView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-19.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ChatFaceSelectionView.h"

@implementation ChatFaceSelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //写死面板的高度
        [self setBackgroundColor:Color(233, 233, 233, 1)];
        
    }
    return self;
}

-(void)pickFace
{
    [_delegate pickFace];
}

@end
