//
//  LFShareInfo
//  LostAndFound
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFShareInfo : LFBaseModel

@property(nonatomic , copy  ) NSString *content;
@property(nonatomic , copy  ) NSString *url;
@property(nonatomic , copy  ) UIImage *image;
@property(nonatomic , copy  ) NSString *imageUrl;
@property(nonatomic , copy  ) NSString *title;

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
           imageUrl:(NSString *)imageUrl
              image:(UIImage *)image
                url:(NSString *)url;

+ (id)infoWithTitle:(NSString *)title
            content:(NSString *)content
           imageUrl:(NSString *)imageUrl
              image:(UIImage *)image
                url:(NSString *)url;

@end
