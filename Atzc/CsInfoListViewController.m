//
//  CsInfoMainViewController.m
//  Atzc  分类信息列表页
//
//  Created by 夏兆伟 on 13-12-5.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CsInfoListViewController.h"
#import "CsInfoClsView.h"
#import "SjcmNewsListCell.h"
#import "CCSegmentedControl.h"
#import "CsInfoViewController.h"
#import "MJRefresh.h"

@interface CsInfoListViewController ()

@end

@implementation CsInfoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"分类信息";
        _Page=1;
        _classcollection=@"1";
        _CsInfoListArray=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)initUI
{
    //信息列表表格
    newsListTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, ScreenHeight-80-40)];
    newsListTable.dataSource=self;
    newsListTable.delegate=self;
    [self.view addSubview:newsListTable];
    
    NSLog(@"csinfomain");
    
    //初始化类别筛选控件
    CsInfoClsView *csinfoclsview=[[CsInfoClsView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, 0)];
    csinfoclsview.CsOrCmp=enumCsInfoClass;
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
    
    //推荐最新选项卡
    NSArray *SigeItem=@[@"精选推荐",@"最新发布"];
    CCSegmentedControl *segmentedControl=[[CCSegmentedControl alloc] initWithItems:SigeItem];
    segmentedControl.frame=CGRectMake(5, 5, 126, 35);
    //设置背景图片，或者设置颜色，或者使用默认白色外观
    segmentedControl.backgroundImage = [UIImage imageNamed:@"segimentbg.png"];
    
    UIImageView *seglectbgView=[[[UIImageView alloc] init] autorelease];
    seglectbgView.image=[UIImage imageNamed:@"selectedsegimentbg"];
    segmentedControl.selectedStainView=seglectbgView;
    
    segmentedControl.selectedSegmentTextColor = [UIColor whiteColor];
    segmentedControl.segmentTextColor = [UIColor blackColor];
    [segmentedControl addTarget:self action:@selector(segmetedValueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    [filterPanel addSubview:segmentedControl];
    [segmentedControl release];
    
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

//排序修改
-(void)segmetedValueChanged:(CCSegmentedControl *)sender
{
    CCSegmentedControl* segmentedControl = sender;
    NSLog(@"%s line:%d segment has changed to %d", __FUNCTION__, __LINE__, segmentedControl.selectedSegmentIndex);
}


#pragma mark  FilterSjcmNewsDelegate 的代理
//根据类别筛选数据
-(void)FilterSjcmNews:(NSString *)classcollection
{
    [_CsInfoListArray removeAllObjects];
    _classcollection=classcollection;
    [self RequestSjcmNews:_classcollection Page:1];
}

//请求远端数据
-(void)RequestSjcmNews:(NSString *)classcollection Page:(int)page
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/csinfo/csinfolist.ashx"]];
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
    [AtzcNetWorkServices WirteToJsonFile:@"CsInfoList.json" JsonData:responseData];
    //解析数据
    [self WarpJosnData:responseData];
}

//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"CsInfoList.json"];
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
    NSArray *csinforesult=[resultClasses objectForKey:@"CsInfos"];
    
    //将数据添加到数组中
    //_CsInfoListArray=[[NSMutableArray alloc] initWithCapacity:csinforesult.count];
    
    for (id data in csinforesult) {
        CsInfoModel *csinfoModel=[CsInfoModel  alloc];
        csinfoModel.NewsID  = [[data objectForKey:@"ID"] intValue];
        csinfoModel.Pic     = [data objectForKey:@"Pic1"];
        csinfoModel.Title   = [data objectForKey:@"Title"];
        csinfoModel.Content     = [data objectForKey:@"Content"];
        csinfoModel.CreateTime = [data objectForKey:@"CreateTime"];
        csinfoModel.Price = @"0.0";
        [_CsInfoListArray addObject:csinfoModel];
        [csinfoModel release];
    }
    
    //数据接收完，刷新信息
    [newsListTable reloadData];
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
    return _CsInfoListArray.count;//如果返回值为0或nil  cellforrowatindexpath不会执行
}
//绘制每个表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"csinfolistcell";//创建一个静态标示符
    //通过表示符判断是否有闲置的单元格
    SjcmNewsListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {//如果没有创建单元格就创建他
        cell=[[SjcmNewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.csInfoModel=_CsInfoListArray[indexPath.row];
    
    return cell;
    
}
//点击某个信息
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CsInfoModel *csInfoModel=_CsInfoListArray[indexPath.row];
    
    CsInfoViewController *csInfoVC=[[CsInfoViewController alloc] init];
    csInfoVC.NewsID=csInfoModel.NewsID;
    
    [self.navigationController pushViewController:csInfoVC animated:YES];
    [csInfoVC release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化视图
    [self initUI];
	//加载数据
    [self RequestSjcmNews:_classcollection Page:_Page];
    
    //上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = newsListTable;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //请求数据
        _Page++;
        [self RequestSjcmNews:_classcollection Page:_Page];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    
    [newsListTable release];newsListTable=nil;
    [_CsInfoListArray release];_CsInfoListArray=nil;
}

@end
