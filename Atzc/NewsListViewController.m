//
//  NewsMainViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-26.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsCell.h"
#import "NewsInfoViewController.h"

@interface NewsListViewController ()<MJRefreshBaseViewDelegate>

@end

@implementation NewsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"诸城新闻";
        _Page=1;        
        _NewsListArray=[[NSMutableArray alloc] init];
        //_menuLastUpdateTime=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化子视图
    [self initSubViews];
    
    // 下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = newsListTable;
    _header.delegate = self;
    
    //上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = newsListTable;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //请求数据
        _Page++;
        [self RequestNews:[NSString stringWithFormat:@"%d",_ClassID] Page:_Page];
    };
    
    //请求选中类别的新闻 通过下拉刷新请求
    [_NewsListArray removeAllObjects];
    [_header setState:RefreshStateRefreshing];
    
}
// 初始化子视图
-(void)initSubViews
{
    //信息列表表格
    newsListTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-80-50)];
    newsListTable.dataSource=self;
    newsListTable.delegate=self;
    [self.view addSubview:newsListTable];

}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) { // 下拉刷新
        //请求数据
        _Page=1;
        [_NewsListArray removeAllObjects];
        [self RequestNews:[NSString stringWithFormat:@"%d",_ClassID] Page:_Page];
    }
}


//请求网络
-(void)RequestNews:(NSString *)classid Page:(int) page
{
    //请求网络活动新闻
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/news/newslist.ashx"]];
    //post参数
    [request setPostValue:classid forKey:@"classid"];
    [request setPostValue:[NSString stringWithFormat:@"%i",page] forKey:@"Page"];    
    [request setDelegate:self];
    [request startAsynchronous];
    //添加指示层
    //[DejalActivityView activityViewForView:self.view withLabel:@"正在加载"];
}
//请求网络成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    //将下载的数据文件存储到本地  文件名后面跟类别
    
    [AtzcNetWorkServices WirteToJsonFile:[NSString stringWithFormat:@"NewsList_%d.json",_ClassID] JsonData:responseData];
    //解析数据
    [self WarpJosnData:responseData];
}

//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{    
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:[NSString stringWithFormat:@"NewsList_%d.json",_ClassID]];
    //解析数据
    [self WarpJosnData:jsonData];
}

//解析数据
-(void)WarpJosnData:(NSData *)jsonData
{
    //移除加载指示器
    //[DejalActivityView removeView];
    
    //解析json 之前通过IOS5 自带的解析对象解析
    //id resultClasses=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultClasses=[paser objectWithData:jsonData];
    
    //根类别属性的集合
    NSArray *newslistresult=[resultClasses objectForKey:@"News"];
    
    for (id data in newslistresult) {
        NewsInfoModel *newsinfoModel=[NewsInfoModel  alloc];
        newsinfoModel.NewsID  = [[data objectForKey:@"ID"] intValue];
        newsinfoModel.Pic     = [data objectForKey:@"Pic"];
        newsinfoModel.Title   = [data objectForKey:@"Title"];
        newsinfoModel.Content     = [data objectForKey:@"Content"];
        newsinfoModel.CreateTime = [data objectForKey:@"CreateTime"];
        newsinfoModel.Comments = 0;
        [_NewsListArray addObject:newsinfoModel];
        [newsinfoModel release];
    }
    
    //数据接收完，刷新信息
    [newsListTable reloadData];
    //结束刷新
    [_header endRefreshing];
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
    return _NewsListArray.count;//如果返回值为0或nil  cellforrowatindexpath不会执行
}
//绘制每个表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"newslistcell";//创建一个静态标示符
    //通过表示符判断是否有闲置的单元格
    NewsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {//如果没有创建单元格就创建他
        cell=[[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.newsInfoModel=_NewsListArray[indexPath.row];
    
    return cell;
    
}
//点击某个信息
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsInfoModel *newsInfoModel=_NewsListArray[indexPath.row];
    
    NewsInfoViewController *newsInfoVC=[[NewsInfoViewController alloc] init];
    newsInfoVC.NewsID=newsInfoModel.NewsID;
    
    [self.navigationController.navigationController pushViewController:newsInfoVC animated:YES];
    [newsInfoVC release];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    //[_horizMenu release];_horizMenu=nil;
    //[_menuItems release];_menuItems=nil;
    [newsListTable release];newsListTable=nil;
    [_NewsListArray release];_NewsListArray=nil;
    //[_menuClass release];_menuClass=nil;
}

@end
