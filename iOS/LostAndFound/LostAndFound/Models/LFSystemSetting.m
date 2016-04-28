//
//  LFSystemSetting.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-14.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFSystemSetting.h"

NSString *const kNotificationSystemSettingChanged = @"kNotificationSystemSettingChanged";

@implementation LFSystemSetting

- (void)setAllowPreviewFileAt3G:(BOOL)allowPreviewFileAt3G{
    if (_allowPreviewFileAt3G != allowPreviewFileAt3G) {

        _allowPreviewFileAt3G = allowPreviewFileAt3G;

        [self efPostMessage];
    }
}

- (void)setAllowDownloadFileAt3G:(BOOL)allowDownloadFileAt3G{
    if (_allowDownloadFileAt3G != allowDownloadFileAt3G) {

        _allowDownloadFileAt3G = allowDownloadFileAt3G;

        [self efPostMessage];
    }
}

- (void)setAllowDownloadFileAtBackground:(BOOL)allowDownloadFileAtBackground{
    if (_allowDownloadFileAtBackground != allowDownloadFileAtBackground) {

        _allowDownloadFileAtBackground = allowDownloadFileAtBackground;

        [self efPostMessage];
    }
}

- (void)efPostMessage{

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSystemSettingChanged object:self];
}

- (void)efConfigurate{
}

@end
