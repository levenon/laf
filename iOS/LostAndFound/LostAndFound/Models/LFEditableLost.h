//
//  LFEditableLost.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFEditableNotice.h"

#import "LFLocation.h"

#import "LFRegion.h"

#import "LFImage.h"

#import "LFUser.h"

@interface LFEditableLost : LFEditableNotice

@property(nonatomic, strong) NSMutableArray<LFLocation *> *locations;
@property(nonatomic, strong) NSMutableArray<LFRegion *> *regions;

@property(nonatomic, strong, readonly) LFLost *lost;

@end
