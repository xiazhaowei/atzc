//
//  CsInfoViewController.m
//  Atzc 信息详情页
//
//  Created by 夏兆伟 on 13-12-24.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CsInfoViewController.h"
#import "RTLabel.h"
#import "CommentView.h"
#import "UserInfoPanel.h"
#import "CallMobileView.h"
#import "SendMsgView.h"
#import "ByAtzcChartView.h"
#import "SendMessageViewController.h"
#import "BaseNavigationController.h"
#import "CommentInputBar.h"

@interface CsInfoViewController ()<CommentInputBarDelegate>

@end

@implementation CsInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"信息详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获得信息详情
	[self initNewsModel];

}

#pragma mark    请求信息详情网络回调
//请求网络活动信息详情
-(void)initNewsModel
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/csinfo/csinfo.ashx"]];
    //post参数
    [request setPostValue:[NSString stringWithFormat:@"%i",_NewsID] forKey:@"newsid"];
    [request setPostValue:@"Info" forKey:@"Action"];
    [request setPostValue:[NSString stringWithFormat:@"%i",1] forKey:@"Page"];
    
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
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultClasses=[paser objectWithData:jsonData];
    
    //获得信息实体类
    _csInfoModel=[[CsInfoModel alloc] init];
    
    _csInfoModel.Title=[resultClasses objectForKey:@"Title"];
    _csInfoModel.Content=[resultClasses objectForKey:@"Content"];
    _csInfoModel.CreateTime=[resultClasses objectForKey:@"CreateTime"];
    
    //发布者
    UserModel *publicer=[[UserModel alloc] init];
    publicer.UserID      =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserID"];
    publicer.UserName    =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserName"];
    publicer.Header      =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
    publicer.UserAccount =[[resultClasses objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
    
    _csInfoModel.Publicer=publicer;
    [publicer release];
    
    
    //评论
    NSArray *csinfocommentsresult=[resultClasses objectForKey:@"Comments"];
    
    _csInfoModel.Comments=[[NSMutableArray alloc] initWithCapacity:csinfocommentsresult.count];
    
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
        
        [_csInfoModel.Comments addObject:csinfoCommentModel];
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
    //顶部工具栏
    UIView *topToolBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    //发布者信息
    UserInfoPanel *userInfoPanel=[[UserInfoPanel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    userInfoPanel.userModel=self.csInfoModel.Publicer;
    [topToolBar addSubview:userInfoPanel];
    [userInfoPanel release];
    
    //打电话
    CallMobileView *callMobeilView=[[CallMobileView alloc] initWithFrame:CGRectMake(userInfoPanel.right+30, userInfoPanel.top, 40, 40)];
    callMobeilView.mobile=@"15589672395";
    [topToolBar addSubview:callMobeilView];
    [callMobeilView release];
    //发短信
    SendMsgView *sendMsgView=[[SendMsgView alloc] initWithFrame:CGRectMake(callMobeilView.right+7, callMobeilView.top, callMobeilView.width, callMobeilView.height)];
    sendMsgView.mobile=@"15589672395";
    [topToolBar  addSubview:sendMsgView];
    [sendMsgView release];
    //交流
    ByAtzcChartView *byAtzcChartView=[[ByAtzcChartView alloc] initWithFrame:CGRectMake(sendMsgView.right+7, sendMsgView.top, sendMsgView.width, sendMsgView.height)];
    byAtzcChartView.delegate=self;
    [topToolBar  addSubview:byAtzcChartView];
    [byAtzcChartView release];
    //收藏
    CollectView *collectView=[[CollectView alloc] initWithFrame:CGRectMake(byAtzcChartView.right+7, byAtzcChartView.top, byAtzcChartView.width, byAtzcChartView.height)];
    collectView.delegate=self;
    [topToolBar  addSubview:collectView];
    [collectView release];
    
    
    //工具栏底线
    UIView *topToolBarBottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, topToolBar.height-1, ScreenWidth, 1)];
    topToolBarBottomLine.backgroundColor=Color(80, 191, 147, 1);
    [topToolBar addSubview:topToolBarBottomLine];
    
    [topToolBarBottomLine release];
    
    
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    //滚动视图
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, topToolBar.height, ScreenWidth, ScreenHeight-49-topToolBar.height-60)];
    [_scrollView setBounces:YES];
    [_scrollView setBouncesZoom:NO];//不放大缩小
    [self.view addSubview:_scrollView];
    
    //添加一个手势 点击 取消键盘
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    //手势添加到表格
    [_scrollView addGestureRecognizer:tap];
    
    //标题
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-5, 50)];
    titleLabel.text=_csInfoModel.Title;
    titleLabel.font=[UIFont boldSystemFontOfSize:14];
    titleLabel.numberOfLines=3;
    
    [_scrollView addSubview:titleLabel];
    [titleLabel release];
    
    //发布时间
    UILabel *createTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom+10, titleLabel.width, 15)];
    createTimeLabel.font=[UIFont systemFontOfSize:12];
    createTimeLabel.textColor=[UIColor grayColor];
    createTimeLabel.text=[NSString stringWithFormat:@"发布时间: %@",_csInfoModel.CreateTime];
    [_scrollView addSubview:createTimeLabel];
    [createTimeLabel release];
    
    //分割线
    UIView *timebottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, createTimeLabel.bottom+5, ScreenWidth, 1)];
    timebottomLine.backgroundColor=Color(222, 222, 222, 1);
    [_scrollView addSubview:timebottomLine];
    [timebottomLine release];
    
    //内容
    RTLabel *contentLabel=[[RTLabel alloc] initWithFrame:CGRectMake(titleLabel.left, timebottomLine.bottom+5, titleLabel.width, 150)];
    contentLabel.font=[UIFont systemFontOfSize:13];
    contentLabel.text=_csInfoModel.Content;
    [contentLabel setLineSpacing:5.0f];
    
    //内容高度
    CGSize optimumSize = [contentLabel optimumSize];
	CGRect frame = [contentLabel frame];
	frame.size.height = (int)optimumSize.height+5; // +5 to fix height issue, this should be automatically fixed in iOS5
	[contentLabel setFrame:frame];
    
    [_scrollView addSubview:contentLabel];
    [contentLabel release];
    
    //分割线
    UIView *contentbottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, contentLabel.bottom+5, ScreenWidth, 1)];
    contentbottomLine.backgroundColor=Color(222, 222, 222, 1);
    [_scrollView addSubview:contentbottomLine];
    [contentbottomLine release];
    
    //说明
    UILabel *sumeryLabel=[[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, contentbottomLine.bottom+10, titleLabel.width, 12)];
    sumeryLabel.font=[UIFont systemFontOfSize:12];
    sumeryLabel.textColor=[UIColor grayColor];
    sumeryLabel.text=[NSString stringWithFormat:@"联系%@时，请说是在 %@ 上看到的，谢谢~",self.csInfoModel.Publicer.UserName,MySiteName];
    [_scrollView addSubview:sumeryLabel];
    [sumeryLabel release];
    
    UILabel *annousLabel=[[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, sumeryLabel.bottom+10, titleLabel.width, 70)];
    annousLabel.font=[UIFont systemFontOfSize:12];
    annousLabel.numberOfLines=5;
    annousLabel.textColor=[UIColor orangeColor];
    annousLabel.text=[NSString stringWithFormat:@"%@ 分类信息服务，主要为免费服务，尽管我们有专人负责审核验证信息的真实性，但是也难避免有些信息存在欺诈危险，特提醒用户在交易时要谨慎，谨防上当受骗，谢谢合作~",MySiteName];
    [_scrollView addSubview:annousLabel];
    [annousLabel release];
    
    //分割线
    UIView *anousbottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, annousLabel.bottom+5, ScreenWidth, 1)];
    anousbottomLine.backgroundColor=Color(222, 222, 222, 1);
    anousbottomLine.tag=1;
    [_scrollView addSubview:anousbottomLine];
    [anousbottomLine release];
    
    
    
    //评论框
    CommentInputBar *inputBar = [[CommentInputBar alloc]initWithFrame:CGRectMake(0, ScreenHeight-44-15-49, ScreenWidth, 44)];
    inputBar.backgroundColor = Color(214, 214, 214, 1);
    inputBar.tag=4;
    inputBar.delegate = self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    
    
    [self.view addSubview:inputBar];
    
    _scrollView.contentSize=CGSizeMake(ScreenWidth, anousbottomLine.bottom+20);
    
    //刷新评论列表
    [self RefreshCommentUI];
}


//刷新评论列表
-(void)RefreshCommentUI
{
    UIView *anousbottomLine=[self.view viewWithTag:1];
    
    int commentViewHeight=0;
    for (CommentModel *commentModel in _csInfoModel.Comments) {
        
        CommentView *commentView=[[CommentView alloc] initWithFrame:CGRectMake(0, anousbottomLine.bottom+5+commentViewHeight, ScreenWidth, 50)];
        commentView.commentModel=commentModel;
        [_scrollView addSubview:commentView];
        [commentView release];
        commentViewHeight+=50;
    }
    _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height+commentViewHeight);
    
}


//评论
-(void)inputBar:(CommentInputBar *)inputBar sendBtnPress:(UIButton *)sendBtn withInputString:(NSString *)str
{
    //如果输入文字
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0)
    {
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/csinfo/csinfo.ashx"]];
        //post参数
        [request setPostValue:[NSString stringWithFormat:@"%i",_NewsID] forKey:@"newsid"];
        [request setPostValue:@"Comment" forKey:@"Action"];
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
    CommentModel *commentModel=[[CommentModel alloc] init];
    commentModel.Content=@"comment contents";
    commentModel.Publicer=self.userModel;
    
    [_csInfoModel.Comments addObject:commentModel];
    
    [self RefreshCommentUI];
}
//评论请求失败
- (void)requestDoCommentError:(ASIFormDataRequest*)request
{
    
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

#pragma mark 工具栏的代理
//用在诸城交流
-(void)ChartByAtzc
{
    SendMessageViewController *sendMessageVC=[[SendMessageViewController alloc] init];
    sendMessageVC.chatPerson=self.csInfoModel.Publicer;
    
    [self.navigationController pushViewController:sendMessageVC animated:YES];
    [sendMessageVC release];
}
//收藏
-(void)CollectMessage
{
    if ([CsInfoModel Collect:self.csInfoModel collectType:1]) {
        [self.view.window showHUDWithText:@"收藏成功" Type:ShowPhotoYes Enabled:YES];
    };
}


#pragma mark 内存
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [_csInfoModel release];
    _csInfoModel=nil;
}

@end
