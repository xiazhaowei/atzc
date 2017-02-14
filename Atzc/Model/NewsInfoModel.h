//
//  NewsInfoModel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-26.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@class UserModel;
@interface NewsInfoModel : NSObject

@property (nonatomic,assign) int NewsID;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Pic;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,retain) NSMutableArray *Comments;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,retain) UserModel *Publicer;

@end
