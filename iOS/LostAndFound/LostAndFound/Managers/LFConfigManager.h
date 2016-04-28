//
//  LFConfigManager.h
//  LostAndFound
//
//  Created by Marike Jave on 14-11-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

@interface LFConfigManager : XLFConfigManager

- (NSString *)debugFileUrl;
- (NSString *)releaseFileUrl;
- (NSString *)fileUrl;

- (NSString *)debugVideoUrl;
- (NSString *)releaseVideoUrl;
- (NSString *)videoUrl;

- (NSString *)debugLocalServerHost;
- (NSInteger)debugLocalServerPort;

- (NSString *)releaseLocalServerHost;
- (NSInteger)releaseLocalServerPort;

- (NSString *)localServerHost;
- (NSInteger)localServerPort;

@end
