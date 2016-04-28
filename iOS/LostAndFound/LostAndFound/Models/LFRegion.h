//
//  LFRegion.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

#import "LFLocation.h"

@interface LFRegion : LFBaseModel

@property(nonatomic, strong) NSArray<LFLocation *> *locations;

@end
