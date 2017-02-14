//
//  RegisterViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : UIViewController
{
    IBOutlet UIView *loginNumber;
    IBOutlet UIView *loginPass;
    IBOutlet UITextField *userLoginName;
    IBOutlet UITextField *userPassword;
    IBOutlet UITextField *userNickName;
    IBOutlet UIButton *userHead;
    
}
- (IBAction)changeUserHead:(id)sender;
@end
