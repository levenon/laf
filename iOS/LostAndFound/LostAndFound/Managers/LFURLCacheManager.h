//
//  LFURLCacheManager.h
//  LostAndFound
//
//  Created by Marike Jave on 14-12-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFBaseHttpRequestKit/XLFBaseHttpRequestKit.h>

@interface LFURLCacheManager : NSURLCache

@property(nonatomic, assign) NSInteger cacheTime;
@property(nonatomic, copy  ) NSString *diskPath;
@property(nonatomic, strong) NSMutableDictionary *responseDictionary;

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime;

+ (void)configurate;

@end
