//
//  FridenViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-5.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendDynView.h"

@interface FriendViewController : BaseViewController<FriendDynViewDataSource,FriendDynViewDelegate>
{
@private
    UserModel *_userFriendModel;
    FriendDynView *friendDynView;
    
    NSMutableArray *_Dyns;
}
@property (nonatomic,assign) UserModel *userFriendModel;
@end
