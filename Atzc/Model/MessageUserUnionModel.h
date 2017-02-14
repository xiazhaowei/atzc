//
//  MessageUserUnionModel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "UserModel.h"

@interface MessageUserUnionModel : NSObject
@property (nonatomic,retain) MessageModel* message;
@property (nonatomic,retain) UserModel   * user;

+(MessageUserUnionModel *)unionWithMessage:(MessageModel *)aMessage andUser:(UserModel *)aUser;
@end
