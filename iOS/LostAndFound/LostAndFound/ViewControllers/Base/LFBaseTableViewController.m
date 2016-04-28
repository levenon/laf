//
//  LFBaseTableViewController.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-10.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <XLFKeyboardManagerKit/XLFKeyboardManagerKit.h>
#import "LFBaseTableViewController.h"
#import "LFHttpRequestManager.h"

@implementation LFBaseTableViewController

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
