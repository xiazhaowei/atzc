//
//  RightViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface RightViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>//配置表视图的数据和行为
{
@private
    UITableView *_friendListTableView;
    NSMutableArray *_FriendListArray;//存放好友的全局数组
}
@end
