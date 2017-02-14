//
//  NewsCommentViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-9.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "CommentView.h"
#import "CommentInputBar.h"

@interface NewsCommentViewController ()<CommentInputBarDelegate>

@end

@implementation NewsCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"评论";
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
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-60)];
    [_scrollView setBounces:YES];
    [_scrollView setBouncesZoom:NO];//不放大缩小
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight+100);
    
    //添加取消键盘手势
    UITapGestureRecognizer *tap;
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [_scrollView addGestureRecognizer:tap];
    
    //评论框
    CommentInputBar *inputBar = [[CommentInputBar alloc]initWithFrame:CGRectMake(0, ScreenHeight-41-15-49, ScreenWidth, 41)];
    inputBar.backgroundColor = Color(214, 214, 214, 1);
    inputBar.tag=4;
    inputBar.delegate = self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputBar];
}

#pragma mark    请求信息详情网络回调
//请求网络活动信息详情
-(void)initNewsModel
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/news/Comments.ashx"]];
    //post参数
    [request setPostValue:[NSString stringWithFormat:@"%i",_NewsID] forKey:@"newsid"];
    [request setPostValue:@"CommentList" forKey:@"action"];
    
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
    //_newsInfoModel.Content=[resultClasses objectForKey:@"Content"];
    _newsInfoModel.CreateTime=[resultClasses objectForKey:@"CreateTime"];
    
    //发布者
    UserModel *publicer=[[UserModel alloc] init];
    publicer.UserID      =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserID"];
    publicer.UserName    =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserName"];
    publicer.Header      =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
    publicer.UserAccount =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
    
    _newsInfoModel.Publicer=publicer;
    [publicer release];
    
    //评论列表
    NSArray *csinfocommentsresult=[resultClasses objectForKey:@"Comments"];
    
    _newsInfoModel.Comments=[[NSMutableArray alloc] initWithCapacity:csinfocommentsresult.count];
    
    //遍历每个评论
    for (id data in csinfocommentsresult) {
        CommentModel *csinfoCommentModel=[CommentModel  alloc];
        csinfoCommentModel.ID  = [[data objectForKey:@"ID"] intValue];
        csinfoCommentModel.Content     = [data objectForKey:@"Content"];
        csinfoCommentModel.CreateTime = [data objectForKey:@"CreateTime"];
        //评论者
        UserModel *publicer=[[UserModel alloc] init];
        publicer.UserName    =[[data objectForKey:@"Publicer"] objectForKey:@"UserName"];
        publicer.Header      =[[data objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
        publicer.UserAccount =[[data objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
        
        csinfoCommentModel.Publicer=publicer;
        [publicer release];
        
        [_newsInfoModel.Comments addObject:csinfoCommentModel];
        [csinfoCommentModel release];
    }
    
    
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
    //刷新评论列表
    [self RefreshCommentUI];
}
//刷新评论列表
-(void)RefreshCommentUI
{
    UIView *anousbottomLine=[self.view viewWithTag:1];
    
    int commentViewHeight=0;
    for (CommentModel *commentModel in _newsInfoModel.Comments) {
        
        CommentView *commentView=[[CommentView alloc] initWithFrame:CGRectMake(0, anousbottomLine.bottom+5+commentViewHeight, ScreenWidth, 50)];
        commentView.commentModel=commentModel;
        [_scrollView addSubview:commentView];
        [commentView release];
        commentViewHeight+=50;
    }
    _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height+commentViewHeight);
    
}

#pragma mark 评论框代理
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
   [self.view.window showHUDWithText:@"操作成功" Type:ShowPhotoYes Enabled:YES];
}
//评论请求失败
- (void)requestDoCommentError:(ASIFormDataRequest*)request
{
    [self.view.window showHUDWithText:@"操作失败" Type:ShowPhotoYes Enabled:YES];
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    //取消编辑
    [self.view endEditing:YES];
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
    [_scrollView release];_scrollView=nil;
}

@end
