//
//  MessageUserUnionModel.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "MessageUserUnionModel.h"

@implementation MessageUserUnionModel
@synthesize message,user;


+(MessageUserUnionModel *)unionWithMessage:(MessageModel *)aMessage andUser:(UserModel *)aUser
{
    MessageUserUnionModel *unionObject=[[MessageUserUnionModel alloc]init];
    [unionObject setUser:aUser];
    [unionObject setMessage:aMessage];
    return unionObject;
}
@end
