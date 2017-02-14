//
//  MyProfileViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "MyProfileViewController.h"
#import "TDBadgedCell.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"个人信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //初始化子视图
    [self initSubViews];
}

//初始化子视图
-(void)initSubViews
{
    profileTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-70)];
    profileTable.dataSource=self;
    profileTable.delegate=self;
    
    [self.view addSubview:profileTable];
}

#pragma mark - 表格视图的代理
//返回分组数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//返回组的标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

//单元格的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
        return 80;
    else
        return 45;
}
#pragma mark - 表格视图的数据源
//表视图的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
        return 4;
    else if(section==1)
        return 1;
    else if(section==2)
        return 1;
    else if(section==3)
        return 2;
    else
        return 0;
}
//绘制每个表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0&&indexPath.row==0) {
        static NSString *cellIdentifier=@"profileheadercell";
        //通过表示符判断是否有闲置的单元格
        TDBadgedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=@"头像";
        cell.badgeImageImage=self.userModel.Header;
        cell.badgeImage.frame=CGRectMake(0, 0, 50, 50);
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section==0&&indexPath.row>0) {
        NSArray *baseinfoTitleArray=@[@"名字",@"性别",@"区域"];
        NSArray *baseinfoArray=@[self.userModel.UserName,@"男",@"市里 朝阳花园"];
        
        static NSString *cellIdentifier=@"profilebaseinfocell";
        //通过表示符判断是否有闲置的单元格
        TDBadgedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=baseinfoTitleArray[indexPath.row-1];
        cell.badgeString=baseinfoArray[indexPath.row-1];
        cell.badgeColor=[UIColor clearColor];
        cell.badge.badgeStringColor=[UIColor grayColor];
        cell.badge.badgeFontSize=12;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section==1) {
        static NSString *cellIdentifier=@"profilepasswordcell";
        //通过表示符判断是否有闲置的单元格
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=@"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section==2) {
        static NSString *cellIdentifier=@"profilelinkcell";
        //通过表示符判断是否有闲置的单元格
        TDBadgedCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=@"QQ";
        cell.badgeString=@"724446029";
        cell.badgeColor=[UIColor clearColor];
        cell.badge.badgeStringColor=[UIColor grayColor];
        cell.badge.badgeFontSize=12;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        NSArray *resumeArray=@[@"教育信息",@"工作经历"];
        static NSString *cellIdentifier=@"profileresumecell";
        //通过表示符判断是否有闲置的单元格
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text=resumeArray[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    
}
//点击某个单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark 内存管理
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
    [profileTable release];profileTable=nil;
}

@end
