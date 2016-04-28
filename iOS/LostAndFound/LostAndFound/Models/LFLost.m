//
//  LFLost.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFLost.h"

@interface LFLost ()

@end

@implementation LFLost

- (Class)arrayModelClassWithPropertyName:(NSString *)propertyName{
    Class cls = [super arrayModelClassWithPropertyName:propertyName];
    
    if (!cls && [propertyName isEqualToString:NSStringFromSelector(@selector(locations))]) {
        
        return [LFLocation class];
    }
    
    if (!cls && [propertyName isEqualToString:NSStringFromSelector(@selector(regions))]) {
        
        return [LFRegion class];
    }
    return cls;
}

- (NSArray<LFLocation *> *)locations{
    
    if (!_locations) {
        
        _locations = @[];
    }
    return _locations;
}

- (NSArray<LFRegion *> *)regions{
    
    if (!_regions) {
        
        _regions = @[];
    }
    return _regions;
}

- (LFNoticeType)type{
    
    return LFNoticeTypeLost;
}


@end
