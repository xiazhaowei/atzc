//
//  BaseWebViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-3.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseWebViewController.h"
#import "UIFactory.h"

@interface BaseWebViewController ()

@end

@implementation BaseWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化webview
        [self initWebView];       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化工具栏
	[self initToolBar];
    
}
//创建webView
-(void)initWebView
{
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-65-40)];
    [self.view addSubview:_webView];
}
//初始化工具栏
-(void)initToolBar
{
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, _webView.bottom, ScreenWidth, 40)];
    toolBar.barStyle=UIBarStyleDefault;
    toolBar.backgroundColor=[UIColor grayColor];
    [self.view addSubview:toolBar];
    [toolBar release];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"后退.png"] style:UIBarButtonItemStylePlain target:nil action:@selector(webViewBack)];
    UIBarButtonItem *preItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"前进.png"] style:UIBarButtonItemStylePlain target:nil action:@selector(preViewBack)];
    
    UIBarButtonItem *flexibleItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *refreshItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"刷新.png"] style:UIBarButtonItemStylePlain target:nil action:@selector(refreshViewBack)];
    
    NSArray *toolbarItems=@[backItem,preItem,flexibleItem,refreshItem];
    [backItem release];
    [preItem release];
    [flexibleItem release];
    [refreshItem release];
    [toolBar setItems:toolbarItems animated:YES];
}
-(void)webViewBack
{
    [self.webView goBack];
}
-(void)preViewBack
{
    [self.webView goForward];
}
-(void)refreshViewBack
{
    [self.webView reload];
}

//打开某个连接
-(void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

//拉开分享工具
-(void)initShowToolItem
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"friendls_icon.png" highlighted:@"friendls_icon.png"];
    button.backgroundColor=[UIColor clearColor];
    button.frame = CGRectMake(0, 0, 24, 19);
    //按钮添加动作
    [button addTarget:self action:@selector(shouTools) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.rightBarButtonItem = [backItem autorelease];
}
-(void)shouTools
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
    [_webView dealloc];
}


@end
