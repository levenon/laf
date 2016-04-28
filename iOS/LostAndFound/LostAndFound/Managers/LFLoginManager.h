//
//  LFLoginManager
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XLFCommonKit/XLFCommonKit.h>
#import "UMSocial.h"

@class LFLoginManager;

@protocol LFLoginManagerDelegate <NSObject>

- (void)epLoginManager:(LFLoginManager *)manager success:(BOOL)success error:(NSError*)error;

@end

@interface LFLoginManager : NSObject


+ (void)efNormalLoginWithUserName:(NSString*)username
                         password:(NSString*)password
                  showLoadingView:(BOOL)showLoadingView
                         delegate:(id<LFLoginManagerDelegate>)delegate;


+ (void)efThirdPlatformLoginWithUserInfo:(UMSocialAccountEntity *)userInfo
//                         showLoadingView:(BOOL)showLoadingView
                                delegate:(id<LFLoginManagerDelegate>)delegate;

+ (void)efThirdPlatformLoginWithType:(UMSocialSnsType)type
//                     showLoadingView:(BOOL)showLoadingView
                            delegate:(id<LFLoginManagerDelegate>)delegate;


@end
