//
//  BaseWebViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-3.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class UIWebView;
@interface BaseWebViewController : BaseViewController

@property (nonatomic,assign) UIWebView *webView;
-(void)loadWebPageWithString:(NSString*)urlString;
@end
