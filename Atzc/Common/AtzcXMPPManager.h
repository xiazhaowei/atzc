//
//  AtzcXMPPManager.h
//  Atzc xmpp处理对象
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "XMPPFramework.h"

@class XMPPMessage,XMPPRoster,XMPPRosterCoreDataStorage;
@interface AtzcXMPPManager : NSObject
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
   	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
}
- (NSManagedObjectContext *)managedObjectContext_roster;
@property (readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)connect;
- (void)disconnect;

//公共实例
+(AtzcXMPPManager*)sharedInstance;


#pragma mark -------配置XML流-----------

- (void)setupStream;
- (void)teardownStream;


#pragma mark ----------收发信息------------
- (void)goOnline;
- (void)goOffline;

- (void)sendMessage:(XMPPMessage *)aMessage;
- (void)addSomeBody:(NSString *)userId;


#pragma mark ---------文件传输-----------
-(void)sendFile:(NSData*)aData toJID:(XMPPJID*)aJID;

@end
