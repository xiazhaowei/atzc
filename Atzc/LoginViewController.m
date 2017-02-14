//
//  LoginViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-11.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "LoginViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "FriendDynViewController.h"
#import "BaseNavigationController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "RegisterViewController.h"
#import "AtzcXMPPManager.h"

#import "IQKeyBoardManager.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //_userPassword.delegate=self;
    //添加上一个下一个和确定按钮事件
    //[_userPassword addPreviousNextDoneOnKeyboardWithTarget:self previousAction:@selector(previousClicked:) nextAction:@selector(nextClicked:) doneAction:@selector(doneClicked:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //判断用户是否已经登录，如果登录直接进主界面
    if([[NSUserDefaults standardUserDefaults] valueForKey:kMY_USER_ID]!=nil&&[[NSUserDefaults standardUserDefaults] valueForKey:kMY_USER_ACCOUNT]!=nil&&[[NSUserDefaults standardUserDefaults] valueForKey:kMY_USER_NICKNAME]!=nil&&[[NSUserDefaults standardUserDefaults] valueForKey:kMY_USER_Head]!=nil)
    {
        //进入主界面
        [self ToMainDDMenuController];
    }
}

#pragma mark 按钮事件
//注册按钮事件®
- (IBAction)registerAccount:(id)sender {
    
    RegisterViewController *registerView=[[[RegisterViewController alloc]init]autorelease];
    UINavigationController *regNav=[[[UINavigationController alloc]initWithRootViewController:registerView]autorelease];
    [regNav.navigationBar setTintColor:[UIColor blackColor]];
    
    [registerView.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRegister:)]autorelease]];    
    
    [registerView.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:registerView action:@selector(nextStep:)]autorelease]];
    
    [self.navigationController presentViewController:regNav animated:YES completion:^{
        //
    }];
}

//取消注册
-(void)cancelRegister:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

//登录按钮
- (IBAction)startLogin:(id)sender {
    
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/me/login.ashx"]];
    //post参数
    [request setPostValue:_userLoginName.text forKey:@"username"];
    [request setPostValue:_userPassword.text forKey:@"password"];
    [request setPostValue:[[[UIDevice currentDevice]systemName]stringByAppendingString:[[UIDevice currentDevice]systemVersion]] forKey:@"deviceInfo"];
    [request setDelegate:self];
    //请求代理  结束  或失败
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
    
    //添加指示层
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"正在登录"];
    
}




#pragma mark  -------网络请求回调----------
//请求成功
-(void)requestSuccess:(ASIFormDataRequest*)request
{
    [DejalBezelActivityView removeView];
    //id rootDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL];
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *rootDic=[paser objectWithData:request.responseData];
    int resultCode=[[rootDic objectForKey:@"ResultCode"]intValue];
    
    if (resultCode==1) {
        //保存账号信息
        NSDictionary *userDic=[rootDic objectForKey:@"Data"];
        
        [[NSUserDefaults standardUserDefaults]setObject:[userDic objectForKey:@"UserID"] forKey:kMY_USER_ID];
        [[NSUserDefaults standardUserDefaults]setObject:_userPassword.text forKey:kMY_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults]setObject:[userDic objectForKey:@"UserName"] forKey:kMY_USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults]setObject:[userDic objectForKey:@"UserAccount"] forKey:kMY_USER_ACCOUNT];
        [[NSUserDefaults standardUserDefaults]setObject:[userDic objectForKey:@"HeadImg"] forKey:kMY_USER_Head];
        
        //立刻保存信息
        [[NSUserDefaults standardUserDefaults]synchronize];        
        
        //进入主界面
        [self ToMainDDMenuController];
    }else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [av show];
        [av release];
    }
}
//进入主界面
-(void)ToMainDDMenuController
{
    //连接xmpp服务器上线
    [AtzcXMPPManager sharedInstance];
    
    //初始化主视图
    FriendDynViewController  *mainCtrl = [[FriendDynViewController alloc] init];
    BaseNavigationController  *mainNav=[[BaseNavigationController alloc] initWithRootViewController:mainCtrl];
    [mainCtrl release];
    LeftViewController *leftCtrl = [[LeftViewController alloc] init];
    RightViewController *rightCtrl = [[RightViewController alloc] init];
    
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:mainNav
                                             leftDrawerViewController:leftCtrl
                                             rightDrawerViewController:rightCtrl];
    [drawerController setMaximumRightDrawerWidth:280.0];
    [drawerController setMaximumLeftDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    
    
    //初始化左右菜单
//    DDMenuController *ddMenu = [[DDMenuController alloc] initWithRootViewController:mainNav];
//    ddMenu.leftViewController = leftCtrl;
//    ddMenu.rightViewController = rightCtrl;
    
    //进入主菜单
    [self.navigationController pushViewController:drawerController animated:YES];
    [drawerController release];
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request
{
    [DejalBezelActivityView removeView];
}

-(void)previousClicked:(UISegmentedControl*)segmentedControl
{
    //[(UITextField*)[self.view viewWithTag:selectedTextFieldTag-1] becomeFirstResponder];
}

-(void)nextClicked:(UISegmentedControl*)segmentedControl
{
    //[(UITextField*)[self.view viewWithTag:selectedTextFieldTag+1] becomeFirstResponder];
}

-(void)doneClicked:(UIBarButtonItem*)barButton
{
    [self.view endEditing:YES];
}

#pragma mark 文本框代理

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_userLoginName release];
    [_userLoginName release];
    [super dealloc];
}
@end
