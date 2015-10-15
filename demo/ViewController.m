//
//  ViewController.m
//  demo
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ViewController.h"
#import "DecodeH264DisplayManager.h"

@interface ViewController ()
{
    DecodeH264DisplayManager *manager;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [DecodeH264DisplayManager new];
    UIView *display = [manager displayView:CGRectMake(10, 50, 300, (352/288)*300)];
    [self.view addSubview:display];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)start:(id)sender
{
    [manager DoDecoderWithH264Data:nil length:0 videoWidth:352 videoHeigth:288];
}

@end
