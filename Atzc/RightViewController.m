//
//  RightViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "RightViewController.h"
#import "AtzcNetWorkServices.h"
#import "FriendListCell.h"
#import "FriendViewController.h"
#import "BaseNavigationController.h"
#import "MMDrawerController.h"
#import "ServicesListCell.h"
#import "AddFriendViewController.h"
#import "ASIHTTPRequest.h"
#import "SendMessageViewController.h"



@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark 视图加载

- (void)viewDidLoad
{
    [super viewDidLoad];
    //毛玻璃背景
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"leftMenuBg"]];
    //初始化搜索条
    [self initSearchView];
    
    //初始化好友列表表格
    [self initFriendListTableView];
    //异步从网络请求用户的好友列表
    [self RequestFriendList];
    //先从本地读取上次的数据
    //[self requestFailed:nil];
}


#pragma mark -私有方法

-(void)RequestFriendList
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/me/friendlist.ashx"]];
    //post参数
    [request setPostValue:self.userModel.UserID forKey:@"user_id"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求结束  应该将数据存到本地  如果网络请求失败就从本地取
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    //将下载的数据文件存储到本地
    [AtzcNetWorkServices WirteToJsonFile:@"FriendList.json" JsonData:responseData];
    //解析数据
    [self WarpJosnData:responseData];
}
//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"FriendList.json"];
    //解析数据
    [self WarpJosnData:jsonData];
}

-(void)WarpJosnData:(NSData *)jsonData
{
    //解析json
    //id resultFriends=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
    
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultFriends=[paser objectWithData:jsonData];
    
    NSArray *result=[resultFriends objectForKey:@"Friends"];
    
    //将数据添加到数组中
    _FriendListArray=[[NSMutableArray alloc] initWithCapacity:result.count];
    for (id data in result) {//便利数组 将数据的模型添加到 数组中
        UserModel *userModel=[UserModel  alloc];
        userModel.UserID     = [data objectForKey:@"UserID"];
        userModel.UserName   = [data objectForKey:@"UserName"];
        userModel.Header     = [data objectForKey:@"HeadImg"];
        userModel.UserAccount= [data objectForKey:@"UserAccount"];
        userModel.LatestMood = [data objectForKey:@"LatestMood"];
        [_FriendListArray addObject:userModel];
        [userModel release];
    }
    
    //数据接收完，刷新好友列表界面
    [self refreshFriendListTableUI];
}

//刷新表格UI
-(void)refreshFriendListTableUI
{
    [_friendListTableView reloadData];//列表视图重新加载数据
}

//初始化搜索
-(void)initSearchView
{
    UIView *searchViewWarp=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50+15)];
    searchViewWarp.layer.borderWidth=1.0f;
    searchViewWarp.layer.borderColor=[Color(22, 22, 22, 1) CGColor];
    [self.view addSubview:searchViewWarp];
    [searchViewWarp release];
}

//初始化好友列表表格
-(void)initFriendListTableView
{
    _friendListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 65, ScreenWidth, ScreenHeight-65)];
    _friendListTableView.dataSource=self;
    _friendListTableView.delegate=self;
    [_friendListTableView setSeparatorColor:Color(21, 21, 21, 1)];
    _friendListTableView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:_friendListTableView];
}

#pragma mark - 表格视图的代理
//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//返回组的标题
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section==1) {
//        return @"";
//    }
//    else{
//        return @"";
//    }
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
    sectionHeaderView.backgroundColor=Color(20, 20, 20, 1);
    if(section==1)
    {
        sectionHeaderView.frame=CGRectMake(0, 0, ScreenWidth, 20);
        
        
        UILabel *sectionLabel=[[UILabel  alloc] initWithFrame:CGRectMake(10, 4, 200, 16)];
        sectionLabel.text=@"我在诸城好友";
        sectionLabel.font=[UIFont systemFontOfSize:12];
        sectionLabel.textColor=[UIColor grayColor];
        [sectionHeaderView addSubview:sectionLabel];
        [sectionLabel release];
    }    
    return sectionHeaderView;
}
//单元格的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
#pragma mark - 表格视图的数据源
//表视图的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else
    {
        return _FriendListArray.count;//如果返回值为0或nil  cellforrowatindexpath不会执行
    }
}
//绘制每个表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString *cellIdentifier=@"addcell";//创建一个静态标示符
        //通过表示符判断是否有闲置的单元格
        ServicesListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {//如果没有创建单元格就创建他
            cell=[[ServicesListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.imgView.frame=CGRectMake(15, 10, 30, 30);
        cell.backgroundColor=[UIColor clearColor];
        cell.Title=@"添加好友";
        cell.Img=@"addfriend_icon.png";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.badgeMarginRight=10.0f;
        cell.badgeString = @"12";
        cell.badgeColor = Color(233, 64, 67, 1);
        cell.badgeColorHighlighted=Color(233, 64, 67, 1);
        cell.badge.radius = 9;
        cell.backgroundColor=[UIColor clearColor];
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"cell";//创建一个静态标示符
        //通过表示符判断是否有闲置的单元格
        FriendListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {//如果没有创建单元格就创建他
            cell=[[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.userModel=_FriendListArray[indexPath.row];
        cell.backgroundColor=[UIColor clearColor];
        
        return cell;
    }
}
//点击某个好友
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0&&indexPath.row==0) {
        AddFriendViewController *addFriendViewController=[[AddFriendViewController alloc] init];
        BaseNavigationController *addFriendNav=[[BaseNavigationController alloc] initWithRootViewController:addFriendViewController];
        [addFriendViewController release];
        [[self mmDrawerController] setCenterViewController:addFriendNav withCloseAnimation:YES completion:nil];
        
    }
    if (indexPath.section==1) {//如果是点击某个好友开始聊天窗口
        UserModel *userModel=_FriendListArray[indexPath.row];
        
        SendMessageViewController *sendMessageVC=[[SendMessageViewController alloc] init];
        sendMessageVC.chatPerson=userModel;
        BaseNavigationController *sendMessageNav=[[BaseNavigationController alloc] initWithRootViewController:sendMessageVC];
        [sendMessageVC release];
        [[self mmDrawerController] setCenterViewController:sendMessageNav withCloseAnimation:YES completion:nil];
    }
}
#pragma mark -内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
    [_FriendListArray release]; _FriendListArray=nil;
    [_friendListTableView release]; _friendListTableView=nil;    
}

@end
