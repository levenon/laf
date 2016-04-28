//
//  LFCategory.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFCategory.h"

@implementation LFCategory

- (NSArray<LFCategory *> *)subitems{
    
    if (!_subitems) {
        
        _subitems = @[];
    }
    return _subitems;
}

@end
