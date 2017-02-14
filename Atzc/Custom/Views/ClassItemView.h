//
//  ClassItemView.h
//  Atzc  某个类别项目
//
//  Created by 夏兆伟 on 13-12-21.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum kClassItemType {
    kClassItemTypeClass = 0,
    kClassItemTypeClassAttribute = 1,
    kClassItemTypeAttribute=2
}kClassItemType;

//类别点击的代理
@class ClassItemView;
@protocol ClassItemViewDelegate <NSObject>

@optional
-(void)selectClass:(ClassItemView *)classItemView;
-(void)unSelectClass:(ClassItemView *)classItemView;

@end

@class ClassModel;
@interface ClassItemView : UIView
{
    UILabel *classTitle;
    ClassModel *_classModel;
}

@property (assign, nonatomic) kClassItemType classItemType;
@property (nonatomic,retain) ClassModel *classModel;
@property (nonatomic,assign) id<ClassItemViewDelegate> delegate;
@end
