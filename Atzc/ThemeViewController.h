//
//  ThemeViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *themes;
}
@property (retain, nonatomic) UITableView *themesListTableView;
@end
