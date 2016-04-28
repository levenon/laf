//
//  LFConstants
//  
//
//  Created by Marike Jave on 14-10-11.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "UMSocial.h"

// Appkey

extern NSString * const egGeTuiAppID;
extern NSString * const egGeTuiAppKey;
extern NSString * const egGeTuiAppSecret;

extern NSString * const egUMengAppKey;

extern NSString * const egRedirectUrl;
extern NSString * const egUMengRedirectUrl;
extern NSString * const egAppIconUrl;
extern NSString * const egAppShareTitle;
extern NSString * const egAppShareText;
extern NSString * const egAppId;

extern NSString * const egBaiduAppKey;
extern NSString * const egBaiduAppSecret;

extern NSString * const egWechatAppKey;
extern NSString * const egWechatAppSecret;

extern NSString * const egSinaAppKey;
extern NSString * const egSinaSecretKey;

extern NSString * const egQQAppId;
extern NSString * const egQQAppKey;

extern NSString * const egShareSDKAppKey;
extern NSString * const egShareSDKSecret;
extern NSString * const egShareSDKSmsTemplate;

extern NSString * const kUserDefaultFirstLaunch;
extern NSString * const kUserDefaultWelcomeSuccess;
extern NSString * const kNotificationCollectionsChanged;
extern NSString * const kUserInfoChangedNotification;
extern NSString * const kUserInfoLoadSuccessNotification;
extern NSString * const kNoticeDidCloseNotification;

//0 男； 1 女； 2 未知
typedef NS_ENUM(NSUInteger, LFSexType) {
    
    LFSexTypeMale,
    LFSexTypeFemale,
    LFSexTypeUnknown
};
// 0:没有测试 1：部分测试 2：完成测试
typedef NS_ENUM(NSUInteger, LFTestResultType) {
    
    LFTestResultTypeNone,
    LFTestResultTypePart,
    LFTestResultTypeAll
};
//1 价格降序，2 价格升序，0 popularity
typedef NS_ENUM(NSUInteger, LFSortType) {
    
    LFSortTypePopularity,
    LFSortTypePriceDesc,
    LFSortTypePriceAsc
};
//0-没感觉 1-喜欢 2-不喜欢
typedef NS_ENUM(NSUInteger, LFLikeType) {
    
    LFLikeTypeNoFeel,
    LFLikeTypeVeryLike,
    LFLikeTypeNoLike
};

typedef NS_ENUM(NSInteger, LFKeywordFeelType) {
    
    LFKeywordFeelTypePraise       = 0 ,       //  超赞
    LFKeywordFeelTypeCare             ,       //  贴心
    LFKeywordFeelTypeOnDiet           ,       //  减肥
    LFKeywordFeelTypeHehe             ,       //  呵呵
    LFKeywordFeelTypeNoninductive     ,       //  无感
    LFKeywordFeelTypeGoAway           ,       //  滚粗
};

typedef NS_ENUM(NSInteger, LFShareMode) {
    
    LFShareModeStreet,              //街拍
    LFShareModeKeyWor,              //关键字
    LFShareModeBird,                //关键字小鸟
    LFShareModeApp,                 //应用分享
    LFShareModeWeb,                 //网页分享
};

/**
 
 平台ID（外键：t_platform:id）( 0：标准登录，1：新浪登录，2：腾讯登录，3：人人登录。。。)
 
 */

typedef NS_ENUM(NSInteger ,LFPlatformType) {
    
    LFPlatformTypeNormal,
    LFPlatformTypeTelephone,
    LFPlatformTypeEmail,
    LFPlatformTypeSina,
    LFPlatformTypeTencent,
    LFPlatformTypeWechat,
    LFPlatformTypeAli,
    LFPlatformTypeRenRen
};

typedef NS_ENUM(NSInteger ,LFDeviceType){
    
    LFDeviceTypeUnknown,
    LFDeviceTypeIOS,
    LFDeviceTypeAndroid,
    LFDeviceTypeWindowsPhone,
};

//货到付款、支付宝快捷支付、微信支付
typedef NS_ENUM(NSUInteger, LFPlatformPayType) {
    
    LFPlatformPayTypeNormal = 1<<0,
    LFPlatformPayTypeAlipay = 1<<1,
    LFPlatformPayTypeWechat = 1<<2
};

typedef NS_ENUM(NSInteger ,LFPayType){
    
    LFPayTypeCoin,
    LFPayTypeRMB,
    LFPayTypeMix
};

typedef NS_ENUM(NSInteger ,LFModitfyUserInfoType){
    
    LFModitfyUserInfoTypeNone         = 0,
    LFModitfyUserInfoTypeHeadImage    = 1 << 0,
    LFModitfyUserInfoTypeEmail        = 1 << 1,
    LFModitfyUserInfoTypeNickname     = 1 << 2,
    LFModitfyUserInfoTypeTelephone    = 1 << 3,
    LFModitfyUserInfoTypeRealname     = 1 << 4,
    LFModitfyUserInfoTypeAll = LFModitfyUserInfoTypeHeadImage | LFModitfyUserInfoTypeEmail | LFModitfyUserInfoTypeNickname | LFModitfyUserInfoTypeTelephone
};

typedef NS_ENUM(NSInteger ,LFNoticeType){
    
    LFNoticeTypeLost    = 1<<0,
    LFNoticeTypeFound   = 1<<1,
    LFNoticeTypeAll     = LFNoticeTypeLost | LFNoticeTypeFound
};

typedef NS_ENUM(NSInteger ,LFNoticeState){
    
    LFNoticeStateNew,
    LFNoticeStateClose
//    LFNoticeStateDone
};

@interface LFConstants : NSObject

+ (NSString *)sexString:(LFSexType)type;
+ (LFPlatformType)platformFromShareType:(UMSocialSnsType)type;
+ (NSString *)userNotificationTypeDescription:(UIUserNotificationType)userNotificationType;

+ (NSString *)distanceDescription:(CLLocationDistance)distance;

@end
