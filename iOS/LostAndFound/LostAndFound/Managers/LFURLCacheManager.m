//
//  LFURLCacheManager.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import "LFURLCacheManager.h"

@implementation LFURLCacheManager


+ (void)configurate;{
    
    LFURLCacheManager *urlCache = [[LFURLCacheManager alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                       diskCapacity:200 * 1024 * 1024
                                                                           diskPath:SDWebCacheDirectory
                                                                          cacheTime:0];
    [LFURLCacheManager setSharedURLCache:urlCache];
}

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path cacheTime:(NSInteger)cacheTime {
    if (self = [self initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        self.cacheTime = cacheTime;
        if (path)
            self.diskPath = path;
        else
            self.diskPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        self.responseDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)dealloc {
    [self setDiskPath:nil];
    [self setResponseDictionary:nil];
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame || ![[NSSet setWithObjects:@"http", @"https", @"ftp", nil] containsObject:request.URL.scheme] || [request cachePolicy] != NSURLRequestUseProtocolCachePolicy  ) {
        return [super cachedResponseForRequest:request];
    }
    return [self dataFromRequest:request];
}

- (void)removeAllCachedResponses {
    [super removeAllCachedResponses];
    
    [self deleteCacheFolder];
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    [super removeCachedResponseForRequest:request];
    
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
    [fileManager removeItemAtPath:otherInfoPath error:nil];
}

#pragma mark - custom url cache

- (void)deleteCacheFolder {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:self.diskPath error:nil];
}

- (NSString *)cacheFilePath:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileManager fileExistsAtPath:self.diskPath isDirectory:&isDir] && isDir) {
        
    } else {
        [fileManager createDirectoryAtPath:self.diskPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@/%@", self.diskPath, file];
}

- (NSString *)cacheRequestFileName:(NSString *)requestUrl {
    return [requestUrl encodeMD5];
}

- (NSString *)cacheRequestOtherInfoFileName:(NSString *)requestUrl {
    return [[NSString stringWithFormat:@"%@-otherInfo", requestUrl] encodeMD5];
}

- (NSCachedURLResponse *)dataFromRequest:(NSURLRequest *)request {
    NSString *url = request.URL.absoluteString;
    NSString *fileName = [self cacheRequestFileName:url];
    NSString *otherInfoFileName = [self cacheRequestOtherInfoFileName:url];
    NSString *filePath = [self cacheFilePath:fileName];
    NSString *otherInfoPath = [self cacheFilePath:otherInfoFileName];
    NSDate *date = [NSDate date];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        BOOL expire = NO;
        NSDictionary *otherInfo = [NSDictionary dictionaryWithContentsOfFile:otherInfoPath];
        
        if (self.cacheTime > 0) {
            NSInteger createTime = [[otherInfo objectForKey:@"time"] intValue];
            if (createTime + self.cacheTime < [date timeIntervalSince1970]) {
                expire = YES;
            }
        }
        if (!expire) {
            NSLog(@"data from cache ...");
            
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL
                                                                MIMEType:[otherInfo objectForKey:@"MIMEType"]
                                                   expectedContentLength:data.length
                                                        textEncodingName:[otherInfo objectForKey:@"textEncodingName"]];
            NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
            return cachedResponse;
        }
        else {
            NSLog(@"cache expire ... ");
            
            [fileManager removeItemAtPath:filePath error:nil];
            [fileManager removeItemAtPath:otherInfoPath error:nil];
        }
    }
    if (![Reachability isHaveNetWork]) {
        return nil;
    }
    __block NSCachedURLResponse *cachedResponse = nil;
    
    id boolExsite = [self.responseDictionary objectForKey:url];
    if (!boolExsite) {
        [self.responseDictionary setValue:[NSNumber numberWithBool:TRUE] forKey:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data,NSError *error)
         {
             if (response && data) {
                 
                 [self.responseDictionary removeObjectForKey:url];
                 
                 if (error) {
                     NSLog(@"error : %@", error);
                     NSLog(@"not cached: %@", request.URL.absoluteString);
                     cachedResponse = nil;
                 }
                 NSLog(@"cache url --- %@ ",url);
                 
                 //save to cache
                 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", [date timeIntervalSince1970]], @"time",
                                       response.MIMEType, @"MIMEType",
                                       response.textEncodingName, @"textEncodingName", nil];
                 [dict writeToFile:otherInfoPath atomically:YES];
                 [data writeToFile:filePath atomically:YES];
                 
                 cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
             }
         }];
        
        return cachedResponse;
    }
    return nil;
}

@end
