//
//  VideoMainViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-4.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"

@interface VideoMainViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *collectionView;
    NSMutableArray   *videoArray;
    
    MJRefreshFooterView *_footer;
    int _Page;
}
@end
