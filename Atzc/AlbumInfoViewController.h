//
//  AlbumInfoViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-6.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"

@interface AlbumInfoViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    AlbumModel *_albumModel;
    UICollectionView *collectionView;
    MJRefreshFooterView *_footer;
    int _Page;
}
@property (nonatomic,assign) int albumid;

@end
