//
//  BaseUIView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-4.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseUIView.h"

@implementation BaseUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)showBadgeValue:(NSString *)strBadgeValue
{
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"" image:nil tag:0];
    item.badgeValue = strBadgeValue;
    NSArray *array = [[NSArray alloc] initWithObjects:item, nil];
    tabBar.items = array;
    [item release];
    [array release];
    //寻找
    for (UIView *viewTab in tabBar.subviews) {
        for (UIView *subview in viewTab.subviews) {
            NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
            if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||
                [strClassName isEqualToString:@"_UIBadgeView"]) {
                //从原视图上移除
                [subview removeFromSuperview];
                //
                [self addSubview:subview];
                subview.frame = CGRectMake(self.frame.size.width-subview.frame.size.width, 0,
                                           subview.frame.size.width, subview.frame.size.height);
                [tabBar release];
                return subview;
            }
        }
    }
    [tabBar release];
    return nil;
}

- (void)removeBadgeValue
{
    //
    for (UIView *subview in self.subviews) {
        NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
        if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||
            [strClassName isEqualToString:@"_UIBadgeView"]) {
            [subview removeFromSuperview];
            break;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
