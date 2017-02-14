//
//  BaseTabBarViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-5.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarViewController : UITabBarController
{
    UIView *_tabbarView;
    UIImageView *_sliderView;
}
- (void)initViewController:(NSArray *)views;
- (void)initTabbarView:(NSArray *)backgroud HeightBackground:(NSArray *) heightBackground;
@end
