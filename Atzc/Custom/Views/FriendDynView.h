//
//  FriendDynView.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-4.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendDynView;

//数据源代理
@protocol FriendDynViewDataSource <NSObject>
@required
- (int) numberOfItemsForDyn:(FriendDynView*) dynView;//动态数量
- (UITableViewCell *)dynView:(FriendDynView *)dynView itemForRow:(int)row;//动态项目
- (CGFloat)dynView:(FriendDynView *)dynView heightForRow:(int)row;//项目高度
@end

//代理
@protocol FriendDynViewDelegate <NSObject>
@required
- (void)friendDyn:(FriendDynView*) friendDyn itemSelectedAtIndex:(NSUInteger) index;
@end


@interface FriendDynView : UIScrollView
{
    int _itemCount;
    id <FriendDynViewDataSource> dataSource;
    id <FriendDynViewDelegate> itemSelectedDelegate;
    UserModel *_userFriendModel;
    
    UIView *topNavView;
    AtzcUserHeaderView *userHeaderView;
    UILabel *friendNameLabel;
    UILabel *friendInfoLabel;
}

@property (nonatomic, retain) id <FriendDynViewDataSource> dataSource;
@property (nonatomic, assign) id <FriendDynViewDelegate> itemSelectedDelegate;
@property (nonatomic, assign) int itemCount;
@property (nonatomic,assign) UserModel *userFriendModel;

-(void) reloadData;

@end
