//
//  LFNotificationManager.m
//  LostAndFound
//
//  Created by Marike Jave on 15/10/15.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNotificationManager.h"

@interface LFNotificationManager ()

@end

@implementation LFNotificationManager

@end

@implementation NSObject (NotificationManager)

- (XLFNotificationHandle *)efRegisterNotificationHandle:(void(^)(id<XLFNotificationCustomContent> notificationUserInfo))notificationHandle type:(NSInteger)type;{
    
    return [self efRegisterNotificationHandle:notificationHandle type:type forever:NO];
}

- (XLFNotificationHandle *)efRegisterNotificationHandle:(void(^)(id<XLFNotificationCustomContent> notificationUserInfo))notificationHandle type:(NSInteger)type forever:(BOOL)forever;{
    
    return [LFNotificationManager efRegisterNotificationHandle:notificationHandle type:type forever:forever relationObject:self];
}

- (XLFNotificationHandle *)efRegisterNotificationHandleDelegate:(id<XLFNotificationHandleDelegate>)delegate
                                                           type:(NSInteger)type;{
    
    return [self efRegisterNotificationHandleDelegate:delegate type:type forever:NO];
}

- (XLFNotificationHandle *)efRegisterNotificationHandleDelegate:(id<XLFNotificationHandleDelegate>)delegate
                                                           type:(NSInteger)type
                                                        forever:(BOOL)forever;{
    
    return [LFNotificationManager efRegisterNotificationHandleDelegate:delegate type:type forever:forever relationObject:self];
}

- (void)efRemoveNotificationHandleDelegate:(id<XLFNotificationHandleDelegate>)delegate type:(NSInteger)type;{
    
    return [LFNotificationManager efRemoveNotificationHandleDelegate:delegate type:type];
}

- (void)efRemoveNotificationHandlesDelegate:(id<XLFNotificationHandleDelegate>)delegate;{
    
    return [LFNotificationManager efRemoveNotificationHandlesDelegate:delegate];
}

- (void)efRemoveNotificationHandleWithType:(NSInteger)type;{
    
    return [LFNotificationManager efRemoveNotificationHandleWithType:type];
}

- (void)efRemoveNotificationUserInfoWithType:(NSInteger)type;{

    return [LFNotificationManager efRemoveNotificationUserInfoWithType:type];
}

@end