//
//  TDBadgedCell.h
//  TDBadgedTableCell
//	TDBageView  badge
//
//	Any rereleasing of this code is prohibited.
//	Please attribute use of this code within your application
//
//	Any Queries should be directed to hi@tmdvs.me | http://www.tmdvs.me
//	
//  Created by Tim
//  Copyright 2011 Tim Davies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//视图
@interface TDBadgeView : UIView
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, retain)   NSString *badgeString;
@property (nonatomic, assign)   float badgeFontSize;
@property (nonatomic, retain)   UIColor *badgeStringColor;
@property (nonatomic, assign)   UITableViewCell *parent;
@property (nonatomic, retain)   UIColor *badgeColor;
@property (nonatomic, retain)   UIColor *badgeColorHighlighted;
@property (nonatomic, assign)   BOOL showShadow;
@property (nonatomic, assign)   CGFloat radius;

@end







//单元格
@interface TDBadgedCell : UITableViewCell {

}

@property (nonatomic, retain)   NSString *badgeString;
@property (readonly, retain)    TDBadgeView *badge;
@property (readonly, retain)    UIImageView *badgeImage;
@property (nonatomic, retain)    NSString *badgeImageImage;
@property (nonatomic, retain)   UIColor *badgeColor;
@property (nonatomic, retain)   UIColor *badgeColorHighlighted;
@property (nonatomic, assign)   BOOL showShadow;
@property (nonatomic,assign)    CGFloat badgeMarginRight;

@end
