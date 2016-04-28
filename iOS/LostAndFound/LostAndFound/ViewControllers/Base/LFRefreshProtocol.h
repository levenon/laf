//
//  LFRefreshProtocol.h
//  LostAndFound
//
//  Created by Marike Jave on 14-12-10.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LFRefreshProtocol <NSObject>

@optional
- (void)efRefreshTrigger;

@property(nonatomic, assign, readonly) BOOL evIsRefreshing;


@end
