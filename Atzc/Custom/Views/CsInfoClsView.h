//
//  CsInfoClsView.h
//  Atzc 请求网络解析类别 返回类别集合
//
//  Created by 夏兆伟 on 13-12-21.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassItemView.h"

typedef enum enumCsOrCmp
{
    enumCsInfoClass=0,
    enumCmpInfoClass=1
}enumCsOrCmp;

//筛选数据的代理
@protocol FilterSjcmNewsDelegate <NSObject>

@optional
-(void)FilterSjcmNews:(NSString *)classcollection;

@end


@interface CsInfoClsView : UIView<ClassItemViewDelegate>
{
    NSString *_classcollection;
    int            _deepClass;
    NSMutableArray *_rootClassAttributes;
    ClassModel     *_rootClassModel;    
}
@property (assign, nonatomic) int deepClass;
@property (copy, nonatomic) NSString *classcollection;
@property (retain,nonatomic) ClassModel *rootClassModel;
@property (assign,nonatomic) id<FilterSjcmNewsDelegate> delegate;
@property (assign, nonatomic) enumCsOrCmp CsOrCmp;

@end
