//
//  PhotoCell.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-6.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "PhotoCell.h"
#import "UIImageView+WebCache.h"

@implementation PhotoCell
@synthesize imgView;

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
    _imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _imgView.image=[UIImage imageNamed:@"page_image_loading"];
    [self.contentView addSubview:_imgView];
}

-(void)setPhotoModel:(PhotoModel *)photoModel
{
    _photoModel=photoModel;
    [_imgView setImageWithURL:[NSURL URLWithString:photoModel.PhotoPath]];
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
    [_imgView release];_imgView=nil;
}

@end
