//
//  LFNotification.h
//  LostAndFound
//
//  Created by Marike Jave on 15/11/20.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

#import "LFNotificationAps.h"

#import "LFNotificationCustomContent.h"

@interface LFNotification : XLFNotification

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
