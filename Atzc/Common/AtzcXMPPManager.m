//
//  AtzcXMPPManager.m
//  Atzc xmpp处理对象
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "AtzcXMPPManager.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilities.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPRoster.h"
#import "XMPPMessage.h"
#import "TURNSocket.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

#define DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define CACHES_PATH NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]


@implementation AtzcXMPPManager


static AtzcXMPPManager *sharedManager;

#pragma mark 私有方法
//获得公共实例 连接到服务器
+(AtzcXMPPManager*)sharedInstance{
    
    static dispatch_once_t onceToken;
    //只调用一次
    dispatch_once(&onceToken, ^{
        
        //这里的代码只执行一次
        sharedManager=[[AtzcXMPPManager alloc]init];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        //存储XMPP用户ID 密码   密码应该改为md5加密的数据
        [[NSUserDefaults standardUserDefaults]setObject:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ACCOUNT] forKey:kXMPPmyJID];
        //NSString *userpas=[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults]setObject:[self md5HexDigest:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD]] forKey:kXMPPmyPassword];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [sharedManager setupStream];
    });
    
    return sharedManager;
}

//MD5
+(NSString *)md5HexDigest:(NSString*)input
{    
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

#pragma mark - Application's Documents directory 应用程序目录

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma  mark ------收发消息-------
- (void)sendMessage:(XMPPMessage *)aMessage
{
    //发送到服务器
    [xmppStream sendElement:aMessage];
    
    NSString *body = [[aMessage elementForName:@"body"] stringValue];
    
    // NSString *meesageStyle=[[aMessage attributeForName:@"type"] stringValue];
    NSString *meesageTo = [[aMessage to]bare];
    
    NSLog(@"messateToStr:%@",meesageTo);
    
    //消息接受者用@隔开 之前方法
    //NSArray *strs=[meesageTo componentsSeparatedByString:@"@"];
    //现在从后面搜索
	NSRange atRange = [meesageTo rangeOfString:@"@" options:NSBackwardsSearch];
    
    NSString *toUser = [meesageTo substringToIndex:atRange.location];
    
    //创建message对象 存储到数据库
    MessageModel *msg=[[MessageModel alloc]init];
    [msg setMessageDate:[NSDate date]];
    
    //消息的接受者和发送者  存储到数据库的应该是用户的 id
    [msg setMessageFrom:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ACCOUNT]];
    //[msg setMessageTo:strs[0]];
    [msg setMessageTo:toUser];
    
    //判断多媒体消息 body 的前 3 个字符 判断类型
    if ([[body substringToIndex:3]isEqualToString:@"[1]"]) {
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypeImage]];
        body=[body substringFromIndex:3];
    }else
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    
    [msg setMessageContent:body];
    
    [MessageModel save:msg];
    
    //发送全局通知
    //    [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:msg ];
    //    [msg release];
}



#pragma mark --------配置XML流---------
//配置xmppstream 并连接
- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
	xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
        xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	
	//连接对象
	xmppReconnect = [[XMPPReconnect alloc] init];
	
    // Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.
	
	// Activate xmpp modules
    //创建通讯录存储对象
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	//通讯录对象
	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
	[xmppReconnect         activate:xmppStream];
    [xmppRoster            activate:xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    //stream的代理
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];

    
	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.
	
	[xmppStream setHostName:kXMPPHost];
	[xmppStream setHostPort:kXMPPPort];
    
	// You may need to alter these settings depending on the server you're connecting to
//	allowSelfSignedCertificates = NO;
//	allowSSLHostNameMismatch = NO;
    
    //连接服务器
    if (![self connect]) {        
        [[[UIAlertView alloc]initWithTitle:@"服务器连接失败" message:@"服务器连接失败" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    };
}


// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

//上线发送上线通知
- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[xmppStream sendElement:presence];
}
//下线 发送下线通知
- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[xmppStream sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect  连接 取消 连接
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//连接服务器 是否连接
- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
//    NSLog(@"xmpp用户：%@",myJID);
//    NSLog(@"xmpp密码：%@",myPassword);
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	// ===这句注释掉 改成下面这句   [xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    [xmppStream setMyJID:[XMPPJID jidWithUser:myJID domain:@"www.atzc.net" resource:@"IOS"]];
    password=myPassword;
    
	NSError *error = nil;
	//if (![xmppStream connect:&error])
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		//DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}
//取消连接
- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIApplicationDelegate 应用程序代理
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//程序在后台运行
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	//
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.
	
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
}
//程序进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}
// Returns the URL to the application's Documents directory.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate xmppstream 代理
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//socket将要连接
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

//stream已经连接 然后发送验证信息
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![xmppStream authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}
//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
    [xmppRoster fetchRoster];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);
    
	return NO;
}
//收到新消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSString *body = [[message elementForName:@"body"] stringValue];
    NSString *displayName = [[message from]bare];
    
    [[[UIAlertView alloc]initWithTitle:@"收到新消息" message:body delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil]show];
    
    //创建message对象 并保存
    MessageModel *msg=[MessageModel messageWithType:kWCMessageTypePlain];
    //之前用@隔开
    //NSArray *strs=[displayName componentsSeparatedByString:@"@"];
    //现在从后面搜索
	NSRange atRange = [displayName rangeOfString:@"@" options:NSBackwardsSearch];
    
    NSString *fromUser = [displayName substringToIndex:atRange.location];
    
    [msg setMessageDate:[NSDate date]];
    [msg setMessageFrom:fromUser];
    [msg setMessageContent:body];
    [msg setMessageTo:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ACCOUNT]];
    [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];
    
    //如果没有保存好友就保存到好友列表--加为好友
//    if (![UserModel haveSaveUserByAccount:fromUser]) {
//        [self fetchUser:fromUser];
//    }
    
    //通过判断消息的前三个字节来判断消息的类型  应该在PC客户端发送信息时添加这三个字节 [0]文字信息 [1]为图片信息 [2]语音信息
    if ([[body substringToIndex:3]isEqualToString:@"[1]"]) {
        
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypeImage]];
        body=[body substringFromIndex:3];
    }else
        [msg setMessageType:[NSNumber numberWithInt:kWCMessageTypePlain]];    
    
    [msg setMessageContent:body];
    [MessageModel save:msg];
    
    //如果应用程序不是激活状态 显示通知
    if([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive)
    {
        // We are not active, so use a local notification instead
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Ok";
        localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",@"消息:",@"123"];
        //显示通知
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
	
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate  通讯录代理
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
    XMPPJID *jid=[XMPPJID jidWithString:[presence stringValue]];
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

- (void)addSomeBody:(NSString *)userId
{
    [xmppRoster subscribePresenceToUser:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@www.atzc.net/IOS",userId]]];
}

//取出好友
-(void)fetchUser:(NSString*)userId
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"加载中" message:@"刷新好友列表中，请稍候" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
    [av release];
    
    //此API使用方式请查看www.hcios.com:8080/user/findUser.html
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:API_BASE_URL(@"servlet/GetUserDetailServlet")];
    
    [request setPostValue:userId forKey:@"userId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
}

-(void)fetchUserByAccount:(NSString*)userAccount
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"加载中" message:@"刷新好友列表中，请稍候" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
    [av release];
    
    //此API使用方式请查看www.hcios.com:8080/user/findUser.html
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:API_BASE_URL(@"servlet/GetUserDetailServlet")];
    
    [request setPostValue:userAccount forKey:@"userId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
}
//请求好友列表成功
-(void)requestSuccess:(ASIFormDataRequest*)request
{
    NSLog(@"response:%@",request.responseString);
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *rootDic=[paser objectWithString:request.responseString];
    int resultCode=[[rootDic objectForKey:@"result_code"]intValue];
    if (resultCode==1) {
        NSDictionary *dic=[rootDic objectForKey:@"data"];
        UserModel *user=[UserModel userFromDictionary:dic];
        [UserModel saveNewUser:user];
    }
    
}
-(void)requestError:(ASIFormDataRequest*)request
{
    
}

//关闭stream流
- (void)teardownStream
{
    //取消代理
	[xmppStream removeDelegate:self];
	//连接不活动
	[xmppReconnect deactivate];
	//不连接
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
}


- (void)dealloc
{
    [super dealloc];
	[self teardownStream];
}

@end
