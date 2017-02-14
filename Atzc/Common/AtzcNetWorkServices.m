//
//  AtzcNetWorkServices.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "AtzcNetWorkServices.h"
#import "ASIHTTPRequest.h"

@implementation AtzcNetWorkServices

//解析数据 从本地读取json
+(id)parserData:(NSString *)name
{
    //获得文件的包路径
    NSString *path =[[NSBundle mainBundle] pathForResource:name ofType:@"json"];    
    //NSString *resourcePath=[[NSBundle mainBundle] resourcePath];
    //path 等于包路径拼接上名字
    //NSString *path =[resourcePath stringByAppendingPathComponent:name];
    
    //data屏蔽了数据的差异性 读取到data中
    NSData *data=[NSData dataWithContentsOfFile:path];
    
    //解析数据  5.0以上
    id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    
    return result;
}


//写入json文件
+(void)WirteToJsonFile:(NSString *) jsonFileName JsonData:(NSData *)jsonData
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:jsonFileName];
    //==写入文件
    [jsonData writeToFile:Json_path atomically:YES];
}


//读取json文件
+(NSData *)ReadFromJsonFile:(NSString *) jsonFileName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *Json_path=[path stringByAppendingPathComponent:jsonFileName];
    //==Json数据
    NSData *data=[NSData dataWithContentsOfFile:Json_path];
    //==JsonObject
    //解析数据
    //id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    
    return data;
}


//解析json数据
+(id)ParseJsonData:(NSData *) data
{
    id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    return result;
}

@end
