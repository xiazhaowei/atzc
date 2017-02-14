//
//  LeftViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "LeftViewController.h"
#import "ThemeViewController.h"
#import "AtzcUserHeaderView.h"
#import "ServicesListCell.h"
#import "MMDrawerController.h"
#import "SettingViewController.h"
#import "QRCodeScanViewController.h"
#import "NotificationViewController.h"
#import "BaseNavigationController.h"
#import "FriendDynViewController.h"
#import "GroupBuyMainViewController.h"
#import "CsInfoListViewController.h"
#import "NewsTabViewController.h"
#import "CmpListViewController.h"
#import "MeViewController.h"
#import "BBSMainViewController.h"
#import "HouseMainViewController.h"
#import "PicMainViewController.h"
#import "VideoMainViewController.h"
#import "AutoMainViewController.h"
#import "ShoppingMainViewController.h"
#import "FoodMainViewController.h"
#import "JobMainViewController.h"


@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //毛玻璃背景
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"leftMenuBg"]];
    
    [self initSubViews];
}

//初始化子视图
-(void)initSubViews
{
    //加载用户头像信息
    [self loadUserHeaderInfo];
    
    //加载服务列表表格视图
    [self loadservicesListTableView];
    //加载底部按钮栏
    [self loadButtomBar];
}

//加载用户头像信息
-(void)loadUserHeaderInfo
{
    //头像
    _userHeaderImage=[[AtzcUserHeaderView alloc] init];
    _userHeaderImage.frame=CGRectMake(50, 30, 100, 100);
    [_userHeaderImage setHeadImage:self.userModel.Header];
    _userHeaderImage.userInteractionEnabled =YES;
    //添加点击事件
    UITapGestureRecognizer *tapGestureHead = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(meAtzc)]autorelease];
    [_userHeaderImage addGestureRecognizer:tapGestureHead];
    
    [self.view addSubview:_userHeaderImage];
    
    //头像右侧的箭头
    UIImageView *userHeaderInfo=[[UIImageView alloc] initWithFrame:CGRectMake(_userHeaderImage.right+8, _userHeaderImage.top+_userHeaderImage.height/2-8, 8, 16)];
    userHeaderInfo.image=[UIImage imageNamed:@"icon_detail"];
    [self.view addSubview:userHeaderInfo];
    [userHeaderInfo release];
    
    //用户名
    UILabel *userLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, _userHeaderImage.bottom+3, ScreenWidth-120, 30)] autorelease];
    userLabel.backgroundColor=[UIColor clearColor];
    userLabel.textColor=Color(182, 182, 182, 1);
    userLabel.textAlignment=NSTextAlignmentCenter;
    userLabel.text=self.userModel.UserName;
    userLabel.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGestureName = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(meAtzc)]autorelease];
    [userLabel addGestureRecognizer:tapGestureName];
    
    [self.view addSubview:userLabel];
    
}

