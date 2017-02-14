//
//  CollectView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-26.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectMessageDelegate <NSObject>
@optional
-(void)CollectMessage;
@end

@interface CollectView : UIView
{
    UIImageView *_msgicon;
    UILabel     *_phone;
}
@property (nonatomic,assign) id<CollectMessageDelegate> delegate;
@end
