//
//  UserModel.h
//  WXWeibo
//
//  Created by wei.chen on 13-1-22.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//


#define kUSER_ID @"userId"
#define kUSER_NICKNAME @"username"
#define kUSER_ACCOUNT @"useraccount"
#define kUSER_DESCRIPTION @"Description"
#define kUSER_USERHEAD @"userHead"
#define kUSER_FRIEND_FLAG @"friendFlag"


@interface UserModel : NSObject

@property(nonatomic,copy)NSString *UserID;           //字符串型的用户UID
@property(nonatomic,copy)NSString *UserAccount;           //字符串型的用户账号
@property(nonatomic,copy)NSString *UserName;            //友好显示名称
@property(nonatomic,copy)NSString *Location;        //用户所在地
@property(nonatomic,copy)NSString *LatestMood;        //用户所在地
@property(nonatomic,copy)NSString *Description;     //用户个人描述
@property(nonatomic,copy)NSString *HomeSpace;             //用户博客地址
@property(nonatomic,copy)NSString * Header;  //用户头像地址，50×50像素
@property(nonatomic,copy)NSString * BigHeader;  //用户大头像地址
@property(nonatomic,copy)NSString * Sex;             //性别，m：男、f：女、n：未知
@property(nonatomic,retain)NSNumber * Money;    //粉丝数
@property(nonatomic,retain)NSNumber * JiFen;   //关注数
@property(nonatomic,retain)NSNumber * Verified;   //是否是微博认证用户，即加V用户，true：是，false：否
@property (nonatomic,retain) NSNumber * friendFlag;

//数据库增删改查
+(BOOL)saveNewUser:(UserModel*)aUser;
+(BOOL)deleteUserById:(NSNumber*)userId;
+(BOOL)updateUser:(UserModel*)newUser;
+(BOOL)haveSaveUserById:(NSString*)userId;
+(BOOL)haveSaveUserByAccount:(NSString*)userAccount;

+(NSMutableArray*)fetchAllFriendsFromLocal;

//将对象转换为字典
-(NSDictionary*)toDictionary;
+(UserModel*)userFromDictionary:(NSDictionary*)aDic;

@end
