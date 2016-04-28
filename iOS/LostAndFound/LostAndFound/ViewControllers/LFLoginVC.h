//
//  LoginVC.h
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLFCommonKit/XLFCommonKit.h>
#import "LFBaseViewController.h"

@interface LFLoginVC : LFBaseViewController

@property(nonatomic, copy, readonly) void(^evblcLoginCallback)(LFLoginVC *loginVC, BOOL success);

- (id)initWithLoginCallback:(void (^)(LFLoginVC *loginVC, BOOL success))loginCallback;

@end
