//
//  MeViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "MeViewController.h"
#import "MeServiceView.h"
#import "MyShoppingShareViewController.h"
#import "MyShoppingViewController.h"
#import "MyGroupBuyViewController.h"
#import "MyVideoViewController.h"
#import "MyCsInfoViewController.h"
#import "MyCollectViewController.h"
#import "MyResumeViewController.h"
#import "MyAlbumViewController.h"
#import "MyProfileViewController.h"
#import "FriendViewController.h"
#import "ReceiveGoodAddressViewController.h"
#import "BindMobileViewController.h"
#import "TDBadgedCell.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"我在诸城";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//初始化视图
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//初始化视图
-(void)initUI
{
    UIScrollView *mainScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
    mainScrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight*1);
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:mainScrollView];
    [mainScrollView release];
    //用户信息
    UIButton *userInfoWarp=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    userInfoWarp.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"userInfoWarpBg"]];
    
    [userInfoWarp addTarget:self action:@selector(profileSet) forControlEvents:UIControlEventTouchUpInside];
    
    [mainScrollView addSubview:userInfoWarp];
    //头像
    AtzcUserHeaderView *userhead=[[AtzcUserHeaderView alloc] initWithFrame:CGRectMake(10, 80/2.0-50/2.0, 50, 50)];
    [userhead setHeadImage:self.userModel.Header];
    [userInfoWarp addSubview:userhead];
    [userhead release];
    //姓名
    UILabel *userNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(userhead.right+15, userhead.top, 200, 30)];
    userNameLabel.text=self.userModel.UserName;
    userNameLabel.font=[UIFont systemFontOfSize:14];
    [userInfoWarp addSubview:userNameLabel];
    [userNameLabel release];
    //账号
    UILabel *userAccountLabel=[[UILabel alloc] initWithFrame:CGRectMake(userNameLabel.left, userNameLabel.bottom, userNameLabel.width, 12)];
    userAccountLabel.text=self.userModel.UserAccount;
    userAccountLabel.textColor=[UIColor grayColor];
    userAccountLabel.font=[UIFont systemFontOfSize:12];
    [userInfoWarp addSubview:userAccountLabel];
    [userAccountLabel release];
    //详情标志
    UIImageView *detailImage=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, userInfoWarp.height/2.0-26/2.0, 12, 26)];
    detailImage.image=[UIImage imageNamed:@"icon_detail"];
    [userInfoWarp addSubview:detailImage];
    [detailImage release];
    
    [userInfoWarp release];
    
    
    //用户服务列表
    UIScrollView *userServicesScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(userInfoWarp.left, userInfoWarp.bottom, userInfoWarp.width, 70)];
    
    userServicesScroll.backgroundColor=Color(240, 240, 240, 1);
    [userServicesScroll setShowsHorizontalScrollIndicator:NO];
    [userServicesScroll setShowsVerticalScrollIndicator:NO];
    [userServicesScroll setClipsToBounds:YES];//设置内容区域
    
    //配置scrollview
    [userServicesScroll setBounces:YES];
    [userServicesScroll setBouncesZoom:NO];//不放大缩小
    
    NSArray *meServicesIcon=@[@"myShopping",@"myShopping",@"myShopping",@"myCollect",@"myResume",@"myCsinfo",@"myVideo",@"myPhoto"];
    NSArray *meServicesTitle=@[@"消费分享",@"我的购物",@"我的团购",@"我的收藏",@"我的简历",@"我的信息",@"我的视频",@"我的相册"];
    int meServicesWidth=0;
    for (int i=0; i<8; i++) {
        MeServiceView *meServiceView=[[MeServiceView alloc] initWithFrame:CGRectMake(meServicesWidth+4, 0, 80, 70)];
        meServiceView.stricon=meServicesIcon[i];
        meServiceView.strtitle=meServicesTitle[i];
        meServiceView.tag=i;
        //添加点击事件
        [meServiceView addTarget:self action:@selector(selectService:) forControlEvents:UIControlEventTouchUpInside];
        [userServicesScroll addSubview:meServiceView];
        [meServiceView release];
        if (i!=7) {
            UIView *spaceLine=[[UIView alloc] initWithFrame:CGRectMake(meServicesWidth+80+2, 10, 1, 50)];
            spaceLine.backgroundColor=Color(220, 220, 220, 1);
            [userServicesScroll addSubview:spaceLine];
            [spaceLine release];
        }
        meServicesWidth+=80;
    }
    
    userServicesScroll.contentSize=CGSizeMake(meServicesWidth+10, userServicesScroll.height);
    [mainScrollView addSubview:userServicesScroll];
    [userServicesScroll release];
    
    
    //用户表格
    userTable=[[UITableView alloc] initWithFrame:CGRectMake(0, userServicesScroll.bottom+10, ScreenWidth, 260)];
    userTable.dataSource=self;
    userTable.delegate=self;
    userTable.backgroundColor=[UIColor clearColor];
    [mainScrollView addSubview:userTable];
    
}

