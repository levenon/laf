//
//  LFLocationDistributeVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

#import "LFLocation.h"

@interface LFLocationDistributeVC : LFBaseViewController

@property(nonatomic, strong, readonly) LFLocation *evLocation;

@property(nonatomic, strong, readonly) NSArray<LFLocation *> *evLocations;

- (instancetype)initWithTitle:(NSString *)title location:(LFLocation *)location locations:(NSArray<LFLocation *> *)locations;

@end
