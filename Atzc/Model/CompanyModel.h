//
//  CompanyModel.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

@property (nonatomic,assign) int CompanyID;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Logo;
@property (nonatomic,copy) NSString *Description;
@property (nonatomic,copy) NSString *CreateTime;
@property (nonatomic,retain) NSMutableArray *Comments;
@end
