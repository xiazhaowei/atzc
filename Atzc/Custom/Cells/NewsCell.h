//
//  NewsCell.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-26.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsInfoModel;
@interface NewsCell : UITableViewCell
{
    UIImageView *_pic;
    UILabel *_title;
    UILabel *_content;
    UILabel *_comments;
    UILabel *_createtime;
}
@property (nonatomic,assign) NewsInfoModel *newsInfoModel;
@end
