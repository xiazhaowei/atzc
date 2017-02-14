//
//  FriendDynViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "FriendDynViewController.h"
#import "DynCell.h"
#import "ASIHTTPRequest.h"
#import "MJRefresh.h"
#import "AlbumInfoViewController.h"


#define kItemWidth ScreenWidth
#define kItemHeight 60

//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 1.0f

@interface FriendDynViewController ()<MJRefreshBaseViewDelegate,CommentBtnDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@end

@implementation FriendDynViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"朋友圈";
        _Page=1;
        _Dyns=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    
    //初始化动态列表
    [self initDynListTableView];
    
    //从网络请求用户的动态
    [self RequestDynList];
    //先从本地读取上次的数据
    //[self requestFailed:nil];
    
    // 防止block循环retain，所以用__unsafe_unretained
    //__unsafe_unretained FriendDynViewController *vc = self;
    
    // 下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.scrollView = _dynListTableView;
    _header.delegate = self;
    
    //上拉加载更多控件
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = _dynListTableView;
    
    // 进入上拉加载状态就会调用这个方法
    _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //请求数据
        _Page++;
        [self RequestDynList];
    };
    
}
//初始化动态collectionview
-(void)initDynListTableView
{
    _dynListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-65)];
    _dynListTableView.dataSource=self;
    _dynListTableView.delegate=self;
    [self.view addSubview:_dynListTableView];
}

//异步请求数据
-(void)RequestDynList
{
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://3g.atzc.net/mobileapi/me/userdyn.ashx"]];
    //post参数
    [request setPostValue:self.userModel.UserID forKey:@"user_id"];
    [request setPostValue:[NSString stringWithFormat:@"%i",_Page] forKey:@"Page"];
    [request setDelegate:self];
    [request startAsynchronous];
    //添加指示层
    [DejalActivityView activityViewForView:self.view withLabel:@"正在加载"];
}

//请求结束  应该将数据存到本地  如果网络请求失败就从本地取
- (void)requestFinished:(ASIHTTPRequest *)request
{    
    NSData *responseData = [request responseData];
    //将下载的数据文件存储到本地
    [AtzcNetWorkServices WirteToJsonFile:@"HomeCenterDyns.json" JsonData:responseData];
    [self WarpJosnData:responseData];
}

//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"HomeCenterDyns.json"];
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
    //_Dyns=[[NSMutableArray alloc] initWithCapacity:result.count];
    
    for (id data in result) {//便利数组 将数据的模型添加到 数组中
        
        DynModel *dynModel=[DynModel  alloc];
        dynModel.ID        = [[data objectForKey:@"ID"] intValue];
        dynModel.cID       = [[data objectForKey:@"cID"] intValue];
        dynModel.Title     = [data objectForKey:@"Title"];
        dynModel.Content   = [data objectForKey:@"Content"];
        dynModel.PostTime  = [data objectForKey:@"PostTime"];
        dynModel.DynType  = [data objectForKey:@"DynType"];
        
        //图片列表
        NSArray *picresult=[data objectForKey:@"Pics"];
        
        dynModel.Pics=[[NSMutableArray alloc] initWithCapacity:picresult.count];
        for (id picdata in picresult) {
            [dynModel.Pics addObject:picdata];
        }
        
        //评论列表
        NSArray *commentsresult=[data objectForKey:@"Comments"];
        dynModel.Comments=[[NSMutableArray alloc] initWithCapacity:commentsresult.count];
        NSLog(@"评论数量：%i",commentsresult.count);
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
    [_dynListTableView reloadData];//列表视图重新加载数据
}




#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _header) { // 下拉刷新
        //请求数据
        _Page=1;
        [_Dyns removeAllObjects];
        [self RequestDynList];
    }
}


#pragma mark -集合视图的 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _Dyns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"usercenterDyn";
    
    DynCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {//如果没有创建单元格就创建他
        cell=[[DynCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.tag=indexPath.row;
    cell.delegate=self;
    cell.dynModel = _Dyns[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //计算文字高度
    NSString *orgin=((DynModel *)_Dyns[indexPath.row]).Content;
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((420-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    //计算图片高度
    float picheight=0;
    picheight= (((DynModel *)_Dyns[indexPath.row]).Pics.count/3)*60;
    
    return  50+textSize.height+picheight+30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DynModel *dynModel=_Dyns[indexPath.row];
    NSLog(@"动态图的cid:%i",dynModel.cID);
    if ([dynModel.DynType isEqualToString:@"updatealbum"]) {//如果是更新相册动态
        AlbumInfoViewController *albumInfoVC=[[AlbumInfoViewController alloc] init];
        albumInfoVC.albumid=dynModel.cID;
        
        [self.navigationController pushViewController:albumInfoVC animated:YES];
        [albumInfoVC release];
    }
    
}

#pragma mark 显示评论键盘代理
//显示评论键盘
-(void)showkeyboard:(DynModel *)dynModel
{
    //添加取消键盘手势
    [_dynListTableView addGestureRecognizer:tap];
    
    //评论视图
    if (!_mainCommentView) {
        _mainCommentView=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-105, ScreenWidth, 40)];
        _mainCommentView.backgroundColor=Color(80, 80, 80, 1);
        
        _commentText=[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 257, 30)];
        _commentText.backgroundColor=[UIColor whiteColor];
        _commentText.borderStyle=UITextBorderStyleRoundedRect;
        _commentText.returnKeyType=UIReturnKeySend;
        [_mainCommentView addSubview:_commentText];
        
        //_btnSend=[[UIButton alloc] initWithFrame:CGRectZero];
        _btnSend = [UIFactory createButton:@"comment_btn.png" highlighted:@"comment_btn.png"];
        _btnSend.frame=CGRectMake(_commentText.right+5, _commentText.top, 50, _commentText.height);
        //[_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [_btnSend addTarget:self action:@selector(doComment:) forControlEvents:UIControlEventTouchUpInside];
        [_mainCommentView addSubview:_btnSend];
    }
    //添加到主视图
    [self.view addSubview:_mainCommentView];
    [_commentText becomeFirstResponder];
}

//调整键盘视图
- (void) changeContentViewPoint:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        _mainCommentView.center = CGPointMake(_mainCommentView.center.x, keyBoardEndY - 0 - _mainCommentView.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
        
    }];
}

//发送评论
-(void)doComment:(UIButton*)sender
{
    
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    //取消编辑
    [self.view endEditing:YES];
    //删除表格手势
    [_dynListTableView removeGestureRecognizer:tap];
    //删除评论框
    [_mainCommentView removeFromSuperview];
}

-(void)dealloc
{
    [super dealloc];
    [_dynListTableView release];_dynListTableView=nil;
    [_Dyns release]; _Dyns=nil;
    [_mainCommentView release];_mainCommentView=nil;
    [_commentText release];_commentText=nil;
    [_btnSend release];_btnSend=nil;
    
    [tap release];tap=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
