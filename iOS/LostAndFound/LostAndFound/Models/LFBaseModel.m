//
//  LFBaseModel.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-5.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFBaseModel.h"

@implementation LFBaseModel

- (BOOL)isEqual:(LFBaseModel *)object{
    
    BOOL etResult = [super isEqual:object];

    if (!etResult) {
     
        etResult = [object isKindOfClass:[self class]] && [[self id] isEqual:[object id]];
    }
    return etResult;
}

- (NSUInteger)hash{
    
    return [[self id] hash] ^ [[self class] hash];
}

@end

@implementation NSArray (MultipleId)

- (NSSet*)ids{

    NSMutableSet *ids = [NSMutableSet set];

    for (id model in self) {

        if ([model respondsToSelector:@selector(id)]) {

            [ids addObject:[model performSelector:@selector(id)]];
        }
    }
    return ids;
}

@end