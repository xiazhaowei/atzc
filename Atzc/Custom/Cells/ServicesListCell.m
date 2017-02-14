//
//  ServicesListCell.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ServicesListCell.h"

@implementation ServicesListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        [self initSubViews];
    }
    return self;
}
//初始化子视图
-(void)initSubViews
{
    //图片
    _imgView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_imgView];
    //标题
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.textColor=Color(156, 156, 156, 1);
    _titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
}

//更改布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //_imgView.frame=CGRectMake(20, 14, 25, 20);
    _imgView.image=[UIImage imageNamed:self.Img];
    
    _titleLabel.frame=CGRectMake(_imgView.right+10, 10, 150, 30);
    _titleLabel.text=self.Title;    
    
}
//设置选中
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //选中的背景视图
    UIView *selectbgView= [[[UIView alloc] initWithFrame:self.frame] autorelease];
    //左侧的颜色指示视图
    UIView *leftcolortip=[[UIView alloc] initWithFrame:CGRectMake(0, 1, 3, selectbgView.height-2)];
    leftcolortip.backgroundColor=Color(67, 193, 149, 1);
    [selectbgView addSubview:leftcolortip];
    [leftcolortip release];
    self.selectedBackgroundView = selectbgView;
    self.selectedBackgroundView.backgroundColor = Color(20, 20, 20, 1);
    // Configure the view for the selected state
}
-(void)dealloc
{
    [super dealloc];
    [_imgView release];_imgView=nil;
    [_titleLabel release];_titleLabel=nil;
}

@end
