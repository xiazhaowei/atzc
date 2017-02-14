//
//  FriendListCell.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListCell : UITableViewCell
{
@private
    AtzcUserHeaderView *_headerView;
    UILabel     *_userNameLabel;
    UILabel     *_latestMoodLabel;
    UserModel  *_userModel;
}

@property (nonatomic,retain) UserModel *userModel;//属性
-(void)setHeadImage:(NSString*)imageURL;//设置头像
@end
