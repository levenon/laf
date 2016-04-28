//
//  LFBaseSplitViewController.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-14.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFBaseSplitViewController.h"
#import "LFHttpRequestManager.h"

@interface LFBaseSplitViewController ()

@end

@implementation LFBaseSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{

    if (IOS_VERSION >= 8.0) {

        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{

    return NO;
}


@end
