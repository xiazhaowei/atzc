//
//  BaseUIView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseUIView : UIView

- (UIView *)showBadgeValue:(NSString *)strBadgeValue;
- (void)removeBadgeValue;
@end
