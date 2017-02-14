//
//  BaseViewController.h
//  所有视图控制器的基类
//
//  Created by wei.chen on 13-1-21.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"


@class LoginViewController,UserModel;
@interface BaseViewController : UIViewController


@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,assign)UserModel *userModel;

-(MMDrawerController *)mmDrawerController;

@end
