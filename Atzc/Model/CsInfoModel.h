//
//  CsInfoModel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-23.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@class UserModel,NSMutableArray;
@interface CsInfoModel : NSObject

@property (nonatomic,assign) int NewsID;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Pic;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,copy) NSString *Price;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,retain) UserModel *Publicer;
@property (nonatomic,retain) NSMutableArray *Comments;

+(BOOL)Collect:(CsInfoModel*)aCsInfo collectType:(int) collecttype;

@end
