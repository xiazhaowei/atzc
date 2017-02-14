//
//  CsInfoViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-24.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "ByAtzcChartView.h"
#import "CollectView.h"

@interface CsInfoViewController : BaseViewController<ChartByAtzcDelegate,CollectMessageDelegate>
{
    int            _NewsID;
    UIScrollView   *_scrollView;
    CsInfoModel    *_csInfoModel;    
    
}
@property (nonatomic,assign) int NewsID;
@property (nonatomic,assign) CsInfoModel *csInfoModel;
@end
