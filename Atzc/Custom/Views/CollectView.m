//
//  CollectView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-26.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CollectView.h"

@implementation CollectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化子视图
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    _msgicon=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    _msgicon.image=[UIImage imageNamed:@"collecticon"];
    _msgicon.userInteractionEnabled=YES;
    
    //添加点击事件
    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CollectMessage)]autorelease];
    [_msgicon addGestureRecognizer:tapGestureTel];
    [self addSubview:_msgicon];
    
    _phone=[[UILabel alloc] initWithFrame:CGRectMake(_msgicon.left, _msgicon.bottom, _msgicon.width, 10)];
    _phone.font=[UIFont systemFontOfSize:10];
    _phone.text=@"收藏";
    _phone.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_phone];
}
//收藏信息
-(void)CollectMessage{
    
    if ([self.delegate respondsToSelector:@selector(CollectMessage)]) {
        [self.delegate CollectMessage];
    }
    
}
-(void)dealloc
{
    [super dealloc];
    
    [_phone release];_phone=nil;
    [_msgicon release];_msgicon=nil;
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
