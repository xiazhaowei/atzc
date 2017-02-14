//
//  AddReceiveGoodAddressViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-31.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "AddReceiveGoodAddressViewController.h"
#import "UIPlaceHolderTextView.h"
#import "SSCheckBoxView.h"
#import "UIFactory.h"

@interface AddReceiveGoodAddressViewController ()

@end

@implementation AddReceiveGoodAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"新建收货地址";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//初始化视图
    [self initSubView];
    //初始化添加按钮
    [self initSaveBotton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置值
    [self setTextValue];
}

//初始化视图
-(void)initSubView
{
    mainScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
    mainScrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
    mainScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:mainScrollView];
    
    //填写收货人地址
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 130, 30)];
    title.text=@"填写收货人信息";
    title.font=[UIFont boldSystemFontOfSize:15];
    [mainScrollView addSubview:title];
    [title release];
    
    //分割线
    UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(0, title.bottom, ScreenWidth, 1)];
    line1.backgroundColor=Color(233, 233, 233, 1);
    [mainScrollView addSubview:line1];
    [line1 release];
    //收货人
    UILabel *receiverNameTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, line1.bottom+5, 110, 30)];
    receiverNameTitle.text=@"姓名：";
    receiverNameTitle.font=[UIFont boldSystemFontOfSize:15];
    receiverNameTitle.textAlignment=NSTextAlignmentRight;
    [mainScrollView addSubview:receiverNameTitle];
    [receiverNameTitle release];
    //收货人文本框
    textReceiverName=[[UITextField alloc] initWithFrame:CGRectMake(receiverNameTitle.right, receiverNameTitle.top, 180, 30)];
    textReceiverName.borderStyle=UITextBorderStyleRoundedRect;
    textReceiverName.placeholder=@"最少两个字";
    [mainScrollView addSubview:textReceiverName];
    
    //分割线
    UIView *line2=[[UIView alloc] initWithFrame:CGRectMake(0, receiverNameTitle.bottom+5, ScreenWidth, 1)];
    line2.backgroundColor=Color(233, 233, 233, 1);
    [mainScrollView addSubview:line2];
    [line2 release];
    //收货人电话
    UILabel *receiverMobileTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, line2.bottom+5, receiverNameTitle.width, 30)];
    receiverMobileTitle.text=@"手机号码：";
    receiverMobileTitle.font=[UIFont boldSystemFontOfSize:15];
    receiverMobileTitle.textAlignment=NSTextAlignmentRight;
    [mainScrollView addSubview:receiverMobileTitle];
    [receiverMobileTitle release];
    //收货人电话
    textReceiverMobile=[[UITextField alloc] initWithFrame:CGRectMake(receiverMobileTitle.right, receiverMobileTitle.top, textReceiverName.width, 30)];
    textReceiverMobile.borderStyle=UITextBorderStyleRoundedRect;
    textReceiverMobile.placeholder=@"不少于7位";
    textReceiverMobile.keyboardType=UIKeyboardTypeNumberPad;
    [mainScrollView addSubview:textReceiverMobile];
    
    //分割线
    UIView *line3=[[UIView alloc] initWithFrame:CGRectMake(0, receiverMobileTitle.bottom+5, ScreenWidth, 1)];
    line3.backgroundColor=Color(233, 233, 233, 1);
    [mainScrollView addSubview:line3];
    [line3 release];
    //地址
    UILabel *receiverAddressTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, line3.bottom+5, receiverNameTitle.width, 50)];
    receiverAddressTitle.text=@"详细地址：";
    receiverAddressTitle.font=[UIFont boldSystemFontOfSize:15];
    receiverAddressTitle.textAlignment=NSTextAlignmentRight;
    [mainScrollView addSubview:receiverAddressTitle];
    [receiverAddressTitle release];
    //收货人文本框
    
    textReceiverAddress=[[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(receiverAddressTitle.right, receiverAddressTitle.top, textReceiverName.width, 50)];
    textReceiverAddress.layer.borderWidth=1.0f;
    textReceiverAddress.layer.borderColor=[Color(223, 223, 223, 1) CGColor];
    [textReceiverAddress.layer setCornerRadius:3.0f];//边框圆角
    textReceiverAddress.placeholder=@"送货员能找到您的详细地址";
    [mainScrollView addSubview:textReceiverAddress];
    
    //分割线
    UIView *line4=[[UIView alloc] initWithFrame:CGRectMake(0, receiverAddressTitle.bottom+5, ScreenWidth, 1)];
    line4.backgroundColor=Color(233, 233, 233, 1);
    [mainScrollView addSubview:line4];
    [line4 release];
    //邮编
    UILabel *zipTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, line4.bottom+5, receiverNameTitle.width, 30)];
    zipTitle.text=@"邮编：";
    zipTitle.font=[UIFont boldSystemFontOfSize:15];
    zipTitle.textAlignment=NSTextAlignmentRight;
    [mainScrollView addSubview:zipTitle];
    [zipTitle release];
    //邮编
    textZip=[[UITextField alloc] initWithFrame:CGRectMake(zipTitle.right, zipTitle.top, textReceiverName.width, 30)];
    textZip.borderStyle=UITextBorderStyleRoundedRect;
    textZip.placeholder=@"6位邮编";
    textZip.keyboardType=UIKeyboardTypeNumberPad;
    [mainScrollView addSubview:textZip];
    
    //分割线
    UIView *line5=[[UIView alloc] initWithFrame:CGRectMake(0, zipTitle.bottom+5, ScreenWidth, 1)];
    line5.backgroundColor=Color(233, 233, 233, 1);
    [mainScrollView addSubview:line5];
    [line5 release];
    
    //默认地址
    checkboxDefaultAddress = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(20, line5.bottom+2, 200, 30) style:kSSCheckBoxViewStyleBox checked:NO];
    [checkboxDefaultAddress setText:@"设置成默认收货地址"];
    [mainScrollView addSubview:checkboxDefaultAddress];
    
}

