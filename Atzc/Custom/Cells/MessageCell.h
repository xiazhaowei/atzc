//
//  MessageCell.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>
//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f

@interface MessageCell : UITableViewCell
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
    UIImageView *_chatImage;
    UILabel *_messageConent;
}
@property (nonatomic) enum kWCMessageCellStyle msgStyle;
@property (nonatomic) int height;
-(void)setMessageObject:(MessageModel*)aMessage;
-(void)setHeadImage:(UIImage*)headImage;
-(void)setChatImage:(UIImage *)chatImage;
@end