//个人信息
-(void)profileSet
{
    MyProfileViewController *myProfileVC=[[MyProfileViewController alloc] init];
    [self.navigationController pushViewController:myProfileVC animated:YES];
    [myProfileVC release];
}

//服务按钮点击
-(void)selectService:(MeServiceView *) meServiceView
{
    if (meServiceView.tag==0) {//消费分享
        MyShoppingShareViewController *myShoppingShareVC=[[MyShoppingShareViewController alloc] init];
        [self.navigationController pushViewController:myShoppingShareVC animated:YES];
        [myShoppingShareVC release];
    }
    else if(meServiceView.tag==1)//购物
    {
        MyShoppingViewController *myShoppingVC=[[MyShoppingViewController alloc] init];
        [self.navigationController pushViewController:myShoppingVC animated:YES];
        [myShoppingVC release];
    }
    else if(meServiceView.tag==2)//团购
    {
        MyGroupBuyViewController *myGroupBuyVC=[[MyGroupBuyViewController alloc] init];
        [self.navigationController pushViewController:myGroupBuyVC animated:YES];
        [myGroupBuyVC release];
    }
    else if(meServiceView.tag==3)//收藏
    {
        MyCollectViewController *myCollectVC=[[MyCollectViewController alloc] init];
        [self.navigationController pushViewController:myCollectVC animated:YES];
        [myCollectVC release];
    }
    else if(meServiceView.tag==4)//简历
    {
        MyResumeViewController *myResumeVC=[[MyResumeViewController alloc] init];
        [self.navigationController pushViewController:myResumeVC animated:YES];
        [myResumeVC release];
    }
    else if(meServiceView.tag==5)//信息
    {
        MyCsInfoViewController *myCsInfoVC=[[MyCsInfoViewController alloc] init];
        [self.navigationController pushViewController:myCsInfoVC animated:YES];
        [myCsInfoVC release];
    }
    else if(meServiceView.tag==6)//视频
    {
        MyVideoViewController *myVideoVC=[[MyVideoViewController alloc] init];
        [self.navigationController pushViewController:myVideoVC animated:YES];
        [myVideoVC release];
    }
    else if(meServiceView.tag==7)//相册
    {
        MyAlbumViewController *myAlbumVC=[[MyAlbumViewController alloc] init];
        [self.navigationController pushViewController:myAlbumVC animated:YES];
        [myAlbumVC release];
    }
}

#pragma mark    表格代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

//绘制每个表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"mecell";//创建一个静态标示符
    //通过表示符判断是否有闲置的单元格
    TDBadgedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {//如果没有创建单元格就创建他
        cell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    
    if (indexPath.row == 0){
        cell.textLabel.text = @"我的主页";
        cell.detailTextLabel.text = @"我在诸城的主页";
        cell.badgeString = @"4";
    }
    if (indexPath.row == 1){
        cell.textLabel.text = @"我的好友";
        cell.detailTextLabel.text = @"我在诸城的好友";
        cell.badgeString = @"10";
    }
    if (indexPath.row == 2){
        cell.textLabel.text = @"我的银行卡";
        cell.detailTextLabel.text = @"我绑定的付款账号";
        cell.badgeString = @"2";
    }
    if (indexPath.row == 3){
        cell.textLabel.text = @"收货地址";
        cell.detailTextLabel.text = @"我的收货地址";
        cell.badgeString = @"繁荣广场1号楼三单元1601室";
    }
    if (indexPath.row == 4){
        cell.textLabel.text = @"已经绑定手机";
        cell.detailTextLabel.text = @"绑定的手机号码";
        cell.badgeString = @"15589672395";
    }
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor=[UIColor grayColor];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.badgeColor = [UIColor clearColor];
    cell.badge.badgeStringColor=[UIColor grayColor];
    
    cell.backgroundColor=[UIColor clearColor];

    return cell;
    
}
//点击某个好友
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {//我的主页
        FriendViewController *friendCtrl = [[FriendViewController alloc] init];
        friendCtrl.userFriendModel=self.userModel;
        [self.navigationController pushViewController:friendCtrl animated:YES];
        [friendCtrl release];
    }
    if (indexPath.row==1) {//好友列表
        [[self mmDrawerController] openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }
    if (indexPath.row==2) {//银行卡
        
    }
    if (indexPath.row==3) {//收货地址
        ReceiveGoodAddressViewController *receiveGoodAddressCtrl = [[ReceiveGoodAddressViewController alloc] init];
        [self.navigationController pushViewController:receiveGoodAddressCtrl animated:YES];
        [receiveGoodAddressCtrl release];

    }
    if (indexPath.row==4) {//绑定手机
        BindMobileViewController *bindMobileCtrl = [[BindMobileViewController alloc] init];
        [self.navigationController pushViewController:bindMobileCtrl animated:YES];
        [bindMobileCtrl release];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [userTable release];userTable=nil;
}

@end
