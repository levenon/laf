//
//  LFUMengSocialManager.h
//  LostAndFound
//
//  Created by Marike Jave on 15/6/29.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFUMengSocialManager : NSObject

+ (void)efConfigurate;

+ (BOOL)efHandleOpenURL:(NSURL *)url;

+ (BOOL)efOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

+ (void)efApplicationDidBecomeActive;

@end
