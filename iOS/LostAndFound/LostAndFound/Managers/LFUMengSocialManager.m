//
//  LFUMengSocialManager.m
//  LostAndFound
//
//  Created by Marike Jave on 15/6/29.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "LFUMengSocialManager.h"

#import "LFConstants.h"

#import "UMSocial.h"

#import "UMSocialWechatHandler.h"

#import "UMSocialQQHandler.h"

#import "UMSocialSinaHandler.h"

#import "UMSocialSinaSSOHandler.h"

#import "WXApi.h"

#import "MobClick.h"

@implementation LFUMengSocialManager

+ (void)efConfigurate;{
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:egUMengAppKey];
    
    NIF_DEBUG(@"UMSocialData appKey : %@", egUMengAppKey);
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:egWechatAppKey appSecret:egWechatAppSecret url:egRedirectUrl];
    NIF_DEBUG(@"Wechat appKey : %@ , appSecret : %@", egWechatAppKey, egWechatAppSecret);
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:egUMengRedirectUrl];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:egUMengRedirectUrl];

    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:egQQAppId appKey:egQQAppKey url:egRedirectUrl];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToSina, UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
#if (BUILD_ENVIRONMENT != BUILD_ENVIRONMENT_PRODUCTION)
    [MobClick setLogEnabled:YES];
#endif
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:egUMengAppKey];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */

+ (BOOL)efHandleOpenURL:(NSURL *)url;{
    
    return  [UMSocialSnsService handleOpenURL:url];
}

+ (BOOL)efOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;{
    
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
+ (void)efApplicationDidBecomeActive;{
    
    [UMSocialSnsService  applicationDidBecomeActive];
}


#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq*)req;{
    
}

- (void)onResp:(BaseResp*)resp;{
    
}

@end
