//
//  LFNotificationCustomContent.h
//  LostAndFound
//
//  Created by Marike Jave on 15/10/15.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFNotificationCustomContent : LFBaseModel<XLFNotificationCustomContent>

@property(nonatomic, strong) id object;

@property(nonatomic, assign) NSInteger notificationCustomContentType;

@end
