//
//  VideoModel.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-7.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Pic;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,copy) NSString *VideoPath;
@property (nonatomic,retain) NSMutableArray *Comments;
@property (nonatomic,retain) UserModel *Publicer;
@end
