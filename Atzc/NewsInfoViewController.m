//
//  NewsInfoViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-27.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "RTLabel.h"
#import "CommentView.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "NewsCommentViewController.h"
#import "CommentInputBar.h"


@interface NewsInfoViewController ()<CommentInputBarDelegate>

@end

@implementation NewsInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"新闻详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSubViews];
    
	//获得信息详情
	[self initNewsModel];
}

-(void)initSubViews
{
    webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-69)];
    webView.backgroundColor=[UIColor clearColor];
    webView.allowsInlineMediaPlayback=YES;
    webView.keyboardDisplayRequiresUserAction=YES;
    webView.userInteractionEnabled=YES;
    
    //隐藏网页中的图片视图
    for(UIView *view in [[[webView subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[UIImageView class]]) { view.hidden = YES; }
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 44, 0);
    [webView.scrollView setScrollIndicatorInsets:edgeInsets];
    [webView.scrollView setContentInset:edgeInsets];
    
    //webView 点击事件
    UITapGestureRecognizer *imageTapDetector = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [imageTapDetector setNumberOfTapsRequired:1];
    [imageTapDetector setDelegate:self];
    [imageTapDetector setDelaysTouchesBegan:YES];
    [webView addGestureRecognizer:imageTapDetector];
    [imageTapDetector release];
    
    [self.view addSubview:webView];
    
    //评论框
    CommentInputBar *inputBar = [[CommentInputBar alloc]initWithFrame:CGRectMake(0, ScreenHeight-41-15-49, ScreenWidth, 41)];
    inputBar.backgroundColor = Color(214, 214, 214, 1);
    inputBar.tag=4;
    inputBar.delegate = self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputBar];
    
    //右侧评论按钮
    [self rightCommentButton];
    
}

-(void)rightCommentButton
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"showcommentbutton.png" highlighted:@"showcommentbutton.png"];
    button.backgroundColor=[UIColor clearColor];
    button.frame = CGRectMake(0, 0, 44, 38);
    //按钮添加动作
    [button addTarget:self action:@selector(showCommentVC:) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.rightBarButtonItem = [backItem autorelease];
}
-(void)showCommentVC:(id)sender{
    NewsCommentViewController *newsCommentVC=[[NewsCommentViewController alloc] init];
    newsCommentVC.NewsID=self.NewsID;
    [self.navigationController pushViewController:newsCommentVC animated:YES];
    [newsCommentVC release];
}

#pragma mark    请求信息详情网络回调
//请求网络活动信息详情
-(void)initNewsModel
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/news/newsinfo.ashx"]];
    //post参数
    [request setPostValue:[NSString stringWithFormat:@"%i",_NewsID] forKey:@"newsid"];
    [request setPostValue:@"Info" forKey:@"action"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    //添加指示层
    [DejalActivityView activityViewForView:self.view withLabel:@"正在加载"];
}

//请求网络成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [DejalActivityView removeView];
    NSData *jsonData = [request responseData];
    //解析json
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultClasses=[paser objectWithData:jsonData];
    
    //获得信息实体类
    _newsInfoModel=[[NewsInfoModel alloc] init];
    
    _newsInfoModel.Title=[resultClasses objectForKey:@"Title"];
    _newsInfoModel.Content=[resultClasses objectForKey:@"Content"];
    _newsInfoModel.CreateTime=[resultClasses objectForKey:@"CreateTime"];
    
    //发布者
    UserModel *publicer=[[UserModel alloc] init];
    publicer.UserID      =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserID"];
    publicer.UserName    =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserName"];
    publicer.Header      =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
    publicer.UserAccount =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
    
    _newsInfoModel.Publicer=publicer;
    [publicer release];
    [self RefreshUI];
}
//信息请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DejalActivityView removeView];
}

//刷新界面
-(void)RefreshUI
{
    //新闻网页模板
    NSMutableString *string = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"newstemplate" ofType:@"html"] encoding:NSUTF8StringEncoding error:nil] mutableCopy];
    //替换标题 等
    [string replaceOccurrencesOfString:@"**[title]**" withString:_newsInfoModel.Title options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"**[createtime]**" withString:_newsInfoModel.CreateTime options:0 range:NSMakeRange(0, string.length)];
    [string replaceOccurrencesOfString:@"loading..." withString:_newsInfoModel.Content options:0 range:NSMakeRange(0, string.length)];
    [webView loadHTMLString:string baseURL:nil];
    
}

#pragma mark -
#pragma mark WebView  代理

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//webView 点击
- (void)tapDetected:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized)
    {
        //点击的位置
        CGPoint touchPoint = [tap locationInView:self.view];
        
        //获得网页中图片的src
        NSString *imageURL = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y]];
        
        NSArray *imageFormats=[[NSArray alloc] initWithObjects:@"jpg",@"jpeg",@"bmp",@"png",nil];
        
        //如果图片是这种格式
        if ([imageFormats containsObject:imageURL.pathExtension])
        {
            //点击图片显示大图
            
            NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
            for (int i = 0; i<1; i++) {
                // 替换为中等尺寸图片
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:imageURL]; // 图片路径
                //photo.srcImageView = imgView; // 来源于哪个UIImageView
                [photos addObject:photo];
                [photo release];
            }            
            // 2.显示相册
            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
            browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
            browser.photos = photos;
            [browser show];
            [photos release];
        }
        [imageFormats release];
    }
}

#pragma mark 评论框的代理
//评论
-(void)inputBar:(CommentInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    //如果输入文字
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0)
    {
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/news/comments.ashx"]];
        //post参数
        [request setPostValue:[NSString stringWithFormat:@"%i",_NewsID] forKey:@"newsid"];
        [request setPostValue:@"Save" forKey:@"action"];
        [request setPostValue:self.userModel.UserID forKey:@"userid"];
        [request setPostValue:str forKey:@"content"];
        
        [request setDelegate:self];
        //请求代理  结束  或失败
        [request setDidFinishSelector:@selector(requestDoCommentSuccess:)];
        [request setDidFailSelector:@selector(requestDoCommentError:)];
        [request startAsynchronous];
    }
}
//评论请求成功
-(void)requestDoCommentSuccess:(ASIFormDataRequest*)request
{
    //提示
    [self.view.window showHUDWithText:@"操作成功" Type:ShowPhotoYes Enabled:YES];
}
//评论请求失败
- (void)requestDoCommentError:(ASIFormDataRequest*)request
{
    [self.view.window showHUDWithText:@"操作失败" Type:ShowPhotoYes Enabled:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [_newsInfoModel release];
    _newsInfoModel=nil;
    [webView release];webView=nil;
}

@end