//加载服务列表表格视图
-(void)loadservicesListTableView
{
    _servicesListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 20+_userHeaderImage.bottom+30, ScreenWidth, ScreenHeight-20-_userHeaderImage.height-_userHeaderImage.top-_servicesListTableView.top-_bottomBarWarpView.height-60-25)];
    _servicesListTableView.dataSource=self;
    _servicesListTableView.delegate=self;
    _servicesListTableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;//设置滚动条的颜色
    //服务菜单的背景颜色
    _servicesListTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbarbg"]];
    [_servicesListTableView setSeparatorColor:Color(21, 22, 20, 1)];
    
    //_servicesListTableView.rowHeight=100;//设置行高
    [self.view addSubview:_servicesListTableView];
}
//加载底部按钮栏
-(void)loadButtomBar
{
    //底部按钮背景
    _bottomBarWarpView=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth-100, 49)];
    _bottomBarWarpView.backgroundColor=Color(20, 20, 20, 1);
    [self.view addSubview:_bottomBarWarpView];
    
    //三个按钮
    NSArray *buttonicon=@[@"notification_icon.png",@"scan_code.png",@"setting_icon.png"];
    int width=0;
    for (int index=0; index<3; index++) {
        UIButton *bottomButton=[[UIButton alloc] initWithFrame:CGRectMake(15+width, 10, 30, 30)];
        bottomButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:buttonicon[index]]];
        bottomButton.tag=index;
        [bottomButton addTarget:self action:@selector(buttomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBarWarpView addSubview:bottomButton];
        [bottomButton release];
        width+=70;
    }
    
}
//底部按钮点击事件
-(void)buttomButtonClick:(UIButton *)button
{
    if (button.tag==0) {//第一个按钮是通知
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        NotificationViewController *notifViewController=[[NotificationViewController alloc] init];
        BaseNavigationController *NoticNav=[[BaseNavigationController alloc] initWithRootViewController:notifViewController];
        [notifViewController release];
        [[self mmDrawerController] setCenterViewController:NoticNav withCloseAnimation:YES completion:nil];
    }
    else if(button.tag==1)//第二个为扫码
    {
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        QRCodeScanViewController *qrcodeViewController=[[QRCodeScanViewController alloc] init];
        BaseNavigationController *QrCodeNav=[[BaseNavigationController alloc] initWithRootViewController:qrcodeViewController];
        [qrcodeViewController release];
        [[self mmDrawerController] setCenterViewController:QrCodeNav withCloseAnimation:YES completion:nil];
    }
    else//第三个是设置
    {
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        SettingViewController *setViewController=[[SettingViewController alloc] init];
        BaseNavigationController *setNav=[[BaseNavigationController alloc] initWithRootViewController:setViewController];
        [setViewController release];
        [[self mmDrawerController] setCenterViewController:setNav withCloseAnimation:YES completion:nil];
    }
}


