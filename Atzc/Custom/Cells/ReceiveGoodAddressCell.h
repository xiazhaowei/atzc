//
//  ReceiveGoodAddressCell.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-31.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReceiveGoodAddressModel;
@interface ReceiveGoodAddressCell : UITableViewCell
{
    UILabel *receiverNameTitle;
    UILabel *receiverName;
    UILabel *receiverMobileTitle;
    UILabel *receiverMobile;
    UILabel *detailAddressTitle;
    UILabel *detailAddress;
    UILabel *zipTitle;
    UILabel *zip;
}
@property (nonatomic,assign) ReceiveGoodAddressModel *receiveGoodAddressModel;
@end
