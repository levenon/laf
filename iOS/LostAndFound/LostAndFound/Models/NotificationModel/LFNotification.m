//
//  LFNotification.m
//  LostAndFound
//
//  Created by Marike Jave on 15/11/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNotification.h"

@interface LFNotification ()

@end

@implementation LFNotification

- (id)initWithAttributes:(NSDictionary *)attributes;{
    
    LFNotificationAps *etNotificationAps = [LFNotificationAps modelWithAttributes:[attributes objectForKey:@"aps"]];
    LFNotificationCustomContent *etNotificationCustomContent = [LFNotificationAps modelWithAttributes:[attributes objectForKey:@"customContent"]];
    
    return [self initWithNotificationAps:etNotificationAps customContent:etNotificationCustomContent];
}

- (id)initWithNotificationAps:(id<XLFNotificationAps>)notificationAps customContent:(id<XLFNotificationCustomContent>)customContent;{
    
    self = [super initWithNotificationAps:notificationAps customContent:customContent];
    
    if (self) {
        
        if (!notificationAps) {
            
            [self setAps:[LFNotificationAps defaultNotificationAps]];
        }
    }
    return self;
}

+ (id)notificationWithNotificationAps:(id<XLFNotificationAps>)notificationAps customContent:(id<XLFNotificationCustomContent>)customContent;{

    return [[[self class] alloc] initWithNotificationAps:notificationAps customContent:customContent];
}

@end
