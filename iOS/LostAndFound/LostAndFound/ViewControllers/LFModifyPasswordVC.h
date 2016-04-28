//
//  LFModifyPasswordVC.h
//  LostAndFound
//
//  Created by Marike Jave on 14-11-3.
//  Copyright(c) 2014年 MarikeJave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import "LFBaseViewController.h"
#import "LFConstants.h"

@interface LFModifyPasswordVC : LFBaseViewController

@property(nonatomic, copy, readonly) void(^evblcModifyPasswordCallback)(LFModifyPasswordVC *modifyPasswordVC, BOOL success);

- (id)initWithModifyPasswordCallback:(void (^)(LFModifyPasswordVC *modifyPasswordVC, BOOL success))modifyPasswordCallback;

@end
