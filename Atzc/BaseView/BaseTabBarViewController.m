//
//  BaseTabBarViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-5.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"

#import "UIFactory.h"
#import "ThemeButton.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:YES];//隐藏自带的工具栏
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    //创建自定义tabBar
    [self _initTabbarView];
}

//初始化子控制器
- (void)initViewController:(NSArray *)views
{    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:views.count];
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        [nav release];
    }
    
    self.viewControllers = viewControllers;
}

//创建自定义tabBar
- (void)initTabbarView:(NSArray *)backgroud HeightBackground:(NSArray *) heightBackground {
    
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
    [self.view addSubview:_tabbarView];
    
    //从皮肤工厂获得tabbar的背景图片
    UIImageView *tabbarGroundImage = [UIFactory createImageView:@"tabbar_background.png"];
    tabbarGroundImage.frame = _tabbarView.bounds;
    //tabbarview添加一个和他相同大小的图片视图
    [_tabbarView addSubview:tabbarGroundImage];
    
    //添加按钮
    for (int i=0; i<backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *heightImage = heightBackground[i];
        
        //ThemeButton *button = [[ThemeButton alloc] initWithImage:backImage highlighted:heightImage];
        //通过格式工厂获得按钮图片并初始化按钮
        UIButton *button = [UIFactory createButton:backImage highlighted:heightImage];
        button.frame = CGRectMake(0+i*160, 0, 160, 49);
        button.tag = i;
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
    //指示器
    _sliderView = [[UIFactory createImageView:@"tabbar_slider.png"] retain];
    _sliderView.backgroundColor = [UIColor clearColor];
    _sliderView.frame = CGRectMake(0, 5, 160, 44);
    [_tabbarView addSubview:_sliderView];
}

#pragma mark - actionsF
//tab 按钮的点击事件
- (void)selectedTab:(UIButton *)button {
    self.selectedIndex = button.tag;
    float x = button.left + (button.width-_sliderView.width)/2;
    [button setHighlighted:YES];
    //设置指示器的位置 并添加动画
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = x;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
