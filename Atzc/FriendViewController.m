//
//  FridenViewController.m
//  Atzc  用户个人页面
//
//  Created by 夏兆伟 on 13-12-5.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendDynView.h"
#import "DynCell.h"
#import "MJRefresh.h"

//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 1.0f

@interface FriendViewController ()<MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@end

@implementation FriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];	
    //标题
    self.title=[self.userFriendModel.UserName stringByAppendingString:MySiteName];
    
    //初始化视图
    [self initSubViews];
    //请求数据
    [self RequestDynList];
    
    // 防止block循环retain，所以用__unsafe_unretained
    __unsafe_unretained FriendViewController *vc = self;
    
    // 下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = friendDynView;
    _header.delegate = self;
    
    //上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = friendDynView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //请求数据
        [self RequestDynList];
    };
}


-(void)initSubViews
{
    //顶部背景
    UIView *topBgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    topBgView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"userProfileBg"]];
    [self.view addSubview:topBgView];
    [topBgView release];
    //用户动态
    friendDynView=[[FriendDynView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49)];
    friendDynView.userFriendModel=self.userModel;
    friendDynView.dataSource=self;
    friendDynView.itemSelectedDelegate=self;
    
    [self.view addSubview:friendDynView];
    
    
}

#pragma mark 私有方法
//异步请求数据
-(void)RequestDynList
{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/me/userdyn.ashx"]];
    //post参数
    [request setPostValue:self.userModel.UserID forKey:@"user_id"];
    [request setPostValue:@"own" forKey:@"Type"];
    [request setDelegate:self];
    [request startAsynchronous];
    //添加指示层
    [DejalActivityView activityViewForView:self.view withLabel:@"正在加载"];
}

#pragma mark 请求回调函数

//请求结束  应该将数据存到本地  如果网络请求失败就从本地取
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    //将下载的数据文件存储到本地
    [AtzcNetWorkServices WirteToJsonFile:@"FriendDyns.json" JsonData:responseData];
    [self WarpJosnData:responseData];
}

//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"FriendDyns.json"];
    //解析数据
    [self WarpJosnData:jsonData];
}


//解析json数据到 动态数组中
-(void)WarpJosnData:(NSData *)jsonData
{
    [DejalActivityView removeView];
    //解析json 成字典数据
    //id resultFriends=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultFriends=[paser objectWithData:jsonData];
    
    NSArray *result=[resultFriends objectForKey:@"Dyns"];
    
    //将数据添加到数组中
    _Dyns=[[NSMutableArray alloc] initWithCapacity:result.count];
    
    for (id data in result) {//便利数组 将数据的模型添加到 数组中
        
        DynModel *dynModel=[DynModel  alloc];
        dynModel.ID        = [[data objectForKey:@"ID"] intValue];
        dynModel.cID       = [[data objectForKey:@"cID"] intValue];
        dynModel.Title     = [data objectForKey:@"Title"];
        dynModel.Content   = [data objectForKey:@"Content"];
        dynModel.PostTime  = [data objectForKey:@"PostTime"];
        
        //图片列表
        NSArray *picresult=[data objectForKey:@"Pics"];
        dynModel.Pics=[[NSMutableArray alloc] initWithCapacity:picresult.count];
        for (id picdata in picresult) {
            [dynModel.Pics addObject:picdata];
        }
        
        //评论列表
        NSArray *commentsresult=[data objectForKey:@"Comments"];
        dynModel.Comments=[[NSMutableArray alloc] initWithCapacity:commentsresult.count];
        //遍历每个评论
        for (id commentdata in commentsresult) {
            CommentModel *commentModel=[CommentModel  alloc];
            commentModel.ID  = [[commentdata objectForKey:@"ID"] intValue];
            commentModel.Content     = [commentdata objectForKey:@"Content"];
            commentModel.CreateTime = [commentdata objectForKey:@"CreateTime"];
            //评论者
            UserModel *commentpublicer=[[UserModel alloc] init];
            commentpublicer.UserName    =[[commentdata objectForKey:@"Publicer"] objectForKey:@"UserName"];
            commentpublicer.Header      =[[commentdata objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
            commentpublicer.UserAccount =[[commentdata objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
            
            commentModel.Publicer=commentpublicer;
            [commentpublicer release];
            
            [dynModel.Comments addObject:commentModel];
            [commentModel release];
        }
        
        //上传者
        UserModel *publicer=[[UserModel alloc] init];
        publicer.UserID      = [[data objectForKey:@"Publicer"] objectForKey:@"UserID"];
        publicer.UserAccount = [[data objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
        publicer.UserName    = [[data objectForKey:@"Publicer"] objectForKey:@"UserName"];
        publicer.Header      = [[data objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
        
        dynModel.Publicer=publicer;
        [publicer release];
        
        [_Dyns addObject:dynModel];
        [dynModel release];
    }
    
    //数据接收完，刷新UI
    [self refreshDynListUI];
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
}

//刷新UI
-(void)refreshDynListUI
{
    [friendDynView reloadData];//列表视图重新加载数据
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) { // 下拉刷新
        //请求数据
        [self RequestDynList];
    }
}

//动态的数据源代理
- (int) numberOfItemsForDyn:(FriendDynView*) dynView
{
    return 5;
}
//动态项目
- (UITableViewCell *)dynView:(FriendDynView *)dynView itemForRow:(int)row
{
    static NSString *cellIdentifier = @"userDyn";
    
    DynCell *cell=[[DynCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.tag=row;
    cell.dynModel = _Dyns[row];
    cell.headerViewSize=CGSizeMake(40, 40);
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}

//项目高度
- (CGFloat)dynView:(FriendDynView *)dynView heightForRow:(int)row
{
    //计算文字高度
    NSString *orgin=((DynModel *)_Dyns[row]).Content;
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((420-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    //计算图片高度
    float picheight=0;
    picheight= (((DynModel *)_Dyns[row]).Pics.count/3)*60;
    
    return  50+textSize.height+picheight;

}

- (void)friendDyn:(FriendDynView*) friendDyn itemSelectedAtIndex:(NSUInteger) index
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [friendDynView release];friendDynView=nil;
}

@end
