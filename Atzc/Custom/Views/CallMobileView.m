//
//  CallMobileView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CallMobileView.h"

@implementation CallMobileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化视图
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    _phoneicon=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    _phoneicon.image=[UIImage imageNamed:@"mobile"];
    _phoneicon.userInteractionEnabled=YES;
    
    //添加点击事件
    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CallPhone)]autorelease];
    [_phoneicon addGestureRecognizer:tapGestureTel];
    
    [self addSubview:_phoneicon];
    
    _phone=[[UILabel alloc] initWithFrame:CGRectMake(_phoneicon.left, _phoneicon.bottom, _phoneicon.width, 10)];
    _phone.font=[UIFont systemFontOfSize:10];
    _phone.text=@"电话";
    _phone.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_phone];
}

//打电话
-(void)CallPhone{
//    NSString *phoneNum = self.mobile;// 电话号码
//    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
//    
//    if (phoneCallWebView==nil ) {
//        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
//    }
//    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}

-(void)dealloc
{
    [super dealloc];
    
    [_phone release];_phone=nil;
    [_phoneicon release];_phoneicon=nil;
    [phoneCallWebView release];phoneCallWebView=nil;
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
