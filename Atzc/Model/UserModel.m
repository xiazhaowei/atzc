//
//  UserModel.m
//  WXWeibo
//
//  Created by wei.chen on 13-1-22.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UserModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation UserModel
@synthesize Description,Header,UserID,UserName,UserAccount,Verified,friendFlag;

//新用户入库
+(BOOL)saveNewUser:(UserModel*)aUser
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    
    [UserModel checkTableCreatedInDb:db];
    NSString *insertStr=@"INSERT INTO 'atzcUser' ('userId','useraccount','username','description','userHead','friendFlag') VALUES (?,?,?,?,?,?)";
    BOOL worked = [db executeUpdate:insertStr,aUser.UserID,aUser.UserAccount,aUser.UserName,aUser.Description,aUser.Header,aUser.friendFlag];
    // FMDBQuickCheck(worked);
    [db close];
    return worked;
}
//判断用户是否已经保存
+(BOOL)haveSaveUserById:(NSString*)userId
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return YES;
    };
    [UserModel checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:@"select count(*) from atzcUser where userId=?",userId];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
    
}
//判断用户是否已经保存
+(BOOL)haveSaveUserByAccount:(NSString*)userAccount
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return YES;
    };
    [UserModel checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:@"select count(*) from atzcUser where useraccount=?",userAccount];
    while ([rs next]) {
        int count= [rs intForColumnIndex:0];
        
        if (count!=0){
            [rs close];
            return YES;
        }else
        {
            [rs close];
            return NO;
        }
        
    };
    [rs close];
    return YES;
    
}
//通过ID 删除用户
+(BOOL)deleteUserById:(NSNumber*)userId
{
    return NO;
}
//更新用户
+(BOOL)updateUser:(UserModel*)newUser
{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [UserModel checkTableCreatedInDb:db];
    BOOL worked=[db executeUpdate:@"update atzcUser set friendFlag=1 where userId=?",newUser.UserID];
    
    return worked;
    
}
//从本地读取所有好友
+(NSMutableArray*)fetchAllFriendsFromLocal
{
    NSMutableArray *resultArr=[[NSMutableArray alloc]init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return resultArr;
    };
    [UserModel checkTableCreatedInDb:db];
    
    FMResultSet *rs=[db executeQuery:@"select * from atzcUser where friendFlag=?",[NSNumber numberWithInt:1]];
    while ([rs next]) {
        UserModel *user=[[UserModel alloc]init];
        user.UserID=[rs stringForColumn:kUSER_ID];
        user.UserName=[rs stringForColumn:kUSER_NICKNAME];
        user.UserAccount=[rs stringForColumn:kUSER_ACCOUNT];
        user.Header=[rs stringForColumn:kUSER_USERHEAD];
        user.Description=[rs stringForColumn:kUSER_DESCRIPTION];
        user.friendFlag=[NSNumber numberWithInt:1];
        [resultArr addObject:user];
    }
    [rs close];
    return resultArr;
    
}
//从字典获取用户
+(UserModel*)userFromDictionary:(NSDictionary*)aDic
{
    UserModel *user=[[[UserModel alloc]init]autorelease];
    [user setUserID:[[aDic objectForKey:kUSER_ID]stringValue]];
    [user setHeader:[aDic objectForKey:kUSER_USERHEAD]];
    [user setDescription:[aDic objectForKey:kUSER_DESCRIPTION]];
    [user setUserName:[aDic objectForKey:kUSER_NICKNAME]];
    [user setUserAccount:[aDic objectForKey:kUSER_ACCOUNT]];
    return user;
}
//转换为字典
-(NSDictionary*)toDictionary
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:UserID,kUSER_ID,UserName,kUSER_NICKNAME,Description,kUSER_DESCRIPTION,Header,kUSER_USERHEAD,UserAccount,kUSER_ACCOUNT,friendFlag,kUSER_FRIEND_FLAG, nil];
    return dic;
}
//判断表格是否在数据库中创建了
+(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'atzcUser' ('userId' VARCHAR PRIMARY KEY  NOT NULL  UNIQUE , 'username' VARCHAR, 'userAccount' VARCHAR,'description' VARCHAR, 'userHead' VARCHAR,'friendFlag' INT)";
    
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);
    return worked;
    
}
@end
