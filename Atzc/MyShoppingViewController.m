//
//  MyShoppingViewController.m
//  Atzc
//
//  Created by 夏兆伟 on 13-12-30.
//  Copyright (c) 2013年 夏兆伟. All rights reserved.
//

#import "MyShoppingViewController.h"

@interface MyShoppingViewController ()

@end

@implementation MyShoppingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"我的购物";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
