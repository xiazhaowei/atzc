//
//  SendMessageViewController.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatSelectionView.h"
#import "ChatFaceSelectionView.h"
#import "ChatVoiceSelectionView.h"
#import "ChatVoiceRecorderVC.h"
#import "VoiceConverter.h"

@interface SendMessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ShareMoreDelegate>
{
@private
    UITableView *msgRecordTable;
    NSMutableArray *msgRecords;
    UITextField *messageText;
    UIView *inputBar;
    UIImage *_myHeadImage,*_userHeadImage;
    ChatSelectionView *_shareMoreView;
    ChatFaceSelectionView *_shareFaceView;
    ChatVoiceSelectionView *_shareVoiceView;
}
@property (nonatomic,retain) UserModel *chatPerson;
@property (copy, nonatomic) NSString *originWav;
//录音vc
@property (retain, nonatomic)  ChatVoiceRecorderVC  *recorderVC;

@end
