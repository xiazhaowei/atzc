//
//  AboutViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-3.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "AboutViewController.h"
#import "BaseWebViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=[@"关于" stringByAppendingString:MySiteName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //顶部的在诸城图标
    [self initAtzcCenterIcon];
    //关于我们的表格列表
    [self initAboutTableListView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UITableView *tableview=(UITableView *)[self.view viewWithTag:1];
    [tableview reloadData];
}
//顶部的在诸城图标
-(void)initAtzcCenterIcon
{
    UIImageView *atzcIcon=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-100/2.0, 30, 100, 100)];
    atzcIcon.image=[UIImage imageNamed:@"about_logo.png"];
    [self.view addSubview:atzcIcon];
    [atzcIcon release];
}
//关于我们的表格列表
-(void)initAboutTableListView
{
    UITableView *tableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 150, ScreenWidth, 130)];
    tableview.dataSource=self;
    tableview.tag=1;
    tableview.delegate=self;
    //tableview.layer.borderWidth=1;//边框宽度
    //[tableview.layer setCornerRadius:10.0f];//边框圆角
    //tableview.layer.borderColor=[Color(220, 220, 220, 1) CGColor];//边框颜色
    [tableview setScrollEnabled:NO];//表格不可滑动
    [self.view addSubview:tableview];
    [tableview release];
}

#pragma mark - 表格视图代理
//两行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];    
    NSArray *settingAboutText=@[@"版本更新",@"功能介绍",@"帮助与反馈"];
    
    cell.textLabel.text = settingAboutText[indexPath.row];//文字
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//进入箭头
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==2)
    {
        BaseWebViewController *webViewCtrl = [[BaseWebViewController alloc] init];
        webViewCtrl.title=@"帮助与反馈";
        [webViewCtrl loadWebPageWithString:@"http://www.atzc.net"];
        [self.navigationController pushViewController:webViewCtrl animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
