//
//  DynCell.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-4.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CommentBtnDelegate <NSObject>

-(void)showkeyboard:(DynModel *)dynModel;

@end

@interface DynCell : UITableViewCell
{
@private
    AtzcUserHeaderView *_headerView;
    UILabel            *_userNameLabel;
    UILabel            *_titleLabel;
    UILabel            *_timeLabel;
    UILabel            *_contentLabel;
    UIButton           *_commentBtn;
}
@property(assign,nonatomic)id<CommentBtnDelegate> delegate;
@property (nonatomic,retain) DynModel *dynModel;
@property (nonatomic,assign) CGSize headerViewSize;
@end
