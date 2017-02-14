//
//  BaseViewController.m
//  所有视图控制器的基类 如果需要有返回按钮就在导航栏添加 返回按钮 按钮样式通过主题工厂创建
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "AppDelegate.h"
#import "UIFactory.h"
#import "LoginViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

//初始化用户对象
- (void)initUserModel {
    
    _userModel = [[UserModel alloc] init];
    
    //如果userdefaults中没有用户信息 要求登录
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults valueForKey:kMY_USER_ID]==nil||[standardUserDefaults valueForKey:kMY_USER_NICKNAME]==nil||[standardUserDefaults valueForKey:kMY_USER_ACCOUNT]==nil) {
        //退到登录页面
        [((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController) popToRootViewControllerAnimated:YES];
    }
    else{
        _userModel.UserID=[standardUserDefaults objectForKey:kMY_USER_ID];
        _userModel.UserAccount=[standardUserDefaults objectForKey:kMY_USER_ACCOUNT];
        _userModel.UserName=[standardUserDefaults objectForKey:kMY_USER_NICKNAME];        
        _userModel.Header=[standardUserDefaults objectForKey:kMY_USER_Head];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //初始化用户对象
    [self initUserModel];
    
    self.view.backgroundColor=Color(250, 250, 250, 1);
    
    //导航控制器中的 视图控制器
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    //如果导航控制中包含多个视图控制器，并且显示返回按钮
    if (viewControllers.count > 1 && self.isBackButton) {//创建返回按钮
        [self initBackButtonItem];
    }
    else if(viewControllers.count == 1)//如果导航控制器中只有一个视图控制器 创建抽屉按钮
    {
        [self initShowDDMenuLeftButtonItem];
        [self initShowDDMenuRightButtonItem];
    }
}

//创建返回按钮
-(void)initBackButtonItem
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back.png"];
    button.frame = CGRectMake(0, 0, 37, 24);
    //按钮添加动作
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.leftBarButtonItem = [backItem autorelease];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//重写
//设置导航栏上的标题
- (void)setTitle:(NSString *)title {
    [super setTitle:title];

    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark   ----触摸取消输入----
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc
{
    [super dealloc];   
}

@end
