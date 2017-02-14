//
//  MeServiceView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "MeServiceView.h"

@implementation MeServiceView

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
    _icon=[[UIImageView alloc] initWithFrame:CGRectMake(self.width/2.0-50/2.0, 5, 50, 45)];
    
    [self addSubview:_icon];
    
    _title=[[UILabel alloc] initWithFrame:CGRectMake(0, _icon.bottom, self.width, 12)];
    _title.font=[UIFont systemFontOfSize:11];
    _title.textAlignment=NSTextAlignmentCenter;
    _title.text=@"在诸城服务";
    [self addSubview:_title];
}

-(void)setStricon:(NSString *)stricon
{
    _icon.image=[UIImage imageNamed:stricon];
}

-(void)setStrtitle:(NSString *)strtitle
{
    _title.text=strtitle;
}


-(void)dealloc
{
    [super dealloc];
    [_icon release];_icon=nil;
    [_title release];_title=nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
