//
//  LFShareInfo
//  LostAndFound
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import "LFShareInfo.h"

@implementation LFShareInfo

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
           imageUrl:(NSString *)imageUrl
              image:(UIImage *)image
                url:(NSString *)url;{
    self = [super init];
    if (self) {
        
        [self setTitle:title];
        [self setContent:content];
        [self setImage:image];
        [self setImageUrl:imageUrl];
        [self setUrl:url];
    }
    
    return self;
}

+ (id)infoWithTitle:(NSString *)title
            content:(NSString *)content
           imageUrl:(NSString *)imageUrl
              image:(UIImage *)image
                url:(NSString *)url;{
    
    return [[[self class] alloc] initWithTitle:title
                                       content:content
                                      imageUrl:imageUrl
                                         image:image
                                           url:url];
}

@end
