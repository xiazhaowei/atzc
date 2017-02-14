//
//  AlbumCell.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-6.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlbumCell : UICollectionViewCell
{
    UIImageView *img;
    UILabel     *albumTitle;
}
@property (nonatomic,retain) AlbumModel *albumModel;

@end
