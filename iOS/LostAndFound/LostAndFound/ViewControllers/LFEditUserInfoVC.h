//
//  EditUserInfoVC.h
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBaseViewController.h"

@interface LFEditUserInfoVC : LFBaseViewController

@property(nonatomic, copy, readonly) LFUser *evUser;

@property(nonatomic, copy, readonly) void (^evblcEditCallback)(LFEditUserInfoVC *editUserInfoVC, BOOL success);

- (instancetype)initWithUser:(LFUser *)user editCallback:(void (^)(LFEditUserInfoVC *editUserInfoVC, BOOL success))editCallback;

@end
