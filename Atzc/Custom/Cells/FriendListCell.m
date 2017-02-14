//
//  FriendListCell.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化视图
        [self initSubViews];
    }
    return self;
}


#pragma mark 私有方法
//初始化视图
-(void)initSubViews
{
    //头像
    _headerView=[[AtzcUserHeaderView alloc] init];
    _headerView.frame=CGRectZero;
    _headerView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_headerView];
    //姓名
    _userNameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _userNameLabel.backgroundColor=[UIColor clearColor];
    _userNameLabel.textColor=Color(234, 234, 234, 1);
    _userNameLabel.font=[UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:_userNameLabel];
    //最新说说
    _latestMoodLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _latestMoodLabel.backgroundColor=[UIColor clearColor];
    _latestMoodLabel.textColor=Color(105, 105, 105, 1);
    _latestMoodLabel.font=[UIFont boldSystemFontOfSize:11];
    [self.contentView addSubview:_latestMoodLabel];
}

-(void)setUserModel:(UserModel *)userModel
{
    _userModel=userModel;
    [self layoutSubviews];
}
//更改布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置头像图片
    NSString *imgURL= self.userModel.Header;
    [_headerView setHeadImage:imgURL];
    _headerView.frame=CGRectMake(12, 5, 40, 40);
    _headerView.borderWidth=1;
    
    _userNameLabel.frame=CGRectMake(_headerView.right+8, 5, 180, 25);
    _userNameLabel.text=self.userModel.UserName;
    
    _latestMoodLabel.frame=CGRectMake(_headerView.right+8, _userNameLabel.bottom, 180, 10);
    _latestMoodLabel.text=self.userModel.LatestMood;    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



-(void)dealloc
{
    [super dealloc];
    [_userModel release]; _userModel=nil;
    [_headerView release];_headerView=nil;
    [_userNameLabel release];_userNameLabel=nil;
    [_latestMoodLabel release];_latestMoodLabel=nil;
}

@end
