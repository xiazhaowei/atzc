//
//  CsInfoMainViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-5.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "CsInfoClsView.h"
#import "MJRefresh.h"

@interface CsInfoListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,FilterSjcmNewsDelegate>
{
    NSMutableArray *_CsInfoListArray;//存放好友的全局数组
    UITableView *newsListTable;//信息列表
    NSString *_classcollection;
    MJRefreshFooterView *_footer;
    int _Page;
}
@end
