//
//  CompanyListCell.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyListCell : UITableViewCell
{
    UIImageView *_pic;
    UILabel *_title;
    UILabel *_content;    
    UILabel *_createtime;
}
@property (nonatomic,assign) CompanyModel *companyModel;
@end
