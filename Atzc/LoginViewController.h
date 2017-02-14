//
//  LoginViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-11.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView *_userHead;
    IBOutlet UITextField *_userLoginName;
    IBOutlet UITextField *_userPassword;
    IBOutlet UIButton *_loginButton;
    IBOutlet UIButton *_registerButton;
    
}
- (IBAction)registerAccount:(id)sender;
- (IBAction)startLogin:(id)sender;
@end
