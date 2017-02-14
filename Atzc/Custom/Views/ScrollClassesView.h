//
//  ScrollClassesView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-21.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassModel;
@interface ScrollClassesView : UIView
{
    ClassModel *_classModel;
}

@property (strong, nonatomic) UIScrollView *scrollView;//滚动视图
@property (nonatomic,retain) ClassModel *classModel;
@end
