//
//  LFRegion.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFRegion.h"

@implementation LFRegion

- (NSArray<LFLocation *> *)locations{
    
    if (!_locations) {
        
        _locations = @[];
    }
    return _locations;
}

@end
