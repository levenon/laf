//
//  LFNotificationManager.h
//  LostAndFound
//
//  Created by Marike Jave on 15/10/15.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNotification.h"
#import "LFNotificationAps.h"
#import "LFNotificationCustomContent.h"

@interface LFNotificationManager : XLFNotificationManager

@end

@interface NSObject (NotificationManager)

- (XLFNotificationHandle *)efRegisterNotificationHandle:(void(^)(id<XLFNotificationCustomContent> notificationUserInfo))notificationHandle type:(NSInteger)type;

- (XLFNotificationHandle *)efRegisterNotificationHandle:(void(^)(id<XLFNotificationCustomContent> notificationUserInfo))notificationHandle type:(NSInteger)type forever:(BOOL)forever;

- (XLFNotificationHandle *)efRegisterNotificationHandleDelegate:(id<XLFNotificationHandleDelegate>)delegate
                                                           type:(NSInteger)type;

- (XLFNotificationHandle *)efRegisterNotificationHandleDelegate:(id<XLFNotificationHandleDelegate>)delegate
                                                           type:(NSInteger)type
                                                        forever:(BOOL)forever;

- (void)efRemoveNotificationHandleDelegate:(id<XLFNotificationHandleDelegate>)delegate type:(NSInteger)type;

- (void)efRemoveNotificationHandlesDelegate:(id<XLFNotificationHandleDelegate>)delegate;

- (void)efRemoveNotificationHandleWithType:(NSInteger)type;

- (void)efRemoveNotificationUserInfoWithType:(NSInteger)type;

@end