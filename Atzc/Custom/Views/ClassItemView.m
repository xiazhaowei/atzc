//
//  ClassItemView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-21.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ClassItemView.h"

#define kClassNameFontSize 14
#define kItemHeight 30
#define kTopOffset 3

@implementation ClassItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化类别
        [self initClass];
    }
    return self;
}

//初始化类别
-(void)initClass
{
    classTitle=[[UILabel alloc] init];
    classTitle.font=[UIFont systemFontOfSize:kClassNameFontSize];
    classTitle.backgroundColor=[UIColor clearColor];
    classTitle.textAlignment=NSTextAlignmentCenter;
    //添加点击事件
    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(teleButtonEvent)]autorelease];
    [classTitle addGestureRecognizer:tapGestureTel];
    
    classTitle.userInteractionEnabled=YES;
    
    [self addSubview:classTitle];
}

//点击某个类别
-(void)teleButtonEvent
{
    //如果已经选中，就取消选中
    if (self.classModel.isSelected) {
        
        if ([self.delegate respondsToSelector:@selector(unSelectClass:)]) {
            [self.delegate unSelectClass:self];
        }
    }
    else
    {
        //如果被代理者 能响应事件
        if ([self.delegate respondsToSelector:@selector(selectClass:)]) {
            [self.delegate selectClass:self];
        }
    }
}

//设置类别模型
-(void)setClassModel:(ClassModel *)classModel
{
    _classModel=classModel;
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    classTitle.text=[NSString stringWithFormat:@"%@(%@)",_classModel.ClassName,_classModel.NewsCount];
    if (_classModel.isSelected==YES) {//选中状态
        self.backgroundColor=Color(30, 62, 146, 1);
        classTitle.textColor=[UIColor whiteColor];
    }
    else
    {
        self.backgroundColor=[UIColor clearColor];
        classTitle.textColor=[UIColor blackColor];
    }
    //调整类别文字的大小
    [classTitle sizeToFit];
    classTitle.frame=CGRectMake(classTitle.left, classTitle.top, classTitle.width+10, kItemHeight);
    self.frame=CGRectMake(self.left, self.top+kTopOffset, classTitle.width, kItemHeight);
}

-(void)dealloc
{
    [super dealloc];
    [classTitle release];
    classTitle=nil;    
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
