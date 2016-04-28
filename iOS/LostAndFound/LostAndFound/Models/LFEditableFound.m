//
//  LFEditableFound.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFEditableFound.h"

@implementation LFEditableFound

- (LFFound *)found{
    
    LFFound *etFound =  [LFFound modelWithAttributes:[self dictionary]];
    [etFound setTime:[[NSDate date] dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss:SSS"]];
    [etFound setHappenTime:[[self happenTimeDate] dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
    
    [etFound setUid:[[LFUserManagerRef evLocalUser] id]];
    [etFound setUser:[LFUserManagerRef evLocalUser]];
    [etFound setImage:[[etFound images] firstObject]];
    
    return etFound;
}

- (LFNotice *)notice{
    
    return [self found];
}

- (NSString *)titlePlaceHolder{
    
    return @"请描述一下您发现的宝贝";
}

@end
