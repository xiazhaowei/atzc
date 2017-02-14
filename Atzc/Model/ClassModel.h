//
//  ClassModel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-21.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassItemView.h"

@interface ClassModel : NSObject

@property(nonatomic,copy)NSString *ClassID;             //类别ID
@property(nonatomic,copy)NSString *ClassName;           //类别名称
@property(nonatomic,retain)NSNumber * NewsCount;        //信息数量
@property(nonatomic,assign)BOOL isSelected;          //是否选中
@property(nonatomic,assign)int ClassType;        //类型
@property(nonatomic,retain)NSMutableArray *SubClasses; //子类别
@end
