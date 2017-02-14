//
//  QRCodeScanViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-20.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import "MMDrawerController.h"
#import "UIFactory.h"

@interface QRCodeScanViewController ()

@end

@implementation QRCodeScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"扫描查看折扣";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initScanVC];
    
    //导航控制器中的 视图控制器
    NSArray *viewControllers = self.navigationController.viewControllers;
    
    //如果导航控制中包含多个视图控制器，并且显示返回按钮
    if (viewControllers.count > 1 && self.isBackButton) {//创建返回按钮
        [self initBackButtonItem];
    }
    else if(viewControllers.count == 1)//如果导航控制器中只有一个视图控制器
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
    button.frame = CGRectMake(0, 0, 24, 24);
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


- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化扫描器
-(void)initScanVC
{
    self.readerDelegate=self;
    //非全屏
    self.wantsFullScreenLayout = NO;
    
    //隐藏底部控制按钮
    self.showsZBarControls = NO;
    
    //设置自己定义的界面
    [self setOverlayPickerView];
    //扫描器
    ZBarImageScanner *scanner = self.scanner;
    [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
}

//自定义扫描器界面
-(void)setOverlayPickerView
{
    //清除原有控件
    for (UIView *temp in [self.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }
    
    //画中间的基准线
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(40, 220, 240, 1)];
    line.backgroundColor = [UIColor redColor];
    [self.view addSubview:line];
    [line release];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    upView.alpha = 0.8;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(50, 10, ScreenWidth-100, 50);
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor grayColor];
    labIntroudction.font=[UIFont systemFontOfSize:12];
    labIntroudction.text=@"将二维码置于取景框内，扫描加好友，消费分享折扣购物等";
    labIntroudction.numberOfLines=2;
    [upView addSubview:labIntroudction];
    [labIntroudction release];
    
    UIView *topleft_view=[[UIView alloc] initWithFrame:CGRectMake(40-6, upView.bottom-6, 26, 6)];
    topleft_view.backgroundColor=[UIColor greenColor];
    [upView addSubview:topleft_view];
    [topleft_view release];
    
    UIView *topright_view=[[UIView alloc] initWithFrame:CGRectMake(280-20, upView.bottom-6, 26, 6)];
    topright_view.backgroundColor=[UIColor greenColor];
    [upView addSubview:topright_view];
    [topright_view release];
    
    [upView release];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 40, 240)];
    leftView.alpha = 0.8;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    UIView *lefttop_view=[[UIView alloc] initWithFrame:CGRectMake(leftView.right-6, 0, 6, 20)];
    lefttop_view.backgroundColor=[UIColor greenColor];
    [leftView addSubview:lefttop_view];
    [lefttop_view release];
    
    UIView *leftbottom_view=[[UIView alloc] initWithFrame:CGRectMake(leftView.right-6, leftView.bottom-upView.height-20, 6, 20)];
    leftbottom_view.backgroundColor=[UIColor greenColor];
    [leftView addSubview:leftbottom_view];
    [leftbottom_view release];
    
    [leftView release];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(280, 60, 60, 240)];
    rightView.alpha = 0.8;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    UIView *righttop_view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 20)];
    righttop_view.backgroundColor=[UIColor greenColor];
    [rightView addSubview:righttop_view];
    [righttop_view release];
    
    UIView *rightbottom_view=[[UIView alloc] initWithFrame:CGRectMake(0, rightView.bottom-upView.height-20, 6, 20)];
    rightbottom_view.backgroundColor=[UIColor greenColor];
    [rightView addSubview:rightbottom_view];
    [rightbottom_view release];
    
    [rightView release];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-268, 320, ScreenHeight-upView.height-leftView.height)];
    downView.alpha = 0.8;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    UIView *bottomleft_view=[[UIView alloc] initWithFrame:CGRectMake(40-6, 0, 26, 6)];
    bottomleft_view.backgroundColor=[UIColor greenColor];
    [downView addSubview:bottomleft_view];
    [bottomleft_view release];
    
    UIView *bottomright_view=[[UIView alloc] initWithFrame:CGRectMake(280-20, 0, 26, 6)];
    bottomright_view.backgroundColor=[UIColor greenColor];
    [downView addSubview:bottomright_view];
    [bottomright_view release];
    
    [downView release];     
}

//扫描器选择图片完成 扫描完成
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =[info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    //源扫描的图片
    //[info objectForKey: UIImagePickerControllerOriginalImage];
    
    //判断是否包含 头'http:'的正则表达式
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //扫描得到的结果
    //symbol.data
    
    //如果包含连接 提示对话框打开连接
    if ([predicate evaluateWithObject:symbol.data])
    {
        //继续判断是否为在诸城消费分享的连接
        if(false)
        {
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                            message:@"It will use the browser to this URL。"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:@"Ok", nil];
            alert.delegate = self;
            alert.tag=1;
            [alert show];
            [alert release];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