-(void)setTextValue
{
    textReceiverName.text=_receiveGoodAddressModel.ReceiverName;
    textReceiverMobile.text=_receiveGoodAddressModel.ReceiverMobile;
    textReceiverAddress.text=_receiveGoodAddressModel.DetailAddress;
    textZip.text=_receiveGoodAddressModel.Zip;
    checkboxDefaultAddress.checked=_receiveGoodAddressModel.IsDefault;
}

//初始化添加按钮
-(void)initSaveBotton
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"friendls_icon.png" highlighted:@"friendls_icon.png"];
    button.backgroundColor=[UIColor clearColor];
    button.frame = CGRectMake(0, 0, 24, 19);
    //按钮添加动作
    [button addTarget:self action:@selector(addReceiveGoodAddress) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.rightBarButtonItem = [backItem autorelease];
}

//添加
-(void)addReceiveGoodAddress
{
    BOOL ispost=YES;
    if (textReceiverName.text.length==0) {
        ispost=NO;
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"请正确填写收件人" message:@"收件人最少两个字，不超过20个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (textReceiverMobile.text.length==0) {
        ispost=NO;
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"请正确填写电话号码" message:@"不能少于7位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (textReceiverAddress.text.length==0) {
        ispost=NO;
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"请填写详细地址" message:@"最少5个字，寄件人能找到您的地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (textZip.text.length==0) {
        ispost=NO;
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"请填写邮编" message:@"诸城的常用邮编为262200" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (ispost) {
        //请求网络登录
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/me/receivegoodaddress.ashx"]];
        //post参数
        [request setPostValue:self.userModel.UserID forKey:@"userid"];
        [request setPostValue:@"add" forKey:@"action"];
        [request setPostValue:textReceiverName.text forKey:@"receiver"];
        [request setPostValue:textReceiverMobile.text forKey:@"phone"];
        [request setPostValue:textReceiverAddress.text forKey:@"address"];
        [request setPostValue:textZip.text forKey:@"zip"];
        
        [request setDelegate:self];
        [request startAsynchronous];
    }
    
}

//请求结束  应该将数据存到本地  如果网络请求失败就从本地取
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [self.navigationController popViewControllerAnimated:YES];
}
//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"请求失败");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [_receiveGoodAddressModel release]; _receiveGoodAddressModel=nil;
    
    [textReceiverName release];         textReceiverName=nil;
    [textReceiverMobile release];       textReceiverMobile=nil;
    [textReceiverAddress release];      textReceiverAddress=nil;
    [textZip release];                  textZip=nil;
    [checkboxDefaultAddress release];   checkboxDefaultAddress=nil;
    [mainScrollView release];           mainScrollView=nil;
}

@end
