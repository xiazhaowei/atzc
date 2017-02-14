//
//  ReceiveGoodAddressCell.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-31.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "ReceiveGoodAddressCell.h"

@implementation ReceiveGoodAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}

-(void)initSubView
{
    //收货人
    receiverNameTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 8, 100, 20)];
    receiverNameTitle.text=@"收件人：";
    receiverNameTitle.textAlignment=NSTextAlignmentRight;
    receiverNameTitle.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:receiverNameTitle];
    
    receiverName=[[UILabel alloc] initWithFrame:CGRectMake(receiverNameTitle.right, receiverNameTitle.top, 200, 20)];
    receiverName.textColor=[UIColor orangeColor];
    receiverName.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:receiverName];
    
    //手机号码
    receiverMobileTitle=[[UILabel alloc] initWithFrame:CGRectMake(receiverNameTitle.left, receiverNameTitle.bottom , receiverNameTitle.width, receiverNameTitle.height)];
    receiverMobileTitle.text=@"手机号码：";
    receiverMobileTitle.textAlignment=NSTextAlignmentRight;
    receiverMobileTitle.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:receiverMobileTitle];
    
    receiverMobile=[[UILabel alloc] initWithFrame:CGRectMake(receiverMobileTitle.right, receiverMobileTitle.top, receiverName.width, receiverName.height)];
    receiverMobile.textColor=[UIColor orangeColor];
    receiverMobile.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:receiverMobile];
    
    //详细地址
    detailAddressTitle=[[UILabel alloc] initWithFrame:CGRectMake(receiverMobileTitle.left, receiverMobileTitle.bottom , receiverNameTitle.width, receiverNameTitle.height)];
    detailAddressTitle.text=@"详细地址：";
    detailAddressTitle.textAlignment=NSTextAlignmentRight;
    detailAddressTitle.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:detailAddressTitle];
    
    detailAddress=[[UILabel alloc] initWithFrame:CGRectMake(detailAddressTitle.right, detailAddressTitle.top, receiverName.width, receiverName.height)];
    detailAddress.textColor=[UIColor orangeColor];
    detailAddress.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:detailAddress];
    
    //邮编
    zipTitle=[[UILabel alloc] initWithFrame:CGRectMake(detailAddressTitle.left, detailAddressTitle.bottom , receiverNameTitle.width, receiverNameTitle.height)];
    zipTitle.text=@"邮编：";
    zipTitle.textAlignment=NSTextAlignmentRight;
    zipTitle.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:zipTitle];
    
    zip=[[UILabel alloc] initWithFrame:CGRectMake(zipTitle.right, zipTitle.top, receiverName.width, receiverName.height)];
    zip.textColor=[UIColor orangeColor];
    zip.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:zip];

}

-(void)setReceiveGoodAddressModel:(ReceiveGoodAddressModel *)receiveGoodAddressModel
{
    receiverName.text=receiveGoodAddressModel.ReceiverName;
    receiverMobile.text=receiveGoodAddressModel.ReceiverMobile;
    detailAddress.text=receiveGoodAddressModel.DetailAddress;
    zip.text=receiveGoodAddressModel.Zip;    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [super dealloc];
    [receiverNameTitle release];receiverNameTitle=nil;
    [receiverName release];receiverName=nil;
    
    [receiverMobileTitle release];receiverMobileTitle=nil;
    [receiverMobile release];receiverMobile=nil;
    
    [detailAddressTitle release];detailAddressTitle=nil;
    [detailAddress release];detailAddress=nil;
    
    [zipTitle release];zipTitle=nil;
    [zip release];zip=nil;
}

@end
