//
//  LFEditableNotice.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNoticeBase.h"

#import "LFLocation.h"

#import "LFPhoto.h"

#import "LFUser.h"

#import "LFCategory.h"

@interface LFEditableNotice : LFNoticeBase

@property(nonatomic, copy) NSString *titlePlaceHolder;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *cid;
@property(nonatomic, strong) LFImage *image;

@property(nonatomic, assign) CLLocationDistance distance;

@property(nonatomic, strong) LFCategory *category;
@property(nonatomic, strong) LFLocation *location;
@property(nonatomic, strong) NSMutableArray<LFPhoto *> *images;
@property(nonatomic, strong) NSMutableArray<LFPhoto *> *remoteImages;

@property(nonatomic, strong) LFUser *user;

@property(nonatomic, strong) NSDate *timeDate;
@property(nonatomic, strong) NSDate *happenTimeDate;

@property(nonatomic, strong, readonly) LFNotice *notice;
@end
