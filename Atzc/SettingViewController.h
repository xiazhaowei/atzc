//
//  SettingViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *settingListTableView;
@end
