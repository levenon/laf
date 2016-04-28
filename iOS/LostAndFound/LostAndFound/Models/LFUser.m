//
//  LFUser.m
//  Suixingou
//
//  Created by Marike Jave on 14-6-16.
//  Copyright (c) 2014年 JhihPong. All rights reserved.
//

#import "LFUser.h"
#import "LFUserManager.h"

@interface LFUser ()

@end

@implementation LFUser

- (BOOL)isLocalUser{
    
    return [[[LFUserManagerRef evLocalUser] sid] length] && [[self id] isEqualToString:[[LFUserManagerRef evLocalUser] id]];
}

- (NSString *)salutation{
    
    return select([[self realname] length], [self realname], [self nickname]);
}

@end
