//
//  LFCategoryManager.h
//  LostAndFound
//
//  Created by Marike Jave on 16/1/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFCategoryManager : NSObject

@property(nonatomic, strong, readonly) NSArray<LFCategory *> *evCategories;

+ (id)shareManager;

+ (void)efConfigurate;

- (void)efFetchCategories:(void (^)(NSArray<LFCategory *> *categories))callback;

@end


#define LFCategoryManagerRef    [LFCategoryManager shareManager]