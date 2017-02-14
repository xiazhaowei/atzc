//
//  NewsMainViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-26.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

#import "MJRefresh.h"

@interface NewsListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    //MKHorizMenu *_horizMenu;
    NSMutableArray *_NewsListArray;
    UITableView *newsListTable;//信息列表
    int _Page;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    //NSMutableArray *_menuItems;
    //NSDictionary   *_menuClass;
    
    //NSMutableArray   *_menuLastUpdateTime;
}
@property (nonatomic,assign) int ClassID;
@end
