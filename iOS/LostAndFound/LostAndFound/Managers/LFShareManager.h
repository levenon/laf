//
//  LFShareManager.h
//  LostAndFound
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "LFShareInfo.h"

@interface LFShareManager : NSObject

+ (LFShareManager *)sharedInstance;

+ (void)efShareInfo:(LFShareInfo *)shareInfo;

@end