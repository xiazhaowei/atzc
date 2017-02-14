//
//  VideoCell.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-7.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UICollectionViewCell
{
    UIImageView *img;
    UILabel     *Title;
}
@property (nonatomic,retain) VideoModel *videoModel;

@end
