//
//  UserInfoPanel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoPanel : UIView
{
    AtzcUserHeaderView *userHead;
    UserModel *_userModel;
    UILabel   *userName;
    UILabel   *userMobile;    
}
@property (nonatomic,retain) UserModel *userModel;
@end
