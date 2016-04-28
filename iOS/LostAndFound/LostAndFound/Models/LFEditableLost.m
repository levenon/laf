//
//  LFEditableLost.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFEditableLost.h"

@implementation LFEditableLost

- (NSMutableArray<LFLocation *> *)locations{
    
    if (!_locations) {
        
        _locations = [NSMutableArray array];
    }
    return _locations;
}

- (NSMutableArray<LFRegion *> *)regions{
    
    if (!_regions) {
        
        _regions = [NSMutableArray array];
    }
    return _regions;
}

- (LFLost *)lost{
    
    LFLost *etLost =  [LFLost modelWithAttributes:[self dictionary]];
    
    [etLost setTime:[[NSDate date] dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
    [etLost setHappenTime:[[self happenTimeDate] dateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"]];
    
    [etLost setUid:[[LFUserManagerRef evLocalUser] id]];
    [etLost setUser:[LFUserManagerRef evLocalUser]];
    [etLost setImage:[[etLost images] firstObject]];
    
    return etLost;
}

- (LFNotice *)notice{
    
    return [self lost];
}

- (NSString *)titlePlaceHolder{
    
    return @"请描述一下您丢失的宝贝";
}

@end
