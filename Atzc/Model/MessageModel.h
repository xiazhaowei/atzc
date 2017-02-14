//
//  MessageModel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMESSAGE_TYPE @"messageType"
#define kMESSAGE_FROM @"messageFrom"
#define kMESSAGE_TO @"messageTo"
#define kMESSAGE_CONTENT @"messageContent"
#define kMESSAGE_DATE @"messageDate"
#define kMESSAGE_ID @"messageId"

//信息类型 文字 图片 语言  位置
enum kWCMessageType {
    kWCMessageTypePlain = 0,
    kWCMessageTypeImage = 1,
    kWCMessageTypeVoice =2,
    kWCMessageTypeLocation=3
};
//单元格类型 我自己的  别人的  自己带图片的  别人带图片的
enum kWCMessageCellStyle {
    kWCMessageCellStyleMe = 0,
    kWCMessageCellStyleOther = 1,
    kWCMessageCellStyleMeWithImage=2,
    kWCMessageCellStyleOtherWithImage=3
};

@interface MessageModel : NSObject

@property (nonatomic,retain) NSString *messageFrom;
@property (nonatomic,retain) NSString *messageTo;
@property (nonatomic,retain) NSString *messageContent;
@property (nonatomic,retain) NSDate *messageDate;
@property (nonatomic,retain) NSNumber *messageType;
@property (nonatomic,retain) NSNumber *messageId;

//将对象转换为字典
-(NSDictionary*)toDictionary;
+(MessageModel*)messageFromDictionary:(NSDictionary*)aDic;

//数据库增删改查
+(BOOL)save:(MessageModel*)aMessage;
+(BOOL)deleteMessageById:(NSNumber*)aMessageId;
+(BOOL)merge:(MessageModel*)aMessage;

//获取某联系人聊天记录
+(NSMutableArray *)fetchMessageListWithUser:(NSString *)userId byPage:(int)pageIndex;

//获取最近联系人
+(NSMutableArray *)fetchRecentChatByPage:(int)pageIndex;

@end
