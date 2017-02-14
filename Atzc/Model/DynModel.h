//
//  DynCellDataModel.h
//  Atzc 动态数据
//
//  Created by 夏兆伟 on 13-12-10.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynModel : NSObject

@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int cID;
@property (nonatomic, copy) NSString *DynType;
@property (nonatomic, copy) NSString *PostTime;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, retain) NSMutableArray *Pics;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, retain) UserModel *Publicer;
@property (nonatomic, retain) NSMutableArray *Comments;
@end
