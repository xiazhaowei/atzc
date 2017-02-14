//
//  AtzcUserHeaderView.m
//  AtzcUserHeader
//
//  Created by 夏兆伟 on 13-11-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "AtzcUserHeaderView.h"

#define kImageBorderWidth 14

@implementation AtzcUserHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth=kImageBorderWidth;
    }
    return self;
}

-(void)setImage:(UIImage *)image
{    
    //方法2
    NSArray *array1 = [[NSArray alloc] initWithObjects:
                       [NSValue valueWithCGPoint:CGPointMake(30, 20)],
                       [NSValue valueWithCGPoint:CGPointMake(0, 100)],
                       [NSValue valueWithCGPoint:CGPointMake(85, 166)],
                       [NSValue valueWithCGPoint:CGPointMake(165, 110)],
                       [NSValue valueWithCGPoint:CGPointMake(155, 30)],
                       nil];
    //UIImage *img= [self pathImage:image pointsArray:array1 withParam:0];
    UIImage *img=[self circleImage:image withParam:0];
    [super setImage:img];
    //self.contentMode=UIViewContentModeBottomRight;
}
//设置头像
-(void)setHeadImage:(NSString*)imageURL
{
    //异步请求网络设置图片
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [self setImage:[UIImage imageNamed:@"20131105085458tSfOY.jpg"]];
//        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self setImage:img];
//        });
//    });
    
    [self setImageWithURL:[NSURL URLWithString:imageURL]];
}

//添加图片遮罩
-(void)setImageMask
{
     //添加遮罩  方法1
     CALayer *mask = [CALayer layer];
     UIImage *maskImg=[UIImage imageNamed:@"logo"];
     mask.contents = (id)[maskImg CGImage];
     mask.frame = CGRectMake(0, 0, maskImg.size.width, maskImg.size.height);
     self.layer.mask=mask;
     self.layer.masksToBounds=YES;
}
//绘制圆形头像 inset为内部白
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    //准备图片画布-图片大小
    UIGraphicsBeginImageContext(image.size);
    //取得当前context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画布的边框宽度
    CGContextSetLineWidth(context, self.borderWidth);
    //设置画布边框颜色
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //设置绘图区域
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    //添加一个椭圆到绘图区域
    CGContextAddEllipseInRect(context, rect);
    //裁剪绘图区域
    CGContextClip(context);
    
    //在裁剪的绘图区域绘图
    [image drawInRect:rect];
    //添加一个椭圆到绘图区域
    CGContextAddEllipseInRect(context, rect);
    //区域绘图
    CGContextStrokePath(context);
    //从绘图区域得到 图片
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();//结束绘图
    return newimg;
}
//绘制多边形头像 inset为内部白
-(UIImage*) pathImage:(UIImage*) image pointsArray:(NSArray *) points withParam:(CGFloat) inset {
    //准备图片画布-图片大小
    UIGraphicsBeginImageContext(image.size);
    //取得当前context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置画布的边框宽度
    CGContextSetLineWidth(context, self.borderWidth);
    //设置画布边框颜色
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //设置绘图区域
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    //添加一个多边形到绘图区域
    CGAffineTransform t = CGAffineTransformMakeTranslation(-CGRectGetMinX(self.frame), -CGRectGetMinY(self.frame));
    CGPathRef path = [self pathFromPoints:points];
    CGContextAddPath(context, CGPathCreateCopyByTransformingPath(path, &t));
    CGPathCreateCopy(path);
    //裁剪绘图区域
    CGContextClip(context);
    
    //在裁剪的绘图区域绘图
    [image drawInRect:rect];
    //添加一个椭圆到绘图区域
    //CGContextAddEllipseInRect(context, rect);
    CGContextAddPath(context, path);
    //区域绘图
    CGContextStrokePath(context);
    //从绘图区域得到 图片
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();//结束绘图
    return newimg;
}

//通过点绘制多边形
-(CGPathRef)pathFromPoints:(NSArray*)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[[points objectAtIndex:0] CGPointValue]];
    
    NSInteger count = points.count;
    for (NSInteger i = 1; i<count; i++)
    {
        [path addLineToPoint:[[points objectAtIndex:i] CGPointValue]];
    }
    [path closePath];
    
    return CGPathCreateCopy(path.CGPath);
}
-(id)initWithPoints:(NSArray*)points
{
    CGPathRef path = [self pathFromPoints:points];
    
    self = [super initWithFrame:CGPathGetBoundingBox(path)];
    
    if (self)
    {
        [self setUserInteractionEnabled:YES];
        CGAffineTransform t = CGAffineTransformMakeTranslation(-CGRectGetMinX(self.frame), -CGRectGetMinY(self.frame));
        //[self.layer setPath:CGPathCreateCopyByTransformingPath(path, &t)];
        
        //[[self layer] setFillMode:kCAFillRuleNonZero];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
