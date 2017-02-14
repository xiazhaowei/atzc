//
//  AlbumCell.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-6.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

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
    
    albumTitle=[[UILabel alloc] initWithFrame:CGRectMake(img.left, img.bottom-20, img.width, 20)];
    albumTitle.backgroundColor=Color(0, 0, 0, 0.6);
    albumTitle.font=[UIFont systemFontOfSize:11];
    albumTitle.textAlignment=NSTextAlignmentCenter;
    albumTitle.textColor=[UIColor whiteColor];
    [self.contentView addSubview:albumTitle];
}

-(void)setAlbumModel:(AlbumModel *)albumModel
{
    _albumModel=albumModel;
    
    [img setImageWithURL:[NSURL URLWithString:albumModel.Conver]];
    albumTitle.text=albumModel.Title;
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
    [albumTitle release];albumTitle=nil;
}
@end
