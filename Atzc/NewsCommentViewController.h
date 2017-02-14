//
//  NewsCommentViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-9.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsCommentViewController : BaseViewController
{
    int            _NewsID;
    UIScrollView   *_scrollView;
    NewsInfoModel    *_newsInfoModel;
}
@property (nonatomic,assign) int NewsID;
@end
