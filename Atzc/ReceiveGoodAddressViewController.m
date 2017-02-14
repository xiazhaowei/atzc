//
//  ReceiveGoodAddressViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-31.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ReceiveGoodAddressViewController.h"
#import "AddReceiveGoodAddressViewController.h"
#import "ReceiveGoodAddressCell.h"

@interface ReceiveGoodAddressViewController ()

@end

@implementation ReceiveGoodAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"收货地址管理";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化编辑按钮
    [self initEditBotton];
	//初始化视图
    [self initSubViews];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self RequestData];
}

//初始化视图
-(void)initSubViews
{
    receveGoodAddressTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
    receveGoodAddressTable.dataSource=self;
    receveGoodAddressTable.delegate=self;
    //表格无背景无分隔符
    [receveGoodAddressTable setBackgroundView:nil];
    [receveGoodAddressTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    [self.view addSubview:receveGoodAddressTable];
}

-(void)RequestData
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/me/receivegoodaddress.ashx"]];
    //post参数
    [request setPostValue:self.userModel.UserID forKey:@"userid"];
    [request setPostValue:@"getlist" forKey:@"action"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求结束  应该将数据存到本地  如果网络请求失败就从本地取
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    //将下载的数据文件存储到本地
    [AtzcNetWorkServices WirteToJsonFile:@"ReceiveGoodAddress.json" JsonData:responseData];
    //解析数据
    [self WarpJosnData:responseData];
}
//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"ReceiveGoodAddress.json"];
    //解析数据
    [self WarpJosnData:jsonData];
}

-(void)WarpJosnData:(NSData *)jsonData
{
    
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultFriends=[paser objectWithData:jsonData];
    
    NSArray *result=[resultFriends objectForKey:@"Addresses"];
    
    //将数据添加到数组中
    ReceiveGoodAddressListArray=[[NSMutableArray alloc] initWithCapacity:result.count];
    for (id data in result) {//便利数组 将数据的模型添加到 数组中
        ReceiveGoodAddressModel *receiveGoodAddressModel=[ReceiveGoodAddressModel  alloc];
        receiveGoodAddressModel.ID     = [[data objectForKey:@"ID"] integerValue];
        receiveGoodAddressModel.ReceiverName   = [data objectForKey:@"ReceiverName"];
        receiveGoodAddressModel.ReceiverMobile     = [data objectForKey:@"ReceiverMobile"];
        receiveGoodAddressModel.DetailAddress= [data objectForKey:@"ReceiverDetailAddress"];
        receiveGoodAddressModel.Zip = [data objectForKey:@"ReceiverZip"];
        
        if([[data objectForKey:@"IsDefault"] intValue]==1)
            receiveGoodAddressModel.IsDefault =YES;
        else
            receiveGoodAddressModel.IsDefault =NO;
        
        [ReceiveGoodAddressListArray addObject:receiveGoodAddressModel];
        [receiveGoodAddressModel release];
    }
    
    //数据接收完，刷新好友列表界面
    [self refreshTableUI];
}

//刷新表格UI
-(void)refreshTableUI
{
    [receveGoodAddressTable reloadData];//列表视图重新加载数据
}

//初始化添加按钮
-(void)initEditBotton
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"friendls_icon.png" highlighted:@"friendls_icon.png"];
    button.backgroundColor=[UIColor clearColor];
    button.frame = CGRectMake(0, 0, 24, 19);
    //按钮添加动作
    [button addTarget:self action:@selector(editTable) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.rightBarButtonItem = [backItem autorelease];
}
//表格进入可编辑状态
-(void)editTable
{
    if (receveGoodAddressTable.editing)
        [receveGoodAddressTable setEditing:NO animated:YES];
    else
        [receveGoodAddressTable setEditing:YES animated:YES];
}


#pragma mark - 表格视图的代理
//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//单元格的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
        return 55;
    else
        return 100;
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
        return ReceiveGoodAddressListArray.count;
    }
}
//绘制每个表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        static NSString *cellIdentifier=@"addreceivegoodaddress";//创建一个静态标示符
        //通过表示符判断是否有闲置的单元格
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {//如果没有创建单元格就创建他
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=@"添加";
        cell.backgroundColor=[UIColor clearColor];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"receivegoodaddresscell";//创建一个静态标示符
        //通过表示符判断是否有闲置的单元格
        ReceiveGoodAddressCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {//如果没有创建单元格就创建他
            cell=[[ReceiveGoodAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.receiveGoodAddressModel=ReceiveGoodAddressListArray[indexPath.row];        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (((ReceiveGoodAddressModel *)ReceiveGoodAddressListArray[indexPath.row]).IsDefault) {
            cell.backgroundColor=Color(247, 239, 223, 1);
        }
        return cell;
    }
}
//点击某个单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //添加收货地址
    if (indexPath.section==0&&indexPath.row==0) {
        AddReceiveGoodAddressViewController *addReceiveGoodAddressVC=[[AddReceiveGoodAddressViewController alloc] init];
        [self.navigationController pushViewController:addReceiveGoodAddressVC animated:YES];
        [addReceiveGoodAddressVC release];
    }
    //编辑收货地址
    if (indexPath.section==1) {
        AddReceiveGoodAddressViewController *addReceiveGoodAddressVC=[[AddReceiveGoodAddressViewController alloc] init];
        addReceiveGoodAddressVC.receiveGoodAddressModel=ReceiveGoodAddressListArray[indexPath.row];
        [self.navigationController pushViewController:addReceiveGoodAddressVC animated:YES];
        [addReceiveGoodAddressVC release];
    }
}
#pragma mark 表格编辑
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
        return YES;
    else
        return NO;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //请求网络删除
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/me/receivegoodaddress.ashx"]];
    //post参数
    [request setPostValue:[NSString stringWithFormat:@"%i",((ReceiveGoodAddressModel *)ReceiveGoodAddressListArray[indexPath.row]).ID ] forKey:@"id"];
    [request setPostValue:@"del" forKey:@"action"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(delSuccess:)];
    [request setDidFailSelector:@selector(delError:)];
    [request startAsynchronous];
    
    [tableView setEditing:NO animated:YES];
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//删除成功取消编辑
- (void)delSuccess:(ASIHTTPRequest *)request
{
    
    [receveGoodAddressTable setEditing:NO animated:YES];
    //重新请求数据
    [self RequestData];
}
- (void)delError:(ASIHTTPRequest *)request
{
    NSLog(@"删除失败");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [receveGoodAddressTable release];receveGoodAddressTable =nil;
}

@end
