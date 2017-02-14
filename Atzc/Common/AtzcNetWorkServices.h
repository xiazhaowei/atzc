//
//  AtzcNetWorkServices.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AtzcNetWorkServices : NSObject
//解析json数据
+(id)ParseJsonData:(NSData *) data;
//json写入到文件
+(void)WirteToJsonFile:(NSString *) jsonFileName JsonData:(NSData *)jsonData;
//读取json文件
+(NSData *)ReadFromJsonFile:(NSString *) jsonFileName;
@end
