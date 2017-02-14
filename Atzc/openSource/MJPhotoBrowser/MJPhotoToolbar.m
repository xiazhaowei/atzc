//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import "MBProgressHUD+Add.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIButton *_commentImageBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //监听键盘事件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentViewPoint:) name:UIKeyboardWillShowNotification object:nil];
        tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    //评论图片
    _commentImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentImageBtn.frame = CGRectMake(20+btnWidth, 0, btnWidth, btnWidth);
    _commentImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_commentImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon.png"] forState:UIControlStateNormal];
    [_commentImageBtn setImage:[UIImage imageNamed:@"MJPhotoBrowser.bundle/save_icon_highlighted.png"] forState:UIControlStateHighlighted];
    [_commentImageBtn addTarget:self action:@selector(commentImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentImageBtn];

}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

//评论图片 应该弹出键盘
-(void)commentImage
{
    //MJPhoto *photo = _photos[_currentPhotoIndex];
    //添加手势
    [self.superview addGestureRecognizer:tap];
    
    //评论视图
    _mainCommentView=[[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 40)];
    _mainCommentView.backgroundColor=Color(80, 80, 80, 1);
    //评论框
    _commentText=[[UITextField alloc] initWithFrame:CGRectMake(8, 5, 250, 30)];
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.borderStyle=UITextBorderStyleRoundedRect;
    _commentText.returnKeyType=UIReturnKeySend;
    [_mainCommentView addSubview:_commentText];
    
    //发送按钮
    _btnSend = [UIFactory createButton:@"comment_btn.png" highlighted:@"comment_btn.png"];
    _btnSend.frame=CGRectMake(_commentText.right+5, _commentText.top, 50, _commentText.height);
    [_btnSend addTarget:self action:@selector(doComment:) forControlEvents:UIControlEventTouchUpInside];
    [_mainCommentView addSubview:_btnSend];
    
    [self.superview addSubview:_mainCommentView];
    [_commentText becomeFirstResponder];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:@"This is postertwo" userInfo:[NSDictionary dictionaryWithObject:@"value" forKey:@"key"]];
    
}

//发送评论
-(void)doComment:(UIButton*)sender
{
    
}

// 根据键盘状态，调整_mainView的位置
- (void) changeContentViewPoint:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        _mainCommentView.center = CGPointMake(_mainCommentView.center.x, keyBoardEndY - 0 - _mainCommentView.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
        
    }];
}
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [_commentText resignFirstResponder];
    [self.superview removeGestureRecognizer:tap];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", _currentPhotoIndex + 1, _photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
    _saveImageBtn.enabled = photo.image != nil && !photo.save;
}

@end
