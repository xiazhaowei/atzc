//
//  MeServiceView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeServiceView : UIButton
{
    UIImageView *_icon;
    UILabel     *_title;
}
@property (nonatomic,assign) NSString   *stricon;
@property (nonatomic,assign) NSString   *strtitle;
@end
