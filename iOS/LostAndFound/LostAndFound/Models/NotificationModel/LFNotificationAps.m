//
//  LFNotificationAps.m
//  LostAndFound
//
//  Created by Marike Jave on 15/11/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNotificationAps.h"

@implementation LFNotificationAps

+ (LFNotificationAps *)defaultNotificationAps;{
    
    static LFNotificationAps *etDefaultNotificationAps = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        etDefaultNotificationAps = [LFNotificationAps model];
        [etDefaultNotificationAps setSound:@"default"];
    });
    
    return [etDefaultNotificationAps mutableCopy];
}

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super initWithAttributes:attributes];
    
    if (self) {
        
        [self setContentAvailable:[[attributes objectForKey:@"content-available"] boolValue]];
    }
    return self;
}

- (NSDictionary *)dictionary{
    
    NSDictionary *etDictionary = [super dictionary];
    
    if (etDictionary) {
        
        NSMutableDictionary *etMutableDictionary = [NSMutableDictionary dictionaryWithDictionary:etDictionary];
        [etMutableDictionary setObject:@([self contentAvailable])
                                forKey:@"content-available"];
        [etMutableDictionary removeObjectForKey:@"contentAvailable"];
        
        etDictionary = etMutableDictionary;
    }
    return etDictionary;
}

@end
