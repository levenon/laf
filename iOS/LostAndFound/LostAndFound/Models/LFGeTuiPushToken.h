//
//  LFGeTuiPushToken.h
//  LostAndFound
//
//  Created by Marike Jave on 15/11/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFGeTuiPushToken : LFBaseModel

@property(nonatomic, copy, readonly) NSString *clientId;

@property(nonatomic, copy, readonly) NSString *version;

- (instancetype)initWithClientId:(NSString *)clientId
                          version:(NSString *)version;

+ (instancetype)tokenWithClientId:(NSString *)clientId
                          version:(NSString *)version;

@end
