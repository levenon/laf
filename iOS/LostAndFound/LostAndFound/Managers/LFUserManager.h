//
//  LFUserManager.h
//  LostAndFound
//
//  Created by Marike Jave on 15/6/27.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LFUser.h"

#import "LFGeTuiPushToken.h"

@interface LFUserManager : NSObject

@property(nonatomic, strong, readonly) LFUser *evLocalUser;

@property(nonatomic, assign, readonly, getter=evIsLogin) BOOL evLogin;

@property(nonatomic, assign, readonly, getter=evIsBeingLogin) BOOL evBeingLogin;

+ (id)shareManager;

+ (void)efConfigurate;

+ (void)efUpdateUser:(LFUser *)user;

+ (void)efUpdateToDisk;

+ (void)efAutoLogin;

+ (void)efLogin;

+ (void)efLogoutOnServer;

+ (void)efLogout;

+ (void)efAppendFoundsCount:(NSInteger)count;

+ (void)efAppendLostsCount:(NSInteger)count;

@end

#define LFUserManagerRef        [LFUserManager shareManager]