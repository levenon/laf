//
//  LFAddressSelectorVC.h
//  LFrivingCustomer
//
//  Created by Marike Jave on 15/8/12.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseTableViewController.h"

#import "LFLocation.h"

@interface LFAddressSelectorVC : LFBaseTableViewController

@property(nonatomic, copy, readonly) void (^evblcCompletionCallback)(LFAddressSelectorVC *addressSelector, LFLocation *address);

- (instancetype)initWithCityName:(NSString *)cityName
                  defaultKeyword:(NSString *)defaultKeyword
              completionCallback:(void (^)(LFAddressSelectorVC *addressSelector, LFLocation *address))completionCallback;

@end
