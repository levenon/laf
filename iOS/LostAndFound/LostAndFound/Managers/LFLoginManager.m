//
//  LFLoginManager
//  gp
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import "LFLoginManager.h"
#import "LFUserManager.h"
#import "LFShareManager.h"
#import "LFAppManager.h"

#import "LFHttpRequestManager.h"

@interface LFLoginManager ()<UMSocialUIDelegate, LFHttpRequestManagerProtocol>

@property(nonatomic, assign) id<LFLoginManagerDelegate> evDelegate;

@end

@implementation LFLoginManager

+ (LFLoginManager *)sharedInstance;{
    
    static LFLoginManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[LFLoginManager alloc] init];
    });
    return instance;
}

+ (void)efThirdPlatformLoginWithType:(UMSocialSnsType)type
//                     showLoadingView:(BOOL)showLoadingView
                            delegate:(id<LFLoginManagerDelegate>)delegate{
    
    [[self sharedInstance] _efThirdPlatformLoginWithType:type delegate:delegate];
}

+ (void)efThirdPlatformLoginWithUserInfo:(UMSocialAccountEntity *)userInfo
//                         showLoadingView:(BOOL)showLoadingView
                                delegate:(id<LFLoginManagerDelegate>)delegate;{
    
    [[self sharedInstance] _efThirdPlatformLoginWithUserInfo:userInfo delegate:delegate];
}

+ (void)efNormalLoginWithUserName:(NSString*)username
                         password:(NSString*)password
                  showLoadingView:(BOOL)showLoadingView
                         delegate:(id<LFLoginManagerDelegate>)delegate;{
    
    [[self sharedInstance] _efNormalLoginWithUserName:username password:password showLoadingView:showLoadingView delegate:delegate];
}



//- (void)efCommitUserInfoToServerWith:(UMSocialAccountEntity *)userInfo
//                     showLoadingView:(BOOL)showLoadingView{
//
//    LFHttpRequest* etRequest = [self efModifyUserInfoWithHeadImgUrl:[userInfo iconURL]
//                                                              email:nil
//                                                           nickname:[userInfo userName]
//                                                          telephone:nil
//                                                         modifyType:LFModitfyUserInfoTypeNickname | LFModitfyUserInfoTypeHeadImage
//                                                            success:[self efUploadSuccessBlock:userInfo]
//                                                            failure:[self efFailedBlock]];
//
//    [etRequest setLoadingHintsText:@"正在提交资料"];
//    [etRequest setHiddenLoadingView:!showLoadingView];
//    [etRequest setEvUserTag:NSStringFromClass([self class])];
//    [etRequest startAsynchronous];
//}

#pragma mark - private

- (BOOL)_efShouldLoginFromPlatform:(UMSocialSnsType)type{
    
    switch (type) {
        case UMSocialSnsTypeWechatSession:
        case UMSocialSnsTypeWechatTimeline:
        case UMSocialSnsTypeWechatFavorite:
            
            if (![WXApi isWXAppInstalled]) {
                [MBProgressHUD showWithStatus:@"请安装微信"];
                return NO;
            }
            break;
            
        default:
            break;
    }
    return YES;
}

- (void)_efThirdPlatformLoginWithType:(UMSocialSnsType)type
                             delegate:(id<LFLoginManagerDelegate>)delegate{
    
    if (![self _efShouldLoginFromPlatform:type]) {
        return;
    }
    
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:type];
    
    [self setEvDelegate:delegate];
    
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    
    snsPlatform.loginClickHandler([self evVisibleViewController], [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        // 获取用户名、uid、token等
        if ([response responseCode] == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            
            [self _efThirdPlatformLoginWithUserInfo:snsAccount
                                           delegate:delegate];
        }
        else{
            
            NIF_ERROR(@"登录失败, 错误描述:%@",[response error]);
            
            if (delegate && [delegate respondsToSelector:@selector(epLoginManager:success:error:)]) {
                
                [delegate epLoginManager:self success:NO error:[NSError errorWithDomain:@"授权失败" code:NSIntegerMax userInfo:nil]];
            }
        }
    });
}

- (void)_efThirdPlatformLoginWithUserInfo:(UMSocialAccountEntity *)userInfo
                                 delegate:(id<LFLoginManagerDelegate>)delegate;{
    
    LFHttpRequest *etLoginRequest = [self efLoginWithAccount:nil
                                                    password:nil
                                                platformType:[LFConstants platformFromShareType:[[UMSocialSnsPlatformManager getSocialPlatformWithName:[userInfo platformName]] shareToType]]
                                                      openId:[userInfo usid]
                                                 deviceToken:[[LFAppManagerRef evGeTuiPushToken] clientId]
                                                      genter:0
                                                    nickname:[userInfo userName]
                                                headImageUrl:[userInfo iconURL]
                                                     success:[self efLoginSuccessBlock]
                                                     failure:[self efFailedBlock]];
    [etLoginRequest startAsynchronous];
}

- (void)_efNormalLoginWithUserName:(NSString*)username
                          password:(NSString*)password
                   showLoadingView:(BOOL)showLoadingView
                          delegate:(id<LFLoginManagerDelegate>)delegate;{
    
    [self setEvDelegate:delegate];
    
    LFHttpRequest *etLoginRequest = [self efLoginWithAccount:username
                                                    password:password
                                                platformType:LFPlatformTypeNormal
                                                      openId:nil
                                                 deviceToken:[[LFAppManagerRef evGeTuiPushToken] clientId]
                                                      genter:0
                                                    nickname:nil
                                                headImageUrl:nil
                                                     success:[self efLoginSuccessBlock]
                                                     failure:[self efFailedBlock]];
    
    if (showLoadingView) {
        [MBProgressHUD hideAllHUDsForWindowAnimated:NO];
    }
    
    [etLoginRequest setLoadingHintsText:@"正在登录"];
    [etLoginRequest setHiddenLoadingView:!showLoadingView];
    [etLoginRequest startAsynchronous];
}


#pragma mark - Http Request Block

- (LFLoginSuccessedBlock)efLoginSuccessBlock{
    
    LFLoginSuccessedBlock success = ^(LFHttpRequest *request, id json, LFUser *user/* LFUser */){
        
        [LFUserManager efUpdateUser:user];
        
        if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epLoginManager:success:error:)]) {
            [[self evDelegate] epLoginManager:self success:YES error:nil];
        }
    };
    return success;
}

//- (XLFNoneResultSuccessedBlock)efUploadSuccessBlock:(UMSocialAccountEntity *)userInfo{
//
//    XLFNoneResultSuccessedBlock success = ^(LFHttpRequest *request){
//
//        [[[LFUserManager shareManager] evLocalUser] setNickname:[userInfo userName]];
//        [[[LFUserManager shareManager] evLocalUser] setHeadImgUrl:[userInfo iconURL]];
//        [LFUserManager efUpdateToDisk];
//
//        if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epLoginManager:success:error:)]) {
//            [[self evDelegate] epLoginManager:self success:YES error:nil];
//        }
//    };
//
//    return success;
//}

- (XLFFailedBlock)efFailedBlock{
    
    XLFFailedBlock failure = ^(XLFBaseHttpRequest *request, NSError *error){
        
        if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epLoginManager:success:error:)]) {
            [[self evDelegate] epLoginManager:self success:NO error:error];
        }
    };
    return failure;
}

@end
