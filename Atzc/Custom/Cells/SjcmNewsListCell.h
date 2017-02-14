//
//  SjcmNewsListCell.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-23.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CsInfoModel;
@interface SjcmNewsListCell : UITableViewCell
{
    UIImageView *_pic;
    UILabel *_title;
    UILabel *_content;
    UILabel *_price;
    UILabel *_createtime;
}

@property (nonatomic,assign) CsInfoModel *csInfoModel;
@end
