//
//  ThemeViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //取得所有的主题名
        themes = [[ThemeManager shareInstance].themesPlist allKeys];
        [themes retain];
        
        self.title = @"主题切换";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//加载主题列表表格视图
    [self loadThemesListTableView];
}

//加载主题列表表格视图
-(void)loadThemesListTableView
{
    _themesListTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _themesListTableView.dataSource=self;
    _themesListTableView.delegate=self;
    _themesListTableView.indicatorStyle=UIScrollViewIndicatorStyleWhite;//设置滚动条的颜色
    //菜单的背景颜色
    _themesListTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbarbg"]];
    [_themesListTableView setSeparatorColor:Color(21, 22, 20, 1)];
    
    [self.view addSubview:_themesListTableView];
}

#pragma mark - 表格的代理函数
//表格的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return themes.count;
}
//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"themeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *textLabel = [UIFactory createLabel:kThemeListLabel];
        textLabel.frame = CGRectMake(10, 10, 200, 30);
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        textLabel.tag = 2013;
        [cell.contentView addSubview:textLabel];
    }
    
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:2013];
    //当前cell中的主题名
    NSString *name = themes[indexPath.row];
    textLabel.text = name;
    
    //当前使用的主题名称
    NSString *themeName = [ThemeManager shareInstance].themeName;
    if (themeName == nil) {
        themeName = @"默认";
    }
    
    //比较cell中的主题名和当前使用的主题名是否相同 如果相同就显示选中状态
    if ([themeName isEqualToString:name]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;        
    }
    
    return cell;
}

//切换主题
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //主题名称
    NSString *themeName = themes[indexPath.row];
    if ([themeName isEqualToString:@"默认"]) {
        themeName = nil;
    }
    
    //保存主题到本地
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //贴换主题
    [ThemeManager shareInstance].themeName = themeName;
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNofication object:themeName];
    
    //刷新列表
    [_themesListTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [super dealloc];
//    [_themesListTableView release];
//    _themesListTableView=nil;
}

@end
