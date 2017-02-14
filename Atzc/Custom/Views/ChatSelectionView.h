//
//  ChatSelectionView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol ShareMoreDelegate <NSObject>

@optional
-(void)pickPhoto;
-(UIImage *)imageDidFinishPicking;
-(UIImage *)cameraDidFinishPicking;
-(CLLocation *)locationDidFinishPicking;

@end

@interface ChatSelectionView : UIView

@property (nonatomic,assign) id<ShareMoreDelegate> delegate;
@property (nonatomic,retain) UIButton *photoButton;
@property (nonatomic,retain) UIButton *cameraButton;
@property (nonatomic,retain) UIButton *locationButton;
@property (nonatomic,retain) UIButton *vcardButton;
@property (nonatomic,retain) UIButton *voipChatButton;
@property (nonatomic,retain) UIButton *videoChatButton;
@property (nonatomic,retain) UIButton *voidInputButton;
@property (nonatomic,retain) UIButton *moreButton;

@end
