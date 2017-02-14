//
//  ScrollClassesView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-21.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ScrollClassesView.h"
#import "ClassItemView.h"

#import "CsInfoClsView.h"

#define kClassNameFontSize 14
#define kClassLineHeight 40

@implementation ScrollClassesView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    //隐藏滚动条 裁剪区域
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setClipsToBounds:YES];//设置内容区域
    
    //配置scrollview
    [_scrollView setBounces:YES];
    [_scrollView setBouncesZoom:NO];//不放大缩小
    //_scrollView.delegate = self;//设置代理
    
    [self addSubview:_scrollView];
    
    self.clipsToBounds = YES;   
}

-(void)setClassModel:(ClassModel *)classModel
{
    _classModel=classModel;
    
    float contentHeight = self.bounds.size.height;
    
    UILabel *classNameLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    classNameLabel.font=[UIFont systemFontOfSize:kClassNameFontSize];
    classNameLabel.text=[NSString stringWithFormat:@"按%@分：",_classModel.ClassName];
    [classNameLabel sizeToFit];
    classNameLabel.frame=CGRectMake(classNameLabel.left+5, classNameLabel.top, classNameLabel.width, kClassLineHeight);
    
    [_scrollView addSubview:classNameLabel];
    [classNameLabel release];
    
    //如果包含子类别属性
    if(_classModel.SubClasses!=nil&&_classModel.SubClasses.count>0)
    {
        //创建他的所有子ClassItemView
        int offsetleft=classNameLabel.width;
        for (ClassModel *subClassAttribute in _classModel.SubClasses){
            
            ClassItemView *classItemView=[[ClassItemView alloc] init];
            classItemView.classModel=subClassAttribute;       
            classItemView.frame=CGRectMake(offsetleft, classItemView.top, classItemView.width, kClassLineHeight);
            classItemView.delegate=(CsInfoClsView *)[self superview];
            
            offsetleft += classItemView.width;        
            
            [_scrollView addSubview:classItemView];
            [classItemView release];
        }
        _scrollView.contentSize = CGSizeMake(offsetleft, contentHeight);
    }
    
}


-(void)dealloc
{
    [super dealloc];
    [_classModel release];
    _classModel=nil;
    [_scrollView release];
    _scrollView=nil;
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
