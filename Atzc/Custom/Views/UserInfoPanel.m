//
//  UserInfoPanel.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "UserInfoPanel.h"

@implementation UserInfoPanel


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.clipsToBounds=YES;
    }
    return self;
}

-(void)initSubViews
{
    userHead=[[AtzcUserHeaderView alloc] initWithFrame:CGRectZero];
    [self addSubview:userHead];
    
    userName=[[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:userName];
    
    userMobile=[[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:userMobile];
}

-(void)setUserModel:(UserModel *)userModel
{
    _userModel=userModel;
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    userHead.frame=CGRectMake(5, 5, 30, 30);
    [userHead setHeadImage:self.userModel.Header];
    userHead.borderWidth=1.0f;
    
    userName.frame=CGRectMake(userHead.right+5, 5, 100, 15);
    userName.font=[UIFont boldSystemFontOfSize:12];
    userName.text=self.userModel.UserName;
    
    userMobile.frame=CGRectMake(userName.left, userName.bottom, userName.width, 15);
    userMobile.text=self.userModel.UserAccount;
    userMobile.font=[UIFont systemFontOfSize:12];
    userMobile.textColor=[UIColor grayColor];
}

-(void)dealloc
{
    [super dealloc];
    [_userModel release];_userModel=nil;
    [userHead release];userHead=nil;
    [userName release];userName=nil;
    [userMobile release];userMobile=nil;
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
