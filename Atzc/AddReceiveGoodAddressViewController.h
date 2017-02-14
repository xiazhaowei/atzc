//
//  AddReceiveGoodAddressViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-31.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "UIPlaceHolderTextView.h"
#import "SSCheckBoxView.h"

@interface AddReceiveGoodAddressViewController : BaseViewController
{
    ReceiveGoodAddressModel *_receiveGoodAddressModel;
    
    UIScrollView *mainScrollView;
    UITextField *textReceiverName;
    UITextField *textReceiverMobile;
    UIPlaceHolderTextView *textReceiverAddress;
    UITextField *textZip;
    SSCheckBoxView *checkboxDefaultAddress;
}
@property (nonatomic,assign) ReceiveGoodAddressModel *receiveGoodAddressModel;
@end
