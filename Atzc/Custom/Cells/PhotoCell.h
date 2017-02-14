//
//  PhotoCell.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-6.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell
{
    UIImageView *_imgView;
}
@property (nonatomic,retain) PhotoModel *photoModel;
@property (nonatomic,retain) UIImageView *imgView;
@end
