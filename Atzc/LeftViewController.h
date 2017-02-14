//
//  LeftViewController.h
//  Atzc 左侧服务导航和用户头像
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface LeftViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
@private
    UIView             *_bottomBarWarpView;
    AtzcUserHeaderView *_userHeaderImage;    
}
@property (retain, nonatomic) UITableView *servicesListTableView;

@end
