//
//  AlbumInfoViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 14-1-6.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "AlbumInfoViewController.h"
#import "PhotoCell.h"
#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface AlbumInfoViewController ()

@end

@implementation AlbumInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"浏览相册";
        //获得信息实体类
        _albumModel=[[AlbumModel alloc] init];
        _albumModel.Photos=[[NSMutableArray alloc] init];
        _Page=1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSubViews];
    
    [self initAlbumModel];
    
    //上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = collectionView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //请求数据
        _Page++;
        [self initAlbumModel];
    };
    
}

-(void)initSubViews
{
    //collectionview布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //每个的大小
    layout.itemSize = CGSizeMake(75, 75);
    layout.minimumLineSpacing=3;
    layout.minimumInteritemSpacing=2;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49) collectionViewLayout:layout];
    
    // KCellID为宏定义 @"CollectionCell"
    [collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photolistcell"];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:collectionView];
    
    [layout release];
}

//请求网络活动信息详情
-(void)initAlbumModel
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/pic/albuminfo.ashx"]];
    //post参数
    [request setPostValue:[NSString stringWithFormat:@"%i",self.albumid] forKey:@"albumid"];
    [request setPostValue:[NSString stringWithFormat:@"%i",_Page] forKey:@"Page"];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    //添加指示层
    [DejalActivityView activityViewForView:self.view withLabel:@"正在加载"];
}

//请求网络成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [DejalActivityView removeView];
    NSData *jsonData = [request responseData];
    //解析json
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *resultClasses=[paser objectWithData:jsonData];
    
    
    _albumModel.Title=[resultClasses objectForKey:@"Title"];
    _albumModel.Description=[resultClasses objectForKey:@"Description"];
    _albumModel.CreateTime=[resultClasses objectForKey:@"CreateTime"];
    _albumModel.ImagesCount=[[resultClasses objectForKey:@"ImagesCount"] intValue];
    
    //图片列表
    NSArray *photosresult=[resultClasses objectForKey:@"Photos"];
    //_albumModel.Photos=[[NSMutableArray alloc] initWithCapacity:photosresult.count];
    //遍历每个图片
    for (id photodata in photosresult) {
        PhotoModel *photoModel=[PhotoModel  alloc];
        photoModel.ID          = [[photodata objectForKey:@"ID"] intValue];
        photoModel.PhotoPath   = [photodata objectForKey:@"PhotoPath"];
        photoModel.Description = [photodata objectForKey:@"Description"];
        photoModel.CreateTime  = [photodata objectForKey:@"CreateTime"];        
        [_albumModel.Photos addObject:photoModel];
        [photoModel release];
    }
    
    //评论列表
    NSArray *commentsresult=[resultClasses objectForKey:@"Comments"];
    _albumModel.Comments=[[NSMutableArray alloc] initWithCapacity:commentsresult.count];
    //遍历每个评论
    for (id data in commentsresult) {
        CommentModel *commentModel=[CommentModel  alloc];
        commentModel.ID  = [[data objectForKey:@"ID"] intValue];
        commentModel.Content     = [data objectForKey:@"Content"];
        commentModel.CreateTime = [data objectForKey:@"CreateTime"];
        //评论者
        UserModel *publicer=[[UserModel alloc] init];
        publicer.UserName    =[[data objectForKey:@"Publicer"] objectForKey:@"UserName"];
        publicer.Header      =[[data objectForKey:@"Publicer"] objectForKey:@"HeadImg"];
        publicer.UserAccount =[[data objectForKey:@"Publicer"] objectForKey:@"UserAccount"];
        
        commentModel.Publicer=publicer;
        [publicer release];
        
        [_albumModel.Comments addObject:commentModel];
        [commentModel release];
    }
    
    [self RefreshUI];
}
//信息请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [DejalActivityView removeView];
}

//刷新界面
-(void)RefreshUI
{
    [collectionView reloadData];
    [_footer endRefreshing];
}

#pragma mark 集合视图的代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _albumModel.Photos.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *KCellID = @"photolistcell";
    PhotoCell *cell = (PhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:KCellID forIndexPath:indexPath];
    cell.tag=indexPath.row;
    cell.photoModel=_albumModel.Photos[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
//点击相册
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_albumModel.Photos.count];
    for (int i = 0; i<_albumModel.Photos.count; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:((PhotoModel *)_albumModel.Photos[i]).PhotoPath]; // 图片路径
        //photo.srcImageView = ((PhotoCell *)[self.view viewWithTag:indexPath.row]).imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [photos release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [_albumModel release];_albumModel=nil;
    [collectionView release];collectionView=nil;
}

@end
