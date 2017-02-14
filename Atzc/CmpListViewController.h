//
//  CmpListViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "CsInfoClsView.h"
#import "MJRefresh.h"

@interface CmpListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,FilterSjcmNewsDelegate>
{
    NSMutableArray *_CompanyListArray;//存放好友的全局数组
    UITableView *companyListTable;//信息列表
    NSString *_classcollection;
    MJRefreshFooterView *_footer;
    int _Page;
}
@end
