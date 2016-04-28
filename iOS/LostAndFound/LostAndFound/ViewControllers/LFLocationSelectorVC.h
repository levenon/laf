//
//  LFLocationSelectorVC.h
//  LostAndFound
//
//  Created by Marke Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

#import "LFLocation.h"

@interface LFLocationSelectorVC : LFBaseViewController

@property(nonatomic, copy, readonly) void (^evblcCompletionCallback)(LFLocationSelectorVC *locationSelector, LFLocation *location);

- (instancetype)initWithCompletionCallback:(void (^)(LFLocationSelectorVC *locationSelector, LFLocation *location))completionCallback;

@end
