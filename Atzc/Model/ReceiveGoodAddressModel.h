//
//  ReceiveGoodAddressModel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-31.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveGoodAddressModel : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,copy) NSString *ReceiverName;
@property (nonatomic,copy) NSString *ReceiverMobile;
@property (nonatomic,copy) NSString *DetailAddress;
@property (nonatomic,copy) NSString *Zip;
@property (nonatomic,assign) BOOL IsDefault;
@end
