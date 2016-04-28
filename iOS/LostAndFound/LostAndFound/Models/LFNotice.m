//
//  LFNotice.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/23.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNotice.h"

@interface LFNotice ()

@end

@implementation LFNotice

- (Class)arrayModelClassWithPropertyName:(NSString *)propertyName{
    Class cls = [super arrayModelClassWithPropertyName:propertyName];
    
    if (!cls && [propertyName isEqualToString:NSStringFromSelector(@selector(images))]) {
        
        return [LFImage class];
    }
    return cls;
}

- (NSArray<LFImage *> *)images{
    
    if (!_images) {
        
        _images = @[];
    }
    return _images;
}

- (NSDate *)timeDate{
    
    return [NSDate dateFromString:[self time] format:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSDate *)updateTimeDate{
    
    return [NSDate dateFromString:[self updateTime] format:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSDate *)happenTimeDate{
    
    return [NSDate dateFromString:[self happenTime] format:@"yyyy-MM-dd HH:mm:ss"];
}

@end
