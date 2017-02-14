//
//  MessageModel.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "MessageModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "MessageUserUnionModel.h"

@implementation MessageModel
@synthesize messageContent,messageDate,messageFrom,messageTo,messageType,messageId;

+(MessageModel *)messageWithType:(int)aType{
    MessageModel *msg=[[MessageModel alloc]init];
    [msg setMessageType:[NSNumber numberWithInt:aType]];
    return  msg;
}
//从字典缓存构建 信息类
+(MessageModel*)messageFromDictionary:(NSDictionary*)aDic
{
    MessageModel *msg=[[MessageModel alloc]init];
    [msg setMessageFrom:[aDic objectForKey:kMESSAGE_FROM]];
    [msg setMessageTo:[aDic objectForKey:kMESSAGE_TO]];
    [msg setMessageContent:[aDic objectForKey:kMESSAGE_CONTENT]];
    [msg setMessageDate:[aDic objectForKey:kMESSAGE_DATE]];
    [msg setMessageDate:[aDic objectForKey:kMESSAGE_TYPE]];
    return  msg;
}

//将对象转换为字典
-(NSDictionary*)toDictionary
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:messageId,kMESSAGE_ID,messageFrom,kMESSAGE_FROM,messageTo,kMESSAGE_TO,messageContent,kMESSAGE_TYPE,messageDate,kMESSAGE_DATE,messageType,kMESSAGE_TYPE, nil];
    return dic;
    
}

//增删改查
+(BOOL)save:(MessageModel*)aMessage
{
    
    //打开数据库
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    
    NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'atzcMessage' ('messageId' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL  UNIQUE , 'messageFrom' VARCHAR, 'messageTo' VARCHAR, 'messageContent' VARCHAR, 'messageDate' DATETIME,'messageType' INTEGER )";
    //创建表，如果不存在的话
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    
    
    //将聊天数据存储的本地数据库
    NSString *insertStr=@"INSERT INTO 'atzcMessage' ('messageFrom','messageTo','messageContent','messageDate','messageType') VALUES (?,?,?,?,?)";
    //执行sql  并不错参数
    worked = [db executeUpdate:insertStr,aMessage.messageFrom,aMessage.messageTo,aMessage.messageContent,aMessage.messageDate,aMessage.messageType];
    FMDBQuickCheck(worked);
    
    
    //关闭数据库
    [db close];
    //发送全局通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:aMessage ];
    [aMessage release];
    
    
    return worked;
}




//获取某联系人聊天记录
+(NSMutableArray*)fetchMessageListWithUser:(NSString *)userId byPage:(int)pageInde
{
    //存储聊天信息实体的数值
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    
    NSString *queryString=@"select * from atzcMessage where messageFrom=? or messageTo=? order by messageDate";
    
    FMResultSet *rs=[db executeQuery:queryString,userId,userId];
    while ([rs next]) {
        MessageModel *message=[[[MessageModel alloc]init]autorelease];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
        [ messageList addObject:message];
        
    }
    return  messageList;
    
}

//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex
{
    NSMutableArray *messageList=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据打开失败");
        return messageList;
    }
    
    NSString *queryString=@"select * from atzcMessage as m ,wcUser as u where u.userId<>? and ( u.userId=m.messageFrom or u.userId=m.messageTo ) group by u.userId  order by m.messageDate desc limit ?,10";
    FMResultSet *rs=[db executeQuery:queryString,[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID],[NSNumber numberWithInt:pageIndex-1]];
    while ([rs next]) {
        MessageModel *message=[[[MessageModel alloc]init]autorelease];
        [message setMessageId:[rs objectForColumnName:kMESSAGE_ID]];
        [message setMessageContent:[rs stringForColumn:kMESSAGE_CONTENT]];
        [message setMessageDate:[rs dateForColumn:kMESSAGE_DATE]];
        [message setMessageFrom:[rs stringForColumn:kMESSAGE_FROM]];
        [message setMessageTo:[rs stringForColumn:kMESSAGE_TO]];
        [message setMessageType:[rs objectForColumnName:kMESSAGE_TYPE]];
        
        UserModel *user=[[[UserModel alloc]init]autorelease];
        [user setUserID:[rs stringForColumn:kUSER_ID]];
        [user setUserName:[rs stringForColumn:kUSER_NICKNAME]];
        [user setHeader:[rs stringForColumn:kUSER_USERHEAD]];
        [user setDescription:[rs stringForColumn:kUSER_DESCRIPTION]];
        [user setFriendFlag:[rs objectForColumnName:kUSER_FRIEND_FLAG]];
        
        MessageUserUnionModel *unionObject=[MessageUserUnionModel unionWithMessage:message andUser:user ];
        
        [ messageList addObject:unionObject];
        
    }
    return  messageList;
    
}

@end
