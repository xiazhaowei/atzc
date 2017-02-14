//
//  ChatFaceSelectionView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-19.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShareFaceDelegate <NSObject>

@optional
-(void)pickFace;

@end

@interface ChatFaceSelectionView : UIView

@property (nonatomic,assign) id<ShareFaceDelegate> delegate;
@end
