//
//  AtzcUserHeaderView.h
//  AtzcUserHeader
//
//  Created by 夏兆伟 on 13-11-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIColor;
@interface AtzcUserHeaderView : UIImageView


@property (nonatomic,assign) UIColor *boderColor;
@property (nonatomic,assign) int borderWidth;
-(void)setHeadImage:(NSString*)imageURL;
@end
