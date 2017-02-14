//
//  PicMainViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-4.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "PicMainViewController.h"
#import "AlbumCell.h"
#import "MJRefresh.h"
#import "AlbumInfoViewController.h"

@interface PicMainViewController ()

@end

@implementation PicMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"在诸城图片";
        albumArray=[[NSMutableArray alloc] init];
        _Page=1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //初始化视图
    [self initSubViews];
    //请求数据
    [self RequestData];
    //上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = collectionView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //请求数据
        _Page++;
        [self RequestData];
    };
}

//初始化子视图
-(void)initSubViews
{
    //collectionview布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //每个的大小
    layout.itemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing=5;//最小行距
    layout.minimumInteritemSpacing=1;//列间距
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//内补白
    
    collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) collectionViewLayout:layout];
    
    // KCellID为宏定义 @"CollectionCell"
    [collectionView registerClass:[AlbumCell class] forCellWithReuseIdentifier:@"albumlistcell"];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:collectionView];
    
    [layout release];
}

-(void)RequestData
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/pic/albumlist.ashx"]];
    //post参数
    [request setPostValue:@"0" forKey:@"classid"];
    [request setPostValue:[NSString stringWithFormat:@"%i",_Page] forKey:@"Page"];
    
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
    [AtzcNetWorkServices WirteToJsonFile:@"AlbumList.json" JsonData:responseData];
    //解析数据
    [self WarpJosnData:responseData];
}

//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"AlbumList.json"];
    //解析数据
    [self WarpJosnData:jsonData];
}

//解析数据
-(void)WarpJosnData:(NSData *)jsonData
{
    [DejalActivityView removeView];
    
    //解析json 之前通过IOS5
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultClasses=[paser objectWithData:jsonData];
    
    //根类别属性的集合
    NSArray *albumresults=[resultClasses objectForKey:@"Albumes"];
    
    
    for (id data in albumresults) {
        AlbumModel *albumModel=[AlbumModel  alloc];
        albumModel.ID     = [[data objectForKey:@"ID"] intValue];
        albumModel.Conver     = [data objectForKey:@"Conver"];
        albumModel.Title   = [data objectForKey:@"Title"];
        albumModel.Description     = [data objectForKey:@"Description"];
        albumModel.CreateTime = [data objectForKey:@"CreateTime"];
        albumModel.ImagesCount=[[data objectForKey:@"ImagesCount"] intValue];
        
        //上传者
        UserModel *publicer=[[UserModel alloc] init];
        publicer.UserID=[[data objectForKey:@"Publicer"] objectForKey:@"UserID"];
        publicer.UserAccount=[[data objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
        publicer.UserName=[[data objectForKey:@"Publicer"] objectForKey:@"UserName"];
        publicer.Header=[[data objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
        
        albumModel.Publicer=publicer;
        [publicer release];
        
        [albumArray addObject:albumModel];
        [albumModel release];
    }
    
    //数据接收完，刷新信息
    [self refreshUI];
    [_footer endRefreshing];
}

//刷新UI
-(void)refreshUI
{
    [collectionView reloadData];//列表视图重新加载数据
}

#pragma mark 集合视图的代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return albumArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *KCellID = @"albumlistcell";
    AlbumCell *cell = (AlbumCell *)[collectionView dequeueReusableCellWithReuseIdentifier:KCellID forIndexPath:indexPath];
    cell.tag=indexPath.row;
    cell.albumModel = albumArray[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
//点击相册
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumInfoViewController *albumInfoVC=[[AlbumInfoViewController alloc] init];
    albumInfoVC.albumid=((AlbumModel *)albumArray[indexPath.row]).ID;
    //albumInfoVC.albumid=48;
    [self.navigationController  pushViewController:albumInfoVC animated:YES];
    [albumInfoVC release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    
    [collectionView release];collectionView=nil;
    [albumArray release];albumArray=nil;
}

@end
