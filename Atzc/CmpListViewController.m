//
//  CmpListViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CmpListViewController.h"
#import "CsInfoClsView.h"
#import "CompanyListCell.h"

@interface CmpListViewController ()

@end

@implementation CmpListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"诸城商家";
        _Page=1;
        _classcollection=@"1";
        _CompanyListArray=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化视图
    [self initUI];
	//加载数据
    [self RequestCmpList:_classcollection Page:_Page];
    
    //上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = companyListTable;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //请求数据
        _Page++;
        [self RequestCmpList:_classcollection Page:_Page];
    };
}

-(void)initUI
{
    //信息列表表格
    companyListTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight-80-40)];
    companyListTable.dataSource=self;
    companyListTable.delegate=self;
    [self.view addSubview:companyListTable];   
   
    
    //初始化类别筛选控件
    CsInfoClsView *csinfoclsview=[[CsInfoClsView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, 0)];
    csinfoclsview.CsOrCmp=enumCmpInfoClass;
    csinfoclsview.deepClass=1;
    csinfoclsview.tag=1;
    csinfoclsview.backgroundColor=[UIColor whiteColor];
    csinfoclsview.delegate=self;
    [csinfoclsview setHidden:YES];
    [self.view addSubview:csinfoclsview];
    [csinfoclsview release];
    
    
    //分类和筛选面板
    UIView *filterPanel=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    filterPanel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"filterPanelBg.png"]];
    [self.view addSubview:filterPanel];
    [filterPanel release];    
    
    
    //筛选按钮
    UIImageView *filterButton=[[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-5-70, 5, 70, 32)];
    filterButton.image= [UIImage imageNamed:@"filterbuttonoff"];
    filterButton.tag=2;
    filterButton.userInteractionEnabled=YES;
    //添加点击事件
    UITapGestureRecognizer *tapGestureTel = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showOrHiddenCsinfoCls)]autorelease];
    [filterButton addGestureRecognizer:tapGestureTel];
    
    [filterPanel addSubview:filterButton];
    [filterButton release];
}

-(void)showOrHiddenCsinfoCls
{
    CsInfoClsView *csinfoclsview=(CsInfoClsView *)[self.view viewWithTag:1];
    UIImageView *filterButton=(UIImageView *)[self.view viewWithTag:2];
    if (csinfoclsview.isHidden) {
        filterButton.image=[UIImage imageNamed:@"filterbuttonon"];
        [csinfoclsview setHidden:NO];
    }
    else
    {
        filterButton.image=[UIImage imageNamed:@"filterbuttonoff"];
        [csinfoclsview setHidden:YES];
    }
}

#pragma mark  FilterSjcmNewsDelegate 的代理
//根据类别筛选数据
-(void)FilterSjcmNews:(NSString *)classcollection
{
    [_CompanyListArray removeAllObjects];
    _classcollection=classcollection;
    [self RequestCmpList:_classcollection Page:1];
}

//请求远端数据
-(void)RequestCmpList:(NSString *)classcollection Page:(int)page
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/cmp/cmplist.ashx"]];
    //post参数
    [request setPostValue:classcollection forKey:@"classes"];
    [request setPostValue:[NSString stringWithFormat:@"%i",page] forKey:@"Page"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    //添加指示层
    [DejalActivityView activityViewForView:self.view withLabel:@"正在加载"];
}
//请求网络成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSData *responseData = [request responseData];
    //将下载的数据文件存储到本地
    [AtzcNetWorkServices WirteToJsonFile:@"CmpList.json" JsonData:responseData];
    //解析数据
    [self WarpJosnData:responseData];
}

//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"CmpList.json"];
    //解析数据
    [self WarpJosnData:jsonData];
}

//解析数据
-(void)WarpJosnData:(NSData *)jsonData
{
    [DejalActivityView removeView];
    
    //解析json 之前通过IOS5 自带的解析对象解析
    //id resultClasses=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultClasses=[paser objectWithData:jsonData];
    
    //根类别属性的集合
    NSArray *csinforesult=[resultClasses objectForKey:@"CmpInfos"];
    
    //将数据添加到数组中
    //_CsInfoListArray=[[NSMutableArray alloc] initWithCapacity:csinforesult.count];
    
    for (id data in csinforesult) {
        CompanyModel *companyModel=[CompanyModel  alloc];
        companyModel.CompanyID  = [[data objectForKey:@"ID"] intValue];
        companyModel.Logo     = [data objectForKey:@"Logo"];
        companyModel.Title   = [data objectForKey:@"Title"];
        companyModel.Description     = [data objectForKey:@"Description"];
        companyModel.CreateTime = [data objectForKey:@"CreateTime"];
        
        [_CompanyListArray addObject:companyModel];
        [companyModel release];
    }
    
    //数据接收完，刷新信息
    [companyListTable reloadData];
    [_footer endRefreshing];
}

#pragma mark 表格的代理
//单元格的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
#pragma mark - 表格视图的数据源
//表视图的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _CompanyListArray.count;//如果返回值为0或nil  cellforrowatindexpath不会执行
}
//绘制每个表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"companylistcell";//创建一个静态标示符
    //通过表示符判断是否有闲置的单元格
    CompanyListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {//如果没有创建单元格就创建他
        cell=[[CompanyListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.companyModel=_CompanyListArray[indexPath.row];
    
    return cell;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    
    [companyListTable release];companyListTable=nil;
    [_CompanyListArray release];_CompanyListArray=nil;
}

@end
