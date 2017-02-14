//
//  NewsMainViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-27.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "NewsTabViewController.h"
#import "NewsListViewController.h"
#import "BaseNavigationController.h"
#import "UIFactory.h"
#import "ThemeButton.h"
#import "MMDrawerController.h"

@interface NewsTabViewController ()

@end

@implementation NewsTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"诸城新闻";
        [self.tabBar setHidden:YES];//隐藏自带的工具栏
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=Color(250, 250, 250, 1);
	
    [self initShowDDMenuLeftButtonItem];
    [self initShowDDMenuRightButtonItem];
    
    //创建自定义tabBar
    [self initTabbarView];
    //初始化子控制器
    [self initViewControllers];
    
    //首先选择第一个菜单
    [_horizMenu setSelectedIndex:0 animated:YES];
}

//拉开左侧抽屉按钮
-(void)initShowDDMenuLeftButtonItem
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"side_nlnr_icon.png" highlighted:@"side_nlnr_icon.png"];
    button.backgroundColor=[UIColor clearColor];
    button.frame = CGRectMake(0, 0, 24, 19);
    //按钮添加动作
    [button addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.leftBarButtonItem = [backItem autorelease];
}
//拉开右侧抽屉按钮
-(void)initShowDDMenuRightButtonItem
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"friendls_icon.png" highlighted:@"friendls_icon.png"];
    button.backgroundColor=[UIColor clearColor];
    button.frame = CGRectMake(0, 0, 24, 19);
    //按钮添加动作
    [button addTarget:self action:@selector(rightDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.rightBarButtonItem = [backItem autorelease];
}

//获得mmDrawerController
-(MMDrawerController *)mmDrawerController
{
    MMDrawerController *ddmenu=(MMDrawerController *)(((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers[1]);
    return ddmenu;
}

#pragma mark - Button Handlers 切换抽屉状态
-(void)leftDrawerButtonPress:(id)sender{
    [[self mmDrawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [[self mmDrawerController] toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

//创建自定义tabBar
- (void)initTabbarView
{     
    _menuItems = [[NSMutableArray alloc] initWithArray:@[@"政务新闻",@"今日视点",@"社会综合",@"综合商讯",@"房产资讯",@"招聘动态",@"汽车动态"]];
    
    _menuClass=[[NSDictionary alloc] initWithObjects:@[@"5",@"7",@"8",@"11",@"6",@"8",@"9"] forKeys:_menuItems];
    _horizMenu=[[MKHorizMenu alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    _horizMenu.titles=_menuItems;
    _horizMenu.dataSource=self;
    _horizMenu.itemSelectedDelegate=self;
    
    [self.view addSubview:_horizMenu];
    
    [_horizMenu reloadData];
}

//初始化子控制器
-(void)initViewControllers
{
    NSMutableArray *viewControllers=[[NSMutableArray alloc] init];
    for (NSString *classname in _menuItems) {
        NewsListViewController *newsListVC = [[[NewsListViewController alloc] init] autorelease];
        newsListVC.ClassID=[[_menuClass objectForKey:classname] intValue];
        BaseNavigationController *newsListNav=[[BaseNavigationController alloc] initWithRootViewController:newsListVC];
        [viewControllers addObject:newsListNav];
    }
    self.viewControllers=viewControllers;
}


#pragma mark 水平菜单数据
- (UIImage*) selectedItemImageForMenu:(MKHorizMenu*) tabMenu
{
    return [[UIImage imageNamed:@"ButtonSelected"] stretchableImageWithLeftCapWidth:16 topCapHeight:0];
}

- (UIColor*) backgroundColorForMenu:(MKHorizMenu *)tabView
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"MenuBar"]];
}

- (int) numberOfItemsForMenu:(MKHorizMenu *)tabView
{
    return [_menuItems count];
}

- (NSString*) horizMenu:(MKHorizMenu *)horizMenu titleForItemAtIndex:(NSUInteger)index
{
    return [_menuItems objectAtIndex:index];
}

//点击菜单切换视图
-(void) horizMenu:(MKHorizMenu *)horizMenu itemSelectedAtIndex:(NSUInteger)index
{
    self.selectedIndex = index;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [_horizMenu release];_horizMenu=nil;
    [_menuItems release];_menuItems=nil;
    [_menuClass release];_menuClass=nil;
}

@end
