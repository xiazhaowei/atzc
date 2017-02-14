//
//  NewsMainViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-27.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKHorizMenu.h"

@interface NewsTabViewController : UITabBarController<MKHorizMenuDataSource,MKHorizMenuDelegate>
{
    MKHorizMenu *_horizMenu;    
    
    NSMutableArray *_menuItems;
    NSDictionary   *_menuClass;
}
@end
