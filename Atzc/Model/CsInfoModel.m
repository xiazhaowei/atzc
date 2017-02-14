//
//  CsInfoModel.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-23.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CsInfoModel.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation CsInfoModel
@synthesize NewsID,Title,Content,Pic,Price,CreateTime,Publicer,Comments;


//收藏信息 0 浏览记录 1 收藏
+(BOOL)Collect:(CsInfoModel *)aCsInfo collectType:(int) collecttype
{
    
    //打开数据库
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    
    NSString *createStr=@"CREATE  TABLE  IF NOT EXISTS 'atzcCsInfo' ('id' INTEGER, 'title' VARCHAR, 'pic' VARCHAR, 'content' VARCHAR, 'createtime' VARCHAR ,'savetype' INTEGER)";
    //创建表，如果不存在的话
    BOOL worked = [db executeUpdate:createStr];
    FMDBQuickCheck(worked);    
    
    //将数据存储的本地数据库
//    NSString *insertStr=@"INSERT INTO 'atzcCsInfo' ('id','title','pic','content','createtime','savetype') VALUES (?,?,?,?,?,?)";
//    //执行sql  并不错参数
//    worked = [db executeUpdate:insertStr,aCsInfo.NewsID,aCsInfo.Title,aCsInfo.Pic,aCsInfo.Content,aCsInfo.CreateTime,collecttype];
//    FMDBQuickCheck(worked);
    
    //关闭数据库
    [db close];
    
    return worked;
}



@end
