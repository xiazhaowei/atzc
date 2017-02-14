//
//  FriendDynView.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-4.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "FriendDynView.h"

#define marginTop 130

@implementation FriendDynView
@synthesize dataSource,itemSelectedDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews
{
    //[self setShowsVerticalScrollIndicator:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    
    //顶部心情 相册 日志
    topNavView=[[UIView alloc] initWithFrame:CGRectMake(0, marginTop, ScreenWidth, 50)];
    topNavView.backgroundColor=[UIColor whiteColor];
    [self addSubview:topNavView];
    
    
    UILabel *miniblogTitle=[[UILabel alloc] initWithFrame:CGRectMake(70, 6, 54, 13)];
    miniblogTitle.text=@"说说";
    miniblogTitle.textAlignment=NSTextAlignmentCenter;
    miniblogTitle.font=[UIFont boldSystemFontOfSize:13];
    [topNavView addSubview:miniblogTitle];
    [miniblogTitle release];
    UILabel *miniblogCount=[[UILabel alloc] initWithFrame:CGRectMake(miniblogTitle.left, miniblogTitle.bottom,miniblogTitle.width , miniblogTitle.height)];
    miniblogCount.text=@"142";
    miniblogCount.textAlignment=NSTextAlignmentCenter;
    miniblogCount.font=[UIFont systemFontOfSize:12];
    [topNavView addSubview:miniblogCount];
    [miniblogCount release];
    
    UILabel *blogTitle=[[UILabel alloc] initWithFrame:CGRectMake(miniblogTitle.right, miniblogTitle.top, miniblogTitle.width, miniblogTitle.height)];
    blogTitle.text=@"日志";
    blogTitle.textAlignment=NSTextAlignmentCenter;
    blogTitle.font=[UIFont boldSystemFontOfSize:13];
    [topNavView addSubview:blogTitle];
    [blogTitle release];
    UILabel *blogCount=[[UILabel alloc] initWithFrame:CGRectMake(blogTitle.left, blogTitle.bottom,blogTitle.width , blogTitle.height)];
    blogCount.text=@"482";
    blogCount.textAlignment=NSTextAlignmentCenter;
    blogCount.font=[UIFont systemFontOfSize:12];
    [topNavView addSubview:blogCount];
    [blogCount release];
    
    UILabel *albumTitle=[[UILabel alloc] initWithFrame:CGRectMake(blogTitle.right, blogTitle.top, blogTitle.width, blogTitle.height)];
    albumTitle.text=@"相册";
    albumTitle.textAlignment=NSTextAlignmentCenter;
    albumTitle.font=[UIFont boldSystemFontOfSize:13];
    [topNavView addSubview:albumTitle];
    [albumTitle release];
    UILabel *albumCount=[[UILabel alloc] initWithFrame:CGRectMake(albumTitle.left, albumTitle.bottom,albumTitle.width , albumTitle.height)];
    albumCount.text=@"315";
    albumCount.textAlignment=NSTextAlignmentCenter;
    albumCount.font=[UIFont systemFontOfSize:12];
    [topNavView addSubview:albumCount];
    [albumCount release];
    
    UILabel *shoppingshareTitle=[[UILabel alloc] initWithFrame:CGRectMake(albumTitle.right, albumTitle.top, albumTitle.width+20, albumTitle.height)];
    shoppingshareTitle.text=@"消费分享";
    shoppingshareTitle.textAlignment=NSTextAlignmentCenter;
    shoppingshareTitle.font=[UIFont boldSystemFontOfSize:13];
    [topNavView addSubview:shoppingshareTitle];
    [shoppingshareTitle release];
    UILabel *shoppingshareCount=[[UILabel alloc] initWithFrame:CGRectMake(shoppingshareTitle.left, shoppingshareTitle.bottom,shoppingshareTitle.width , shoppingshareTitle.height)];
    shoppingshareCount.text=@"1452";
    shoppingshareCount.textAlignment=NSTextAlignmentCenter;
    shoppingshareCount.font=[UIFont systemFontOfSize:12];
    [topNavView addSubview:shoppingshareCount];
    [shoppingshareCount release];
    //头像
    userHeaderView=[[AtzcUserHeaderView alloc] initWithFrame:CGRectMake(10, topNavView.top-30, 60, 60)];
    [[userHeaderView layer] setShadowOffset:CGSizeMake(0, 1)];//头像阴影
    [[userHeaderView layer] setShadowRadius:1.0];
    [[userHeaderView layer] setShadowOpacity:0.5];
    [self addSubview:userHeaderView];
    
    
    //信息
    friendNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(userHeaderView.right+14, userHeaderView.top+10, 50, 20)];
    friendNameLabel.font=[UIFont boldSystemFontOfSize:14];
    friendNameLabel.textColor=[UIColor whiteColor];
    [self addSubview:friendNameLabel];
    [friendNameLabel release];
    
    friendInfoLabel=[[UILabel alloc] initWithFrame:CGRectMake(friendNameLabel.right, friendNameLabel.top, 150, 20)];
    friendInfoLabel.font=[UIFont systemFontOfSize:12];
    friendInfoLabel.textColor=[UIColor whiteColor];
    [self addSubview:friendInfoLabel];
    
    
    [self reloadData];
}

-(void)setUserFriendModel:(UserModel *)userFriendModel
{
    _userFriendModel=userFriendModel;
    
    [userHeaderView setHeadImage:self.userFriendModel.Header];
    friendNameLabel.text=self.userFriendModel.UserName;
    friendInfoLabel.text=@"男 27岁 市里 朝阳花园";
}

//加载数据
-(void) reloadData
{
    //通过代理获得数量
    self.itemCount = [dataSource numberOfItemsForDyn:self];
    
    
    int dynitemheight=0;
    //创建指定数量的动态项目
    for(int i = 0 ; i < self.itemCount; i ++)
    {
        UITableViewCell *cell=[dataSource dynView:self itemForRow:i];
        cell.frame=CGRectMake(0, topNavView.bottom+dynitemheight, ScreenWidth, [dataSource dynView:self heightForRow:i]);
        [self addSubview:cell];
        dynitemheight+=[dataSource dynView:self heightForRow:i];
        [cell release];
    }
    self.contentSize = CGSizeMake(ScreenWidth, dynitemheight+topNavView.bottom);
    
    [self layoutSubviews];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
    [topNavView release];topNavView=nil;
    [userHeaderView release];userHeaderView=nil;
    [friendNameLabel release];friendNameLabel=nil;
    [friendInfoLabel release];friendInfoLabel=nil;
}
@end
