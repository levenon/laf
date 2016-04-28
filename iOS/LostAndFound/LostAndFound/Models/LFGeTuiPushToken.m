//
//  LFGeTuiPushToken
//  LostAndFound
//
//  Created by Marike Jave on 15/11/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFGeTuiPushToken.h"

@interface LFGeTuiPushToken ()

@property(nonatomic, copy) NSString *clientId;

@property(nonatomic, copy) NSString *version;

@end

@implementation LFGeTuiPushToken

+ (instancetype)tokenWithClientId:(NSString *)clientId
                          version:(NSString *)version;{
    
    return [[[self class] alloc] initWithClientId:clientId version:version];
}

- (instancetype)initWithClientId:(NSString *)clientId
                         version:(NSString *)version;{
    
    self = [super init];
    if (self) {
        
        [self setClientId:clientId];
        [self setVersion:version];
    }
    return self;
    
}

@end
