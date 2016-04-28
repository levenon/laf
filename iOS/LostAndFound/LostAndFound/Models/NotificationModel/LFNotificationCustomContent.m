//
//  LFNotificationCustomContent.m
//  LostAndFound
//
//  Created by Marike Jave on 15/10/15.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNotificationCustomContent.h"

@interface LFNotificationCustomContent ()

@property(nonatomic, strong) NSDictionary *content;

@property(nonatomic, copy  ) NSString *type;

@end

@implementation LFNotificationCustomContent

+ (NSDictionary *)shareNotificationModelClasses{
    
    static NSDictionary<NSNumber *, Class> *etNotificationModelClasses = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        etNotificationModelClasses = @{};
        
    });
    
    return etNotificationModelClasses;
}

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super initWithAttributes:attributes];
    
    if (self) {
        
        Class etModelClass = [[[self class] shareNotificationModelClasses] objectForKey:@([self notificationCustomContentType])];

        [self setObject:[[attributes objectForKey:@"content"] modelWithClass:etModelClass]];
    }
    return self;
}

@end
