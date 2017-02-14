//
//  VideoCell.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-7.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

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
    img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    img.image=[UIImage imageNamed:@"page_image_loading"];
    [self.contentView addSubview:img];
    
    Title=[[UILabel alloc] initWithFrame:CGRectMake(img.left, img.bottom-20, img.width, 20)];
    Title.backgroundColor=Color(0, 0, 0, 0.6);
    Title.font=[UIFont systemFontOfSize:11];
    Title.textAlignment=NSTextAlignmentCenter;
    Title.textColor=[UIColor whiteColor];
    [self.contentView addSubview:Title];
}

-(void)setVideoModel:(VideoModel *)videoModel
{
    _videoModel=videoModel;
    
    [img setImageWithURL:[NSURL URLWithString:videoModel.Pic]];
    Title.text=videoModel.Title;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)dealloc
{
    [super dealloc];
    [img release];img=nil;
    [Title release];Title=nil;
}

@end
