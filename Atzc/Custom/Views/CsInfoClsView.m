//
//  CsInfoClsView.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-21.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "CsInfoClsView.h"
#import "ASIFormDataRequest.h"
#import "ScrollClassesView.h"

#define kScrollClassViewHeight 40

@implementation CsInfoClsView
@synthesize classcollection=_classcollection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha=0.95f;
    }
    return self;
}

-(void)setDeepClass:(int)deepClass
{
    _deepClass=deepClass;
    [self getClassData];
}

//请求网络 获得 类别数据
-(void)getClassData
{
    NSString *urlstring=@"http://3g.atzc.net/mobileapi/csinfo/csinfocls.ashx";
    if (self.CsOrCmp==enumCmpInfoClass) {
        urlstring=@"http://3g.atzc.net/mobileapi/cmp/cmpcls.ashx";
    }
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstring]];
    //post参数
    [request setPostValue:[NSString stringWithFormat:@"%i",_deepClass] forKey:@"addclass"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

//请求网络成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    //将下载的数据文件存储到本地
    [AtzcNetWorkServices WirteToJsonFile:@"CsInfoCls.json" JsonData:responseData];
    //解析数据
    [self WarpJosnData:responseData];
    
    if ([self.delegate respondsToSelector:@selector(FilterSjcmNews:)]) {
        [self.delegate FilterSjcmNews:self.classcollection];
    }
}

//请求失败 就从本地读取json文件
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //读取本地json数据
    NSData *jsonData=[AtzcNetWorkServices ReadFromJsonFile:@"CsInfoCls.json"];
    //解析数据
    [self WarpJosnData:jsonData];
}

