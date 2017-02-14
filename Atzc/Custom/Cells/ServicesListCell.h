//
//  ServicesListCell.h
//  Atzc 自定义服务导航单元格
//
//  Created by 夏兆伟 on 13-12-2.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDBadgedCell.h"

@interface ServicesListCell :TDBadgedCell
{
@private
    UIImageView *_imgView;
    UILabel     *_titleLabel;
}
@property (nonatomic,assign) NSString *Title;
@property (nonatomic,assign) NSString *Img;
@property (nonatomic,assign) UIImageView *imgView;
@end