#pragma mark - 表格视图代理
//两行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}
//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"cell";//创建一个静态标示符
    //通过表示符判断是否有闲置的单元格
    ServicesListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {//如果没有创建单元格就创建他
        cell=[[[ServicesListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    //整理单元格数据
    NSArray *servicesTitle=@[@"朋友圈",@"房   产",@"汽   车",@"美   食",@"招   聘",@"新   闻",@"购   物",@"团   购",@"信   息",@"论   坛",@"视   频",@"图   片",@"商   家"];
    NSArray *servicesImg=@[@"dyn_icon.png",@"house_icon.png",@"auto_icon.png",@"food_icon.png",@"job_icon.png",@"news_icon.png",@"shopping_icon.png",@"groupbuy_icon.png",@"csinfo_icon.png",@"bbs_icon.png",@"video_icon.png",@"pic_icon.png",@"cmp_icon.png"];
    
    cell.Title=servicesTitle[indexPath.row];
    cell.Img=servicesImg[indexPath.row];
    cell.imgView.frame=CGRectMake(20, 14, 25, 20);
    
    cell.badgeMarginRight=120.0f;
    if (indexPath.row==2||indexPath.row==4) {
        cell.badgeString = @"12";
        cell.badge.badgeStringColor=[UIColor whiteColor];
        cell.badgeColor = Color(233, 64, 67, 1);
        cell.badgeColorHighlighted=Color(233, 64, 67, 1);
        cell.badge.radius = 9;
    }
    
    
    cell.backgroundColor=[UIColor clearColor];
    cell.separatorInset=UIEdgeInsetsFromString(@"2");
    return cell;
}

//点击单元格切换ddMenu的rootview
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {//朋友圈
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        FriendDynViewController *friendDynViewController=[[FriendDynViewController alloc] init];
        BaseNavigationController *fridenDynNav=[[BaseNavigationController alloc] initWithRootViewController:friendDynViewController];
        [friendDynViewController release];
        [[self mmDrawerController] setCenterViewController:fridenDynNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 1) {//房产
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        HouseMainViewController *houseMainVC=[[HouseMainViewController alloc] init];
        BaseNavigationController *houseNav=[[BaseNavigationController alloc] initWithRootViewController:houseMainVC];
        [houseMainVC release];
        [[self mmDrawerController] setCenterViewController:houseNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 2) {//汽车
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        AutoMainViewController *autoMainVC=[[AutoMainViewController alloc] init];
        BaseNavigationController *autoNav=[[BaseNavigationController alloc] initWithRootViewController:autoMainVC];
        [autoMainVC release];
        [[self mmDrawerController] setCenterViewController:autoNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 3) {//美食
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        FoodMainViewController *foodMainVC=[[FoodMainViewController alloc] init];
        BaseNavigationController *foodNav=[[BaseNavigationController alloc] initWithRootViewController:foodMainVC];
        [foodMainVC release];
        [[self mmDrawerController] setCenterViewController:foodNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 4) {//招聘
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        JobMainViewController *jobMainVC=[[JobMainViewController alloc] init];
        BaseNavigationController *jobNav=[[BaseNavigationController alloc] initWithRootViewController:jobMainVC];
        [jobMainVC release];
        [[self mmDrawerController] setCenterViewController:jobNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 5) {//新闻
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        NewsTabViewController *newsTabViewController=[[NewsTabViewController alloc] init];
        BaseNavigationController *newsNav=[[BaseNavigationController alloc] initWithRootViewController:newsTabViewController];
        [newsTabViewController release];
        [[self mmDrawerController] setCenterViewController:newsNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 6) {//购物
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        ShoppingMainViewController *shoppingMainVC=[[ShoppingMainViewController alloc] init];
        BaseNavigationController *shoppingNav=[[BaseNavigationController alloc] initWithRootViewController:shoppingMainVC];
        [shoppingMainVC release];
        [[self mmDrawerController] setCenterViewController:shoppingNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 7) {//团购
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        GroupBuyMainViewController *groupbuyMainVC=[[GroupBuyMainViewController alloc] init];
        BaseNavigationController *groupbuyNav=[[BaseNavigationController alloc] initWithRootViewController:groupbuyMainVC];
        [groupbuyMainVC release];
        [[self mmDrawerController] setCenterViewController:groupbuyNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 8) {//分类信息
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        CsInfoListViewController *csinfolistViewController=[[CsInfoListViewController alloc] init];
        BaseNavigationController *csinfoNav=[[BaseNavigationController alloc] initWithRootViewController:csinfolistViewController];
        [csinfolistViewController release];
        [[self mmDrawerController] setCenterViewController:csinfoNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 9) {//论坛
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        BBSMainViewController *bbsMainVC=[[BBSMainViewController alloc] init];
        BaseNavigationController *bbsNav=[[BaseNavigationController alloc] initWithRootViewController:bbsMainVC];
        [bbsMainVC release];
        [[self mmDrawerController] setCenterViewController:bbsNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 10) {//视频
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        VideoMainViewController *videoMainVC=[[VideoMainViewController alloc] init];
        BaseNavigationController *videoNav=[[BaseNavigationController alloc] initWithRootViewController:videoMainVC];
        [videoMainVC release];
        [[self mmDrawerController] setCenterViewController:videoNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 11) {//图片
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        PicMainViewController *picMainVC=[[PicMainViewController alloc] init];
        BaseNavigationController *picNav=[[BaseNavigationController alloc] initWithRootViewController:picMainVC];
        [picMainVC release];
        [[self mmDrawerController] setCenterViewController:picNav withCloseAnimation:YES completion:nil];
    }
    if (indexPath.row == 12) {//商家
        //先销毁其他的主视图
        [[self mmDrawerController].centerViewController release];
        
        CmpListViewController *cmplistViewController=[[CmpListViewController alloc] init];
        BaseNavigationController *cmpNav=[[BaseNavigationController alloc] initWithRootViewController:cmplistViewController];
        [cmplistViewController release];
        [[self mmDrawerController] setCenterViewController:cmpNav withCloseAnimation:YES completion:nil];
    }
    
}

//我在诸城
-(void)meAtzc
{
    //先销毁其他的主视图
    [[self mmDrawerController].centerViewController release];
    //创建主视图为mevc
    MeViewController *meViewController=[[MeViewController alloc] init];
    BaseNavigationController *meNav=[[BaseNavigationController alloc] initWithRootViewController:meViewController];
    [meViewController release];
    [[self mmDrawerController] setCenterViewController:meNav withCloseAnimation:YES completion:nil];     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [_userHeaderImage release];_userHeaderImage=nil;
    [_bottomBarWarpView release];_bottomBarWarpView=nil;
}

@end
