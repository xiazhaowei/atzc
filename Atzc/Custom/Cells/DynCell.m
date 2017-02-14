//
//  DynCell.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-4.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "DynCell.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation DynCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.headerViewSize=CGSizeMake(50, 50);
    }
    return self;
}

//初始化视图
-(void)initSubViews
{
    //头像
    UIImage *myimage=[UIImage imageNamed:@"default_userheader"];
    _headerView=[[AtzcUserHeaderView alloc] initWithImage:myimage];
    _headerView.frame=CGRectZero;
    _headerView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_headerView];
    
    //姓名
    _userNameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _userNameLabel.backgroundColor=[UIColor clearColor];
    _userNameLabel.textColor=Color(234, 234, 234, 1);
    _userNameLabel.font=[UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:_userNameLabel];
    
    //标题
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.textColor=Color(105, 105, 105, 1);
    _titleLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_titleLabel];
    
    //发布时间
    _timeLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.backgroundColor=[UIColor clearColor];
    _timeLabel.textColor=Color(105, 105, 105, 1);
    _timeLabel.font=[UIFont systemFontOfSize:10];
    _timeLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:_timeLabel];
    
    //内容
    _contentLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.backgroundColor=[UIColor clearColor];
    _contentLabel.textColor=Color(105, 105, 105, 1);
    _contentLabel.numberOfLines=0;
    _contentLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:_contentLabel];
    
    //评论按钮
    _commentBtn=[[UIButton alloc] initWithFrame:CGRectZero];
    _commentBtn = [UIFactory createButton:@"dyncommenticon.png" highlighted:@"dyncommenticon.png"];    
    
    [_commentBtn addTarget:self action:@selector(showKB:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_commentBtn];
}

//布局视图
-(void)layoutSubviews
{
    [super layoutSubviews];
    //头像
    [_headerView setHeadImage:self.dynModel.Publicer.Header];
    _headerView.frame=CGRectMake(5, 5, self.headerViewSize.width, self.headerViewSize.height);
    //用户名
    _userNameLabel.frame=CGRectMake(_headerView.right+5, _headerView.top, (ScreenWidth-_headerView.right-5)*0.6, 15);
    _userNameLabel.font=[UIFont boldSystemFontOfSize:15];
    _userNameLabel.textColor=Color(41, 51, 93, 1);
    //动态时间
    _timeLabel.frame=CGRectMake(_userNameLabel.right, _userNameLabel.top+4, (ScreenWidth-_headerView.right-5)*0.4, 10);
    
    //标题
    _titleLabel.frame=CGRectMake(_userNameLabel.left, _userNameLabel.bottom+5, ScreenWidth-_headerView.right-5, 12);
    //内容
    _contentLabel.frame=CGRectMake(_titleLabel.left, _titleLabel.bottom+5, ScreenWidth-_headerView.right-5, 12);
    [_contentLabel sizeToFit];
    
    //布局图片
    [self layoutPics];
    //用户评论
    [self layoutComments];
    
    //评论按钮
    _commentBtn.frame=CGRectMake(ScreenWidth-55, _contentLabel.bottom+5, 50, 18);
}

//布局图片
-(void)layoutPics
{
    //图片  根据图片数量确定尺寸
    int picwidth=0, picheight=0;
    
    for (int i=1;i<_dynModel.Pics.count+1;i++) {
        
        UIImageView *picView=[[UIImageView alloc] initWithFrame:CGRectMake(_userNameLabel.left+picwidth, _contentLabel.bottom+5+picheight, 58, 58)];
        [picView setImageWithURL:[NSURL URLWithString:_dynModel.Pics[i-1]]];
        picView.tag=i-1;
        picView.userInteractionEnabled=YES;
        //添加点击事件
        UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgCkick:)]autorelease];
        [picView addGestureRecognizer:tapGestureTel];
        
        [self.contentView addSubview:picView];
        [picView release];
        if(i%4==0)//4个一行 到一行高度增加 宽度还原
        {
            picwidth=0;
            picheight+=63;
        }
        else
        {
            picwidth+=63;//不到三个宽度增加
        }
    }

}
//布局用户评论
-(void)layoutComments
{
    for (CommentModel *commentModel in _dynModel.Comments) {
        UILabel *commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(_contentLabel.left, _contentLabel.bottom, ScreenWidth-_headerView.right-5, 25)];
        commentLabel.text=[NSString stringWithFormat:@"%@:%@",commentModel.Publicer.UserName,commentModel.Content];
        commentLabel.font=[UIFont systemFontOfSize:11];
        commentLabel.backgroundColor=Color(240, 240, 240, 1);
        [self.contentView addSubview:commentLabel];
        [commentLabel release];
    }
}

//设置数据
-(void)setDynModel:(DynModel *)dynModel
{
    _dynModel=dynModel;
    _userNameLabel.text=_dynModel.Publicer.UserName;
    _titleLabel.text=_dynModel.Title;
    _timeLabel.text=_dynModel.PostTime;
    _contentLabel.text=_dynModel.Content;
}
-(void)setHeaderViewSize:(CGSize)headerViewSize
{
    _headerViewSize=headerViewSize;
    [self layoutSubviews];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)imgCkick:(UIImageView *)imgView
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_dynModel.Pics.count];    
    for (int i = 0; i<_dynModel.Pics.count; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_dynModel.Pics[i]]; // 图片路径
        //photo.srcImageView = imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos;
    [browser show];
    [photos release];
}


#pragma mark selfDelegate method
//发送按钮
-(void)showKB:(UIButton*)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showkeyboard:)]) {
        //弹出键盘
        [self.delegate showkeyboard:self.dynModel];
    }
}

-(void)dealloc
{
    [super dealloc];
    [_headerView release];_headerView=nil;
    [_userNameLabel release];_userNameLabel=nil;
    [_titleLabel release];_titleLabel=nil;
    [_timeLabel release];_timeLabel=nil;
    [_contentLabel release];_contentLabel=nil;
    [_commentBtn release];_commentBtn=nil;
}

@end
