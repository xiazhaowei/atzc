//
//  NewsCell.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-26.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化子视图
        [self initSubViews];
    }
    return self;
}


//初始化子视图
-(void)initSubViews
{
    //图片
    _pic=[[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_pic];
    
    //标题
    _title=[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_title];
    
    //内容
    _content=[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_content];
    
    //价格
    _comments=[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_comments];
    
    //发布时间
    _createtime=[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_createtime];
    
}

-(void)setNewsInfoModel:(NewsInfoModel *)newsInfoModel
{
    _newsInfoModel=newsInfoModel;
    [self layoutSubviews];
}

//布局视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //图片
    _pic.frame=CGRectMake(10, 10, 80, 60);
    [_pic setImageWithURL:[NSURL URLWithString:self.newsInfoModel.Pic]];
    
    
    //标题
    _title.frame=CGRectMake(_pic.right+5,_pic.top , ScreenWidth-_pic.width-5-10, 15);
    _title.font=[UIFont systemFontOfSize:14];
    _title.text=self.newsInfoModel.Title;
    
    //内容
    _content.frame=CGRectMake(_title.left, _title.bottom+3, _title.width, 14);
    _content.text=self.newsInfoModel.Content;
    _content.font=[UIFont systemFontOfSize:12];
    _content.textColor=[UIColor grayColor];
    
    //价格
    _comments.frame=CGRectMake(_content.left, _content.bottom, 75, 30);
    _comments.text=[NSString stringWithFormat:@"评论数：%i",self.newsInfoModel.Comments];
    _comments.font=[UIFont boldSystemFontOfSize:14];
    _comments.textColor=[UIColor orangeColor];
    
    //时间
    _createtime.frame=CGRectMake(_comments.right, _comments.top, _comments.width, _comments.height);
    _createtime.text=self.newsInfoModel.CreateTime;
    _createtime.font=[UIFont systemFontOfSize:12];
    _createtime.textColor=[UIColor grayColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [super dealloc];
    [_pic release];  _pic=nil;
    [_title release]; _title=nil;
    [_content release]; _content=nil;
    [_comments release]; _comments=nil;
    [_createtime release]; _createtime=nil;
}

@end
