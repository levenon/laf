//
//  LFSystemSetting.h
//  LostAndFound
//
//  Created by Marike Jave on 14-12-14.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFBaseModel.h"

extern NSString *const kNotificationSystemSettingChanged;

@interface LFSystemSetting : LFBaseModel

@property(nonatomic, assign)  BOOL allowDownloadFileAt3G;

@property(nonatomic, assign)  BOOL allowPreviewFileAt3G;

@property(nonatomic, assign)  BOOL allowDownloadFileAtBackground;

@property(nonatomic, assign)  BOOL allowVoice;

@property(nonatomic, assign)  BOOL allowShake;

@property(nonatomic, copy  )  NSString *appVersion;

@property(nonatomic, assign)  BOOL hasLaunched;

- (void)efConfigurate;

@end
