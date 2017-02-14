//
//  CsInfoCommentModel.h
//  Atzc 分类信息评论实体类
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,assign) int ParentID;
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,retain) UserModel *Publicer;
@property (nonatomic,copy) NSString *CreateTime;

@end
