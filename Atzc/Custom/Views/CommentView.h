//
//  CommentCell.h
//  Atzc 评论列表 单元格
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView
{
    CommentModel *_commentModel;
    AtzcUserHeaderView *_userHeaderImage;
    UILabel *_username;
    UILabel *_content;
    UILabel *_createtime;
}
@property (nonatomic,assign) CommentModel *commentModel;
@end
