//
//  FriendDynViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendDynViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>//配置集合视图的数据和行为
{

    UITableView *_dynListTableView;
    NSMutableArray *_Dyns;
    int _Page;
    
    UIView *_mainCommentView;
    UITextField *_commentText;
    UIButton *_btnSend;
    
    UITapGestureRecognizer *tap;
}
@end
