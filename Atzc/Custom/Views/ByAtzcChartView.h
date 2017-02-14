//
//  ByAtzcChartView.h
//  Atzc
//
//  Created by 夏兆伟 on 13-12-25.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChartByAtzcDelegate <NSObject>
@optional
    -(void)ChartByAtzc;
@end

@interface ByAtzcChartView : UIView
{
    UIImageView *_msgicon;
    UILabel     *_phone;    
}
@property (nonatomic,assign) id<ChartByAtzcDelegate> delegate;
@end
