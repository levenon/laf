//
//  LFConfigManager.m
//  LostAndFound
//
//  Created by Marike Jave on 14-11-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import "LFConfigManager.h"

@interface XLFConfigManager (Private)

@property(nonatomic, strong) NSDictionary *configuration;
@property(nonatomic, strong) NSDictionary *contactInfo;
@property(nonatomic, strong) NSDictionary *fonts;
@property(nonatomic, strong) NSDictionary *colors;

@end

@implementation LFConfigManager

- (NSString *)debugFileUrl;{
    
    return [[self configuration] objectForKey:@"debug_file_url"];
}
//取外网内测服务器地址
- (NSString *)releaseFileUrl;{
    
    return [[self configuration] objectForKey:@"release_file_url"];
}

- (NSString *)fileUrl;{
    
#if DEBUG
    return [self debugFileUrl];
#else
    return [self releaseFileUrl];
#endif
}

- (NSString *)debugVideoUrl;{
    
    return [[self configuration] objectForKey:@"release_video_url"];
}

- (NSString *)releaseVideoUrl;{
    
    return [[self configuration] objectForKey:@"release_video_url"];
}

- (NSString *)videoUrl;{
    
#if DEBUG
    return [self debugVideoUrl];
#else
    return [self releaseVideoUrl];
#endif
}

- (NSString *)debugLocalServerHost;{
    
    return [[self configuration] objectForKey:@"debug_local_server_host"];
}

- (NSInteger)debugLocalServerPort;{
    
    return [[[self configuration] objectForKey:@"debug_local_server_port"] integerValue];
}

- (NSString *)releaseLocalServerHost;{
    
    return [[self configuration] objectForKey:@"release_local_server_host"];
}

- (NSInteger)releaseLocalServerPort;{
    
    return [[[self configuration] objectForKey:@"release_local_server_port"] integerValue];
}

- (NSString *)localServerHost;{
    
#if DEBUG
    return [self debugLocalServerHost];
#else
    return [self releaseLocalServerHost];
#endif
}

- (NSInteger)localServerPort;{
    
#if DEBUG
    return [self debugLocalServerPort];
#else
    return [self releaseLocalServerPort];
#endif
}

- (NSDictionary *)configuration{
    
    return [@"{\n\
            \"debug_url\": \"http://idev.iwoce.com/laf/server\",\n             \
            \"release_url\": \"http://idev.iwoce.com/laf/server\",\n                \
            \"debug_upload_url\":\"http://idev.iwoce.com/laf/upload\",\n       \
            \"release_upload_url\":\"http://idev.iwoce.com/laf/upload\",\n          \
            \"debug_video_url\":\"http://idev.iwoce.com/laf/video\",\n         \
            \"release_video_url\":\"http://idev.iwoce.com/laf/video\",\n            \
            \"debug_image_host\": \"\",\n                                           \
            \"release_image_host\": \"\",\n                                         \
            \"debug_image_url\":\"http://idev.iwoce.com/fileserver/image\",\n  \
            \"release_image_url\":\"http://idev.iwoce.com/fileserver/image\",\n     \
            \"debug_file_url\":\"http://idev.iwoce.com/fileserver/file\",\n    \
            \"release_file_url\":\"http://idev.iwoce.com/fileserver/file\",\n       \
            \"debug_host\":\"\",\n                                                  \
            \"release_host\":\"\",\n                                                \
            \"debug_port\":1999,\n                                                  \
            \"release_port\":1999\n}"
            objectFromJSONString];
}

@end
