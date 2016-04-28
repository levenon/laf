//
//  LFNotice.h
//  LostAndFound
//
//  Created by Marke Jave on 15/12/23.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNoticeBase.h"

#import "LFLocation.h"

#import "LFImage.h"

#import "LFUser.h"

#import "LFCategory.h"

@interface LFNotice : LFNoticeBase

@property(nonatomic, copy) NSString *uid;
@property(nonatomic, copy) NSString *cid;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *happenTime;
@property(nonatomic, copy) NSString *updateTime;

@property(nonatomic, copy) NSString *url;

@property(nonatomic, assign) CLLocationDistance distance;

@property(nonatomic, strong) LFCategory *category;
@property(nonatomic, strong) LFImage *image;
@property(nonatomic, strong) LFLocation *location;
@property(nonatomic, strong) NSArray<LFImage *> *images;
@property(nonatomic, strong) LFUser *user;
@property(nonatomic, assign) LFNoticeState state;

@property(nonatomic, strong, readonly) NSDate *timeDate;
@property(nonatomic, strong, readonly) NSDate *updateTimeDate;
@property(nonatomic, strong, readonly) NSDate *happenTimeDate;

@property(nonatomic, assign) LFNoticeType type;

@end
