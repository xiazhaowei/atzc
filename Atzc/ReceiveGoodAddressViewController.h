//
//  ReceiveGoodAddressViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-31.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface ReceiveGoodAddressViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *receveGoodAddressTable;
    NSMutableArray *ReceiveGoodAddressListArray;
}
@end
