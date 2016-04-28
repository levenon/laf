//
//  LFBaseViewController.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-10.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <XLFKeyboardManagerKit/XLFKeyboardManagerKit.h>
#import "LFBaseViewController.h"
#import "LFHttpRequestManager.h"

@interface LFBaseViewController ()

@end

@implementation LFBaseViewController

#pragma mark - accessory

- (UIColor *)evNavigationBarTintColor{
    
    return [UIColor whiteColor];
}

- (NSDictionary *)evNavigationBarTitleTextAttributes{
    
    return @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]};
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


@end
