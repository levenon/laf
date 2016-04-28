//
//  LFCategoryManager.m
//  LostAndFound
//
//  Created by Marike Jave on 16/1/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFCategoryManager.h"

@interface LFCategoryManager ()

@property(nonatomic, strong) NSMutableArray<LFCategory *> *evMutableCategories;

@property(nonatomic, copy  ) void (^evFetchCallback)(NSArray<LFCategory *> *categories);

@end

@implementation LFCategoryManager

+ (id)shareManager;{
    
    static LFCategoryManager *esCategoryManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        esCategoryManager = [[LFCategoryManager alloc] init];
    });
    return esCategoryManager;
}

+ (void)efConfigurate;{
    
    [[self shareManager] _efConfigurate];
}

- (void)_efConfigurate{
    
    [self _efFetchCategories];
}

- (NSMutableArray<LFCategory *> *)evMutableCategories{
    
    if (!_evMutableCategories) {
        
        _evMutableCategories = [NSMutableArray array];
        
        //        [_evMutableCategories addObject:[LFCategory modelWithAttributes:@{@"id":@1, @"name":@"距离最近"}]];
        //        [_evMutableCategories addObject:[LFCategory modelWithAttributes:@{@"id":@2, @"name":@"发布最新"}]];
    }
    return _evMutableCategories;
}

- (NSArray<LFCategory *> *)evCategories{
    return [[self evMutableCategories] copy];
}

- (void)efFetchCategories:(void (^)(NSArray<LFCategory *> *categories))callback;{
    
    if ([[self evMutableCategories] count]) {
        callback([self evMutableCategories]);
    }
    else{
        [self setEvFetchCallback:callback];
        [self _efFetchCategories];
    }
}

- (void)_efFetchCategories{
    
    LFHttpRequest *etreqFetchCategories = [self efGetNoticeCategoriesWithSuccess:[self _efFetchCategoriesSuccess]
                                                                         failure:[self _efFetchCategoriesFailed]];
    
    [etreqFetchCategories startAsynchronous];
}

- (XLFOnlyArrayResponseSuccessedBlock)_efFetchCategoriesSuccess{
    
    Weakself(ws);
    return ^(id request, id result, NSArray<LFCategory *> *categories){
        
        [[ws evMutableCategories] removeAllObjects];
        [[ws evMutableCategories] addObjectsFromArray:categories];
        
        if ([ws evFetchCallback]) {
            ws.evFetchCallback([[ws evMutableCategories] copy]);
        }
    };
}

- (XLFFailedBlock)_efFetchCategoriesFailed{
    
    return ^(id request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

@end
