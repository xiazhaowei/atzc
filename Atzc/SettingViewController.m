//
//  SettingViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "SettingViewController.h"
#import "MyProfileViewController.h"
#import "ThemeViewController.h"
#import "AboutViewController.h"
#import "UIFactory.h"
#import "FriendDynViewController.h"
#import "BaseNavigationController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"设置";
        //self.view.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

//加载服务列表表格视图
-(void)loadSettingListTableView
{
    _settingListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _settingListTableView.dataSource=self;
    _settingListTableView.delegate=self;
    _settingListTableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;//设置滚动条的颜色
    //服务菜单的背景颜色
    _settingListTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbarbg"]];
    [_settingListTableView setSeparatorColor:Color(214, 214, 214, 1)];
    
    //_settingListTableView.rowHeight=100;//设置行高
    [self.view addSubview:_settingListTableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_settingListTableView reloadData];
}

#pragma mark - 表格视图代理
//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//返回组的标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

//两行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==2) {
        return 1;
    }
    else
    {
        return 2;
    }
}
//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section!=2)
    {
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        NSArray *settingUserText=@[@"个人信息",@"主题"];
        NSArray *settingUserImg=@[@"yellostar.png",@"yellostar.png"];
        
        NSArray *settingAboutText=@[@"意见反馈",[@"关于" stringByAppendingString:MySiteName]];
        NSArray *settingAboutImg=@[@"yellostar.png",@"yellostar.png"];
        
        NSArray *settingGroup=@[settingUserText,settingAboutText];
        NSArray *settingImgGroup=@[settingUserImg,settingAboutImg];
        
        
        cell.textLabel.text = settingGroup[indexPath.section][indexPath.row];//文字
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//进入箭头
        cell.imageView.image=[UIImage imageNamed:settingImgGroup[indexPath.section][indexPath.row]];//图标
        cell.backgroundColor=[UIColor whiteColor];
        
        return cell;
    }
    else{
        UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        cell.textLabel.text = @"退出";//文字
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//进入箭头
        return cell;
    }
}
//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0 && indexPath.row == 0) {//个人设置
        MyProfileViewController *profileCtrl = [[[MyProfileViewController alloc] init] autorelease];
        [self.navigationController pushViewController:profileCtrl animated:YES];
        
    }
    if (indexPath.section==0 && indexPath.row == 1) {//主题
        ThemeViewController *themeCtrl = [[[ThemeViewController alloc] init] autorelease];
        [self.navigationController pushViewController:themeCtrl animated:YES];
        
    }
    else if(indexPath.section==1 && indexPath.row == 1)//关于
    {
        AboutViewController *aboutCtrl = [[[AboutViewController alloc] init] autorelease];
        [self.navigationController pushViewController:aboutCtrl animated:YES];
        
    }
    else if(indexPath.section==2&&indexPath.row==0)//退出
    {
        //通知IM系统下线
        //取消本地登录信息
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kMY_USER_ID];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kMY_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kMY_USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kMY_USER_Head];
        //立刻保存信息
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //XMPP下线
        if([[AtzcXMPPManager sharedInstance] connect])
            [[AtzcXMPPManager sharedInstance] disconnect];
        
        //进入登录页面
        [((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) popToRootViewControllerAnimated:YES];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
	// Do any additional setup after loading the view.
    [self loadSettingListTableView];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
    [_settingListTableView release];
    _settingListTableView=nil;
}

@end
