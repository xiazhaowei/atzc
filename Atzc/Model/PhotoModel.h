//
//  PhotoModel.h
//  Atzc
//
//  Created by 夏兆伟 on 14-1-6.
//  Copyright (c) 2014年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property (nonatomic,assign) int ID;
@property (nonatomic,copy) NSString *PhotoPath;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,retain) NSMutableArray *Comments;
@property (nonatomic,retain) UserModel *Publicer;
@end
