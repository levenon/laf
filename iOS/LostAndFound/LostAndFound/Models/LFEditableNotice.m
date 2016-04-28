//
//  LFEditableNotice.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFEditableNotice.h"

@implementation LFEditableNotice

- (NSMutableArray<LFPhoto *> *)images{
    
    if (!_images) {
        
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSMutableArray<LFPhoto *> *)remoteImages{
    
    if (!_remoteImages) {
        
        _remoteImages = [NSMutableArray array];
    }
    return _remoteImages;
}

- (NSDate *)timeDate{
    
    return [NSDate date];
}

- (NSDate *)happenTimeDate{
    
    if (!_happenTimeDate) {
        
        _happenTimeDate = [NSDate date];
    }
    return _happenTimeDate;
}

@end
