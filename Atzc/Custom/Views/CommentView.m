//
//  CommentCell.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

//初始化子视图
-(void)initSubViews
{
    //图片
    _userHeaderImage=[[AtzcUserHeaderView alloc] initWithFrame:CGRectZero];
    [self addSubview:_userHeaderImage];
    
    //评论者姓名
    _username=[[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_username];
    
    //评论内容
    _content=[[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_content];
    
    //发布时间
    _createtime=[[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_createtime];
    
}

-(void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel=commentModel;
    [self layoutSubviews];
}

//布局视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //头像
    _userHeaderImage.frame=CGRectMake(10, 10, 45, 45);
    [_userHeaderImage setHeadImage:self.commentModel.Publicer.Header];
    _userHeaderImage.borderWidth=2;
    
    //姓名
    _username.frame=CGRectMake(_userHeaderImage.right+5,_userHeaderImage.top , (ScreenWidth-_userHeaderImage.width-5-10)/2.0, 15);
    _username.font=[UIFont systemFontOfSize:14];
    _username.text=self.commentModel.Publicer.UserName;
    
    //时间
    _createtime.frame=CGRectMake(_username.right, _username.top, _username.width, _username.height);
    _createtime.text=self.commentModel.CreateTime;
    _createtime.font=[UIFont systemFontOfSize:12];
    _createtime.textColor=[UIColor grayColor];
    
    //内容
    _content.frame=CGRectMake(_username.left, _username.bottom+3, _username.width*2.0, 30);
    _content.text=self.commentModel.Content;
    _content.numberOfLines=3;
    _content.font=[UIFont systemFontOfSize:12];
    _content.textColor=[UIColor grayColor];   
    
    
}



@end
