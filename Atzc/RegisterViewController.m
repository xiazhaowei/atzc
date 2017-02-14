//
//  RegisterViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-14.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title=@"填写注册信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)nextStep:(id)sender{
    if (self.view==loginNumber) {
        //[loginNumber removeFromSuperview];
        self.view =loginPass;
    }else
    {
        [self startRegister];
    }
}

#pragma mark ------注册新用户--------
//开始注册用户--请求网络
- (void)startRegister
{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.hcios.com:8080/HCAPI2/servlet/RegisterServlet"]];
    [request setPostValue:userLoginName.text forKey:@"userName"];
    [request setPostValue:userPassword.text forKey:@"userPassword"];
    [request setPostValue:userNickName.text forKey:@"userNickname"];
    [request setTimeOutSeconds:1000];
    [request setData:UIImageJPEGRepresentation(userHead.imageView.image,0.01) withFileName:[userLoginName.text stringByAppendingString:@"-head.jpg"] andContentType:@"image/jpeg" forKey:@"userHead"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
    
}

#pragma mark  -------网络请求回调----------
//取出好友回调
-(void)requestSuccess:(ASIFormDataRequest*)request
{
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *rootDic=[paser objectWithString:request.responseString];
    int resultCode=[[rootDic objectForKey:@"result_code"]intValue];
    if (resultCode==1) {
        NSLog(@"注册成功");
        //保存账号信息
        //改返回的JSON数据格式请到 www.hcios.com:8080/user下查看
        
        [[NSUserDefaults standardUserDefaults]setObject:[rootDic objectForKey:@"gid"] forKey:kMY_USER_ID];
        [[NSUserDefaults standardUserDefaults]setObject:userLoginName.text forKey:kMY_USER_LoginName];
        [[NSUserDefaults standardUserDefaults]setObject:userPassword.text forKey:kMY_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults]setObject:[rootDic objectForKey:@"userHead"] forKey:kMY_USER_Head];
        //立刻保存信息
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    }else
    {
        NSLog(@"注册失败,原因:%@",[rootDic objectForKey:@"msg"]);
    }
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request
{
    NSLog(@"请求失败");
}

#pragma mark   ----触摸取消输入----
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}





- (void)dealloc {
    [loginNumber release];
    [loginPass release];
    [userLoginName release];
    [userPassword release];
    [userNickName release];
    [userHead release];
    [super dealloc];
}
- (IBAction)changeUserHead:(id)sender {
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"马上照一张" otherButtonTitles:@"从相册中搞一张", nil ];
    [as showInView:self.view];
    
}



#pragma mark ----------ActionSheet 按钮点击-------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"用户点击的是第%d个按钮",buttonIndex);
    switch (buttonIndex) {
        case 0:
            //照一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{
            }];
            
            
            
        }
            break;
        case 1:
            //搞一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{
            }];
            
            
            
            break;
        }
        default:
            break;
    }
    
    
}


#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage  * userHeadImage=[[info objectForKey:@"UIImagePickerControllerEditedImage"]retain];
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
        CATransition *trans=[CATransition animation];
        [trans setDuration:0.25f];
        [trans setType:@"flip"];
        [trans setSubtype:kCATransitionFromLeft];
        [userHead.imageView.layer addAnimation:trans forKey:nil];
        
        [userHead.imageView setImage:userHeadImage];
    }];
}

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

@end
