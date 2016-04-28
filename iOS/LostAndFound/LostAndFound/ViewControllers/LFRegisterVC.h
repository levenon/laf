//
//  RegisterVC.h
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLFCommonKit/XLFCommonKit.h>
#import "LFBaseViewController.h"

@interface LFRegisterVC : LFBaseViewController

@property(nonatomic, copy, readonly) void (^evblcRegisterCallback)(LFRegisterVC *registerVC, BOOL success, NSString *username, NSString *password);

- (instancetype)initWithRegisterCallback:(void (^)(LFRegisterVC *registerVC, BOOL success, NSString *username, NSString *password))registerCallback;

@end

