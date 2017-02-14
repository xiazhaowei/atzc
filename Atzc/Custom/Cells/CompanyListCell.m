//
//  CompanyListCell.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CompanyListCell.h"

@implementation CompanyListCell

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
       
    
    //发布时间
    _createtime=[[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_createtime];
    
}

-(void)setCompanyModel:(CompanyModel *)companyModel
{
    _companyModel=companyModel;
    [self layoutSubviews];
}

//布局视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //图片
    _pic.frame=CGRectMake(10, 10, 80, 60);
    [_pic setImageWithURL:[NSURL URLWithString:self.companyModel.Logo]];
    
    
    //标题
    _title.frame=CGRectMake(_pic.right+5,_pic.top , ScreenWidth-_pic.width-5-10, 15);
    _title.font=[UIFont systemFontOfSize:14];
    _title.text=self.companyModel.Title;
    
    //内容
    _content.frame=CGRectMake(_title.left, _title.bottom+3, _title.width, 14);
    _content.text=self.companyModel.Description;
    _content.font=[UIFont systemFontOfSize:12];
    _content.textColor=[UIColor grayColor];
  
    
    //时间
    _createtime.frame=CGRectMake(_title.left, _content.bottom, _title.width, _title.height);
    _createtime.text=self.companyModel.CreateTime;
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
    [_createtime release]; _createtime=nil;
}

@end
