//
//  LFNotificationAps.h
//  LostAndFound
//
//  Created by Marike Jave on 15/11/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFNotificationAps : LFBaseModel<XLFNotificationAps>

@property(nonatomic, copy  ) NSString *alert;
@property(nonatomic, copy  ) NSString *badge;
@property(nonatomic, copy  ) NSString *sound;

@property(nonatomic, assign) BOOL contentAvailable;

+ (LFNotificationAps *)defaultNotificationAps;

@end
