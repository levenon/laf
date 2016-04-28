//
//  FindPasswordVC.h
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLFCommonKit/XLFCommonKit.h>
#import "LFBaseViewController.h"

@interface LFFindPasswordVC : LFBaseViewController

@property(nonatomic, copy, readonly) void(^evblcFindPasswordCallback)(LFFindPasswordVC *findPasswordVC, BOOL success, NSString *username, NSString *password);

- (id)initWithFindPasswordCallback:(void (^)(LFFindPasswordVC *findPasswordVC, BOOL success, NSString *username, NSString *password))findPasswordCallback;

@end
