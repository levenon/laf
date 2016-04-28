//
//  LFAppManager.h
//  LostAndFound
//
//  Created by Marike Jave on 14-12-16.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LFSystemSetting.h"

#import "LFGeTuiPushToken.h"

@interface LFAppManager : XLFAppManager

@property(nonatomic, strong, readonly) LFGeTuiPushToken *evGeTuiPushToken;

@property(nonatomic, assign, readonly) BOOL evFirstLaunch;

@property(nonatomic, assign, readonly, getter=evIsNewVersion) BOOL evNewVersion;

@property(nonatomic, strong, readonly) LFSystemSetting *evSetting;

+ (LFAppManager*)sharedInstance;

+ (void)efApplicationWillFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)efApplicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)efHandleLocalNotification:(UILocalNotification *)notification;

+ (void)efHandleNotification:(NSDictionary *)userInfo backgroundFetch:(BOOL)backgroundFetch;

+ (void)efRegisterDeviceToken:(NSData *)deviceToken;

+ (void)efFailedRegisterDeviceTokenWithError:(NSError *)error;

- (void)efUpdateToDisk;

@end

#define LFAppManagerRef        [LFAppManager sharedInstance]