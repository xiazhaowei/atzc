//
//  SendMessageViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "SendMessageViewController.h"
#import "ChatSelectionView.h"
#import "XMPPMessage.h"
#import "MessageCell.h"
#import "UIFactory.h"
#import "FriendViewController.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"


@interface SendMessageViewController ()
{
    BOOL isAudio;
    AVAudioRecorder *recorder;
    NSURL *urlPlay;
}
@end

@implementation SendMessageViewController
@synthesize recorderVC;
@synthesize originWav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置标题为聊天的用户名称
    self.navigationItem.title= _chatPerson.UserName;
    
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
    //初始化聊天窗口
    [self initViewController];
    
    //异步设置用户头像
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        _myHeadImage=[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_Head]]]]retain];
        _userHeadImage=[[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_chatPerson.Header]]]retain];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [msgRecordTable reloadData];
        });
    });
    
    //添加一个手势 点击 取消键盘
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    //手势添加到表格
    [msgRecordTable addGestureRecognizer:tap];
    
    //新 变化键盘的通知
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    //加载聊天记录信息
    [self refresh];
}

//初始化视图
-(void)initViewController
{
    //消息表格
    msgRecordTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-59)];
    
    msgRecordTable.dataSource=self;
    msgRecordTable.delegate=self;
    //表格无背景无分隔符
    UIView *tablebg=[[UIView alloc] initWithFrame:msgRecordTable.frame];
    tablebg.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"chartbg"]];
    [msgRecordTable setBackgroundView:tablebg];
    [tablebg release];
    [msgRecordTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:msgRecordTable];
    
    inputBar=[[UIView alloc] initWithFrame:CGRectMake(0, msgRecordTable.bottom, ScreenWidth, 59)];
    inputBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"ToolViewBkg_Black"]];

    
    //录音按钮
    UIButton *voicButton=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 33, 33)];
    [voicButton setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
    [voicButton setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted ];
    [voicButton addTarget:self action:@selector(shareVoice:) forControlEvents:UIControlEventTouchUpInside];
    [inputBar addSubview:voicButton];
    [voicButton release];
    
    //输入框
    messageText=[[UITextField alloc] initWithFrame:CGRectMake(50, 5, 180, 33)];
    messageText.borderStyle=UITextBorderStyleRoundedRect;
    messageText.backgroundColor=[UIColor whiteColor];
    [messageText addTarget:self action:@selector(sendIt:) forControlEvents:UIControlEventEditingDidEnd];
    [inputBar addSubview:messageText];
    
    //表情按钮
    UIButton *faceButton=[[UIButton alloc] initWithFrame:CGRectMake(238, 5, 33, 33)];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted ];
    [faceButton addTarget:self action:@selector(shareFace:) forControlEvents:UIControlEventTouchUpInside];
    [inputBar addSubview:faceButton];
    [faceButton release];
    
    //更多按钮
    UIButton *moreButton=[[UIButton alloc] initWithFrame:CGRectMake(275, 5, 33, 33)];    
    [moreButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
    [moreButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted ];
    [moreButton addTarget:self action:@selector(shareMore:) forControlEvents:UIControlEventTouchUpInside];
    [inputBar addSubview:moreButton];
    [moreButton release];
    
    [self.view addSubview:inputBar];
    
    //发送更多面板
    _shareMoreView =[[ChatSelectionView alloc]init];
    [_shareMoreView setFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    [_shareMoreView setDelegate:self];
    
    //发送表情面板
    _shareFaceView =[[ChatFaceSelectionView alloc]init];
    [_shareFaceView setFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    [_shareFaceView setDelegate:self];
    
    //发送语音面板
    _shareVoiceView =[[ChatVoiceSelectionView alloc]init];
    [_shareVoiceView setFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    [_shareVoiceView setDelegate:self];
    
    //初始化录音vc
    recorderVC = [[ChatVoiceRecorderVC alloc]init];
    recorderVC.vrbDelegate=self;
    
    //初始化用户详情按钮
    [self initUserInfoButtonItem];
}

//初始化用户详情按钮
-(void)initUserInfoButtonItem
{
    //创建自定义按钮 通过主题工厂创建
    UIButton *button = [UIFactory createButton:@"friendinfo_icon.png" highlighted:@"friendinfo_icon.png"];
    button.frame = CGRectMake(0, 0, 24, 24);
    //按钮添加动作
    [button addTarget:self action:@selector(showUserInfo) forControlEvents:UIControlEventTouchUpInside];
    //创建barbuttonitem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    //添加到导航栏
    self.navigationItem.rightBarButtonItem = [backItem autorelease];
}

//导航到用户详情页
-(void)showUserInfo
{
    FriendViewController *friendCtrl = [[FriendViewController alloc] init];
    friendCtrl.userFriendModel=self.chatPerson;
    [self.navigationController pushViewController:friendCtrl animated:YES];
    [friendCtrl release];
}

//刷新窗口
-(void)refresh
{
    [messageText setInputView:nil];
    [messageText resignFirstResponder];
    //获得用户的聊天记录
    msgRecords =[MessageModel fetchMessageListWithUser:_chatPerson.UserAccount byPage:1];
    NSLog(@"聊天记录：%i",msgRecords.count);
    if (msgRecords.count!=0) {
        //聊天记录加载到表格中
        [msgRecordTable reloadData];
        //表格滑动到最底层
        [msgRecordTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:msgRecords.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}
#pragma mark ----键盘高度变化------

-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获取到键盘frame 变化之前的frame
//    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGRect beginRect=[keyboardBeginBounds CGRectValue];
//    
//    //获取到键盘frame变化之后的frame
//    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    CGRect endRect=[keyboardEndBounds CGRectValue];
//    
//    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
//    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
//    
//    [CATransaction begin];
//    [UIView animateWithDuration:0.4f animations:^{
//        //主view视图向上
//        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
//        [msgRecordTable setContentInset:UIEdgeInsetsMake(msgRecordTable.contentInset.top-deltaY, 0, 0, 0)];
//        
//    } completion:nil];
//    [CATransaction commit];
}



//发送文字消息
- (void)sendIt:(id)sender {
    
    NSString *message = messageText.text;
    if (message.length > 0) {
        
        //生成XMPP消息对象
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",_chatPerson.UserAccount] domain:@"www.atzc.net" resource:@"IOS"]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:message]];
        
        //发送消息
        [[AtzcXMPPManager sharedInstance] sendMessage:mes];       
        
    }
    [messageText setText:nil];
}

//发送图片
-(void)sendImage:(UIImage *)aImage
{
    NSLog(@"准备发送图片");
    
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"请稍后" message:@"文件正在传送中..." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [av show];
    [av release];
    //图片转换为文字
    NSString *message = [Photo image2String:aImage];
    
    if (message.length > 0) {
        //生成消息对象
        XMPPMessage *mes=[XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",_chatPerson.UserAccount] domain:@"www.atzc.net" resource:@"Resourece"]];
        [mes addChild:[DDXMLNode elementWithName:@"body" stringValue:[NSString stringWithFormat:@"[1]%@",message]]];
        
        //发送消息
        [[AtzcXMPPManager sharedInstance] sendMessage:mes];
    }
}


//发送更多
- (void)shareMore:(id)sender {
    
    [messageText setInputView:messageText.inputView?nil: _shareMoreView];
    
    [messageText reloadInputViews];
    [messageText becomeFirstResponder];
}
//发送语音
- (void)shareVoice:(id)sender {
    [messageText setInputView:messageText.inputView?nil: _shareVoiceView];
    
    [messageText reloadInputViews];
    [messageText becomeFirstResponder];
    
}
//添加表情
- (void)shareFace:(id)sender {
    [messageText setInputView:messageText.inputView?nil: _shareFaceView];
    
    [messageText reloadInputViews];
    [messageText becomeFirstResponder];
    
}

#pragma mark chatvoicselection  录音代理
//长按开始录音
- (void)beginAudio
{
    NSLog(@"按钮开始代理");
    //设置文件名
    self.originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    //开始录音
    [recorderVC beginRecordByFileName:self.originWav];
}
//长按录音结束
- (void)endAudio
{
    //录音结束将wav文件 转换为amr
    [VoiceConverter wavToAmr:[VoiceRecorderBaseVC getPathByFileName:originWav ofType:@"wav"] amrSavePath:[VoiceRecorderBaseVC getPathByFileName:self.originWav ofType:@"amr"]];
    
}
//取消发送录音
-(void)cancleAudio
{
    
}
#pragma mark - VoiceRecorderBaseVC 录音完成回调

//录音完成回调，返回文件路径和文件名 并发送
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //声音文件路径
    NSString *path = [[[paths objectAtIndex:0]stringByAppendingPathComponent:@"Voice"] stringByAppendingPathComponent:[[_fileName stringByAppendingString:@".amr"] stringByReplacingOccurrencesOfString:@".wav" withString:@""]];
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    
    //如果找到刚刚录制的声音文件
    if ([fileManager fileExistsAtPath:path]) {
        //声音文件转换为数据
        NSData *data = [NSData dataWithContentsOfFile:path];
        //数据转换为base64字符串
        NSString *base64 = [data base64EncodedString];
        //发送声音字符文件
        [self sendAudio:base64 withName:_fileName];
    }
}


//发送录音数据
-(void)sendAudio:(NSString *)base64String withName:(NSString *)audioName{
    
    //语音字符数据
    NSMutableString *soundString = [[NSMutableString alloc]initWithString:@"base64"];
    [soundString appendString:base64String];
    //消息对象
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithUser:[NSString stringWithFormat:@"%@",_chatPerson.UserAccount] domain:@"www.atzc.net" resource:@"IOS"]];
    [message addBody:soundString];
    //发送数据
    [[AtzcXMPPManager sharedInstance] sendMessage:message];
}

#pragma mark   ---------tableView协议----------------
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgRecords.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"messageCell";
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[[MessageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]autorelease];
    }
    //消息队列中的消息对象
    MessageModel *msg=[msgRecords objectAtIndex:indexPath.row];
    //消息对象添加到cell中
    [cell setMessageObject:msg];
    //消息类型 我的？ 别人的？带不带图片？
    enum kWCMessageCellStyle style=[msg.messageFrom isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:kXMPPmyJID]]?kWCMessageCellStyleMe:kWCMessageCellStyleOther;
    //根据类型设置头像和样式
    switch (style) {
        case kWCMessageCellStyleMe:
            [cell setHeadImage:_myHeadImage];
            break;
        case kWCMessageCellStyleOther:
            [cell setHeadImage:_userHeadImage];
            break;
        case kWCMessageCellStyleMeWithImage:
        {
            [cell setHeadImage:_myHeadImage];
        }
            break;
        case kWCMessageCellStyleOtherWithImage:{
            [cell setHeadImage:_userHeadImage];
        }
            break;
        default:
            break;
    }
    //判断是否是图片信息
    if ([msg.messageType intValue]==kWCMessageTypeImage) {
        style=style==kWCMessageCellStyleMe?kWCMessageCellStyleMeWithImage:kWCMessageCellStyleOtherWithImage;
        
        //设置cell的图片
        [cell setChatImage:[Photo string2Image:msg.messageContent ]];
    }
    
    //设置样式
    [cell setMsgStyle:style];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}
