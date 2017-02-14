//
//  SendMsgView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMsgView : UIView
{
    UIImageView *_msgicon;
    UILabel     *_phone;
}
@property (nonatomic,copy) NSString *mobile;
@end
