//
//  BaseNavigationController.m
//  所有导航栏的基类  接收修改皮肤的通知并修改导航栏的背景
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //注册一个修改皮肤的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNofication object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //加载皮肤的图片
    [self loadThemeImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotification actions  换肤通知
- (void)themeNotification:(NSNotification *)notification {
    [self loadThemeImage];
}
// 更改导航栏背景 加载皮肤的图片
- (void)loadThemeImage {
    float version = WXHLOSVersion();
    if (version >= 5.0) {
        //获得皮肤管理器中的图片
        UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"navigationbar_background.png"];
        //设置导航栏的背景图片
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        //调用setNeedsDisplay方法会让绚烂引擎异步调用drawRect方法
        [self.navigationBar setNeedsDisplay];
    }
}

@end