//设置单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果消息是图片视图就返回 原尺寸 + 100；
    if( [[msgRecords[indexPath.row] messageType]intValue]==kWCMessageTypeImage)
        return 55+100;
    else{//不是的话通过文字计算高度
        
        NSString *orgin=[msgRecords[indexPath.row]messageContent];
        CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
        return 55+textSize.height;
    }
}

#pragma mark  接受新消息广播
-(void)newMsgCome:(NSNotification *)notifacation
{
    [self.tabBarController.tabBarItem setBadgeValue:@"1"];
    //[WCMessageObject save:notifacation.object];
    [self refresh];
}


#pragma mark sharemore 按钮组协议
//选择发送图片
-(void)pickPhoto
{
    //图片选中器  系统自带
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    //通过相册选择图片
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setDelegate:self];
    [imgPicker setAllowsEditing:YES];
    //显示图片选中器视图控制器
    [self.navigationController presentViewController:imgPicker animated:YES completion:^{
    }];
}


#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage  * chosedImage=[[info objectForKey:@"UIImagePickerControllerEditedImage"]retain];
    //图片选择完成显示源视图
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //设置选中的图片
        [self sendImage:chosedImage];
    }];
}
//取消选择
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [msgRecordTable release];
    [messageText release];
    [inputBar release];
    [_shareMoreView release];
    _shareMoreView=nil;
    [super dealloc];
}
@end
