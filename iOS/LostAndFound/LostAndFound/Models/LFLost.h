//
//  LFLost.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNotice.h"

#import "LFLocation.h"

#import "LFRegion.h"

#import "LFImage.h"

#import "LFUser.h"

@interface LFLost : LFNotice

@property(nonatomic, strong) NSArray<LFLocation *> *locations;
@property(nonatomic, strong) NSArray<LFRegion *> *regions;

@end