//解析数据
-(void)WarpJosnData:(NSData *)jsonData
{
    //解析json
    id resultClasses=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
    //根类别属性的集合
    NSArray *rootSubClassAttribute=[resultClasses objectForKey:@"SubClasses"];
    self.classcollection=[resultClasses objectForKey:@"ClassCollection"];
    
    _rootClassModel=[ClassModel alloc];
    _rootClassModel.ClassID=[resultClasses objectForKey:@"ClassID"];
    _rootClassModel.ClassName=[resultClasses objectForKey:@"ClassName"];
    _rootClassModel.NewsCount=[resultClasses objectForKey:@"NewsCount"];
    _rootClassModel.ClassType=[[resultClasses objectForKey:@"ClassType"] intValue];
    
    
    if(rootSubClassAttribute!=nil && rootSubClassAttribute.count>0)
    {
        
        _rootClassAttributes=[[NSMutableArray alloc] initWithCapacity:rootSubClassAttribute.count];
        
        //便利每个根类别属性 或 子类别
        for (id data in rootSubClassAttribute)
        {
            //跟类别属性 或 子类别
            ClassModel *classModel=[ClassModel  alloc];
            classModel.ClassID     = [data objectForKey:@"ClassID"];
            classModel.ClassName   = [data objectForKey:@"ClassName"];
            classModel.NewsCount   = [data objectForKey:@"NewsCount"];
            classModel.ClassType   = [[data objectForKey:@"ClassType"] intValue];            
            
            if([[data objectForKey:@"Selected"] intValue]==1)
                classModel.isSelected =YES;
            else
                classModel.isSelected =NO;
            
            //跟类别属性的子类别属性
            NSArray *SubClassAttribute=[data objectForKey:@"SubClasses"];
            //如果根类别属性包含子类别属性 类别不会再包含子类别
            if (SubClassAttribute!=nil && SubClassAttribute.count>0) {
                
                NSMutableArray *subClassAttributes=[[NSMutableArray alloc] initWithCapacity:SubClassAttribute.count];
                //变量根类别属性的子类别属性
                for (id subdata in SubClassAttribute){
                    ClassModel *subclassModel=[ClassModel alloc];
                    subclassModel.ClassID     = [subdata objectForKey:@"ClassID"];
                    subclassModel.ClassName   = [subdata objectForKey:@"ClassName"];
                    subclassModel.NewsCount   = [subdata objectForKey:@"NewsCount"];
                    subclassModel.ClassType   = [[subdata objectForKey:@"ClassType"] intValue];
                    
                    if([[subdata objectForKey:@"Selected"] intValue]==1)
                        subclassModel.isSelected =YES;
                    else
                        subclassModel.isSelected =NO;
                    [subClassAttributes addObject:subclassModel];
                }
                //跟类别属性的子类别数组
                classModel.SubClasses=subClassAttributes;
            }
            
            [_rootClassAttributes addObject:classModel];
        }
        _rootClassModel.SubClasses=_rootClassAttributes;
    }

    //数据接收完，刷新好友列表界面
    [self refreshUI];
}
//刷新界面
-(void)refreshUI
{
    //删除之前添加的
    for(UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    //如果包含子类别属性 或 子类
    if (_rootClassAttributes!=nil &&_rootClassAttributes.count>0) {
        
        BOOL isclassattribute=YES;
        //根据跟类别集合数组创建多个sollclassview  并且index为偶数的scroll 为灰色背景
        //如果是类别而不是类别属性 就只添加一个scroll
        for (int i= 0;i < _rootClassAttributes.count; i++)
        {
            if (((ClassModel *)_rootClassAttributes[i]).ClassType==kClassItemTypeClassAttribute)
            {
                isclassattribute=YES;
                
                //如果是类别属性
                ScrollClassesView *scrollclassview=[[ScrollClassesView alloc] initWithFrame:CGRectMake(0,i*kScrollClassViewHeight, ScreenWidth, kScrollClassViewHeight)];
                [self addSubview:scrollclassview];
                
                scrollclassview.classModel=_rootClassAttributes[i];
                if(i%2==1)
                    scrollclassview.backgroundColor=Color(231, 236, 240, 1);
                
                [scrollclassview release];
            }
            else if(((ClassModel *)_rootClassAttributes[i]).ClassType==kClassItemTypeClass)
            {
                isclassattribute=NO;
                
                //是否已经创建scrollview
                if (![self isHaveaScrollClassesView]) {
                    //创建一个sollview
                    ScrollClassesView *scrollclassview=[[ScrollClassesView alloc] initWithFrame:CGRectMake(0,i*kScrollClassViewHeight, ScreenWidth, kScrollClassViewHeight)];
                    [self addSubview:scrollclassview];
                    scrollclassview.classModel=_rootClassModel;
                    [scrollclassview release];
               }
            }
        }
        //如果子类是类别属性 高度为多个scrool的高度
        if (isclassattribute) {
            self.frame=CGRectMake(self.left, self.top, self.width, kScrollClassViewHeight*_rootClassAttributes.count);
        }
        else
        {
            self.frame=CGRectMake(self.left, self.top, self.width, kScrollClassViewHeight);
        }
        
    }
    //设置阴影
    [[self layer] setShadowOffset:CGSizeMake(1, 1)];//阴影偏移量
    [[self layer] setShadowRadius:3];//阴影半径
    [[self layer] setShadowOpacity:0.7];//不透明度
    [[self layer] setShadowColor:[UIColor blackColor].CGColor];//阴影颜色
}

//判断是否已经创建scrollClasses
-(BOOL)isHaveaScrollClassesView
{
    BOOL isHase=NO;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ScrollClassesView class]]) {
            isHase= YES;
        }
    }
    return isHase;
}

#pragma mark ClassItemView 的代理

//选择类别 加载类别集合  刷新类别 新类别集合通过代理传出去
-(void)selectClass:(ClassItemView *)classItemView
{
    NSString *urlstring=@"http://3g.atzc.net/mobileapi/csinfo/csinfocls.ashx";
    if (self.CsOrCmp==enumCmpInfoClass) {
        urlstring=@"http://3g.atzc.net/mobileapi/cmp/cmpcls.ashx";
    }
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstring]];
    //post参数 如果是类别属性 就带classes 参数
    if(classItemView.classModel.ClassType==1)
        [request setPostValue:self.classcollection forKey:@"classes"];
    [request setPostValue:classItemView.classModel.ClassID forKey:@"addclass"];
    
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)unSelectClass:(ClassItemView *)classItemView
{
    NSString *urlstring=@"http://3g.atzc.net/mobileapi/csinfo/csinfocls.ashx";
    if (self.CsOrCmp==enumCmpInfoClass) {
        urlstring=@"http://3g.atzc.net/mobileapi/cmp/cmpcls.ashx";
    }
    //请求网络登录
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlstring]];
    //post参数
    if(classItemView.classModel.ClassType==1)
        [request setPostValue:self.classcollection forKey:@"classes"];
    [request setPostValue:classItemView.classModel.ClassID forKey:@"delclass"];
    
    
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)dealloc
{
    [super dealloc];
    [_rootClassAttributes release];
    _rootClassAttributes=nil;
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
