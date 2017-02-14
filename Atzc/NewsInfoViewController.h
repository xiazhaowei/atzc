//
//  NewsInfoViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-27.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "ByAtzcChartView.h"
#import "CollectView.h"

@interface NewsInfoViewController : BaseViewController<ChartByAtzcDelegate,CollectMessageDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>
{
    int            _NewsID;    
    NewsInfoModel    *_newsInfoModel;
    UIWebView *webView;
}
@property (nonatomic,assign) int NewsID;
@property (nonatomic,assign) NewsInfoModel *newsInfoModel;
@end
