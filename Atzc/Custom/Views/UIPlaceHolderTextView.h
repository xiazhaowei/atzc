//
//  UIPlaceHolderTextView.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-2.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
@private
    UILabel *placeHolderLabel;
}

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
