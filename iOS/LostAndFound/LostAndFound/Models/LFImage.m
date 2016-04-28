//
//  LFImage.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFImage.h"

@implementation LFImage

- (NSString *)defaultUrl{
    
    return egfImageUrlDefault([self remoteId]);
}

@end
