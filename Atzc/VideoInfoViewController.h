//
//  VideoInfoViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-7.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "ALMoviePlayerController.h"

@interface VideoInfoViewController : BaseViewController
{
    ALMoviePlayerController *moviePlayer;
}
@property (nonatomic,retain) VideoModel *videoModel;
@property (nonatomic) CGRect defaultFrame;
@end
