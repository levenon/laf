//
//  LFConstants
//  SugarLady
//
//  Created by Marike Jave on 14-10-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import "LFConstants.h"
#import <XLFCommonKit/XLFCommonKit.h>

#if DEBUG

NSString * const egGeTuiAppID                     = @"xQH5zJ9WqAA7TUtEd3dFY9";
NSString * const egGeTuiAppKey                    = @"6wRmrCB8KfANqRgVGd2Tz5";
NSString * const egGeTuiAppSecret                 = @"0DlZf3ag656nEn1vEHJMo5";

#else

NSString * const egGeTuiAppID                     = @"dbipQeRkET9lk4kFDeGFh8";
NSString * const egGeTuiAppKey                    = @"OeNfXt3Gyv6BPxNRX6IBD";
NSString * const egGeTuiAppSecret                 = @"wczxfmg0px7OLGMjthwdR1";

#endif

@implementation LFConstants

//0 男； 1 女； 2 未知
+ (NSString*)sexString:(LFSexType)type;{
    
    switch (type) {
            
        case LFSexTypeMale:
            return @"男";
            
        case LFSexTypeFemale:
            return @"女";
            
        case LFSexTypeUnknown:
            return @"未知";
            
        default:
            break;
    }
    return nil;
}

+ (NSString *)userNotificationTypeDescription:(UIUserNotificationType)userNotificationType;{
    
    if (userNotificationType & UIUserNotificationTypeSound &&
        !(userNotificationType & UIUserNotificationTypeAlert)) {
        
        return @"只接收消息无通知提醒";
    }
    else if (userNotificationType & UIUserNotificationTypeAlert &&
             !(userNotificationType & UIUserNotificationTypeSound)){
        
        return @"只接收消息无声音提醒";
    }
    else if (userNotificationType & UIUserNotificationTypeAlert &&
             userNotificationType & UIUserNotificationTypeSound){
        
        return @"接收消息通知并声音提醒";
    }
    else{
        return @"未开启";
    }
}

+ (LFPlatformType)platformFromShareType:(UMSocialSnsType)type;{
    
    switch (type) {
        case UMSocialSnsTypeSina:
            return LFPlatformTypeSina;
        case UMSocialSnsTypeMobileQQ:
        case UMSocialSnsTypeQzone:
        case UMSocialSnsTypeTenc:
            return LFPlatformTypeTencent;
        case UMSocialSnsTypeWechatSession:
        case UMSocialSnsTypeWechatTimeline:
        case UMSocialSnsTypeWechatFavorite:
            return LFPlatformTypeWechat;
        default:
            break;
    }
    return LFPlatformTypeNormal;
}

+ (NSString *)distanceDescription:(CLLocationDistance)distance;{
    
    if (distance < 10) {
        
        return @"近在咫尺";
    }
    
    if (distance > 1000 * 20) {
        
        return @"遥不可及";
    }
    
    if (distance < 1000) {
        
        return fmts(@"%.f m", distance);
    }
    
    return fmts(@"%.2f km", distance / 1000.f);
}

@end
