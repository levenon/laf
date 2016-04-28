//
//  LFAppManager.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-16.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <Fabric/Fabric.h>

#import <Crashlytics/Crashlytics.h>

#import "LFAppManager.h"

#import "GeTuiSdk.h"

#import "LFUserManager.h"

#import "LFLocationManager.h"

#import "LFUMengSocialManager.h"

#import "LFNotificationManager.h"

#import "LFGeTuiPushToken.h"

#import "LFNotification.h"

#import "LFCategoryManager.h"

#import "LFGetTuiManager.h"

#import "LFShareSDKManager.h"

NSString* const LFAppManagerArchiveFileName = @"com.graduationproject.setting.archive";

@interface XLFAppManager (Private)

- (void)_efRegisterAppId:(NSString *)appId;

@end

@interface LFAppManager ()<CrashlyticsDelegate, GeTuiSdkDelegate, LFHttpRequestManagerProtocol>

@property(nonatomic, strong) LFSystemSetting *evSetting;

@property(nonatomic, strong) LFGeTuiPushToken *evGeTuiPushToken;

@property(nonatomic, assign) BOOL evFirstLaunch;

@property(nonatomic, assign) BOOL evNewVersion;

@end

@implementation LFAppManager

+ (void)load{
    [super load];
    
    if(![NSFileManager fileExistsAtPath:SDArchiverDirectory]){
        [NSFileManager createDirectoryAtPath:SDArchiverDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - accessory

- (LFSystemSetting*)evSetting{
    
    if (!_evSetting) {
        
        _evSetting = [LFSystemSetting model];
    }
    return _evSetting;
}

+ (LFAppManager*)sharedInstance;{
    
    static LFAppManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LFAppManager alloc] init];
    });
    return manager;
}

#pragma mark - public

+ (void)efApplicationWillFinishLaunchingWithOptions:(NSDictionary *)launchOptions;{
    
    [[self sharedInstance] _efApplicationWillFinishLaunchingWithOptions:launchOptions];
}

+ (void)efApplicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;{
    
    [[self sharedInstance] _efApplicationDidFinishLaunchingWithOptions:launchOptions];
}

+ (void)efHandleLocalNotification:(UILocalNotification *)notification;{
    
    [[self sharedInstance] _efHandleLocalNotification:notification];
}

+ (void)efHandleNotification:(NSDictionary *)userInfo backgroundFetch:(BOOL)backgroundFetch;{
    
    [[self sharedInstance] _efHandleNotification:userInfo backgroundFetch:backgroundFetch];
}

+ (void)efRegisterDeviceToken:(NSData *)deviceToken;{
    
    [[self sharedInstance] _efRegisterDeviceToken:deviceToken];
}

+ (void)efFailedRegisterDeviceTokenWithError:(NSError *)error;{
    
    [[self sharedInstance] _efFailedRegisterDeviceTokenWithError:error];
}

- (void)efUpdateToDisk;{
    
    [NSKeyedArchiver archiveRootObject:[self evSetting] toFile:SDArchiverFolder(LFAppManagerArchiveFileName)];
}

#pragma mark - private

- (void)_efInitFromDisk;{
    
    LFSystemSetting *etSystemSettings = [NSKeyedUnarchiver unarchiveObjectWithFile:SDArchiverFolder(LFAppManagerArchiveFileName)];
    
    if (etSystemSettings) {
        
        [self setEvSetting:etSystemSettings];
    }
    else{
        
        NSDictionary *etDefaultSystemSettings = [[LFConfigManager shareConfigManager] customConfiguration];
        
        [self setEvSetting:[LFSystemSetting modelWithAttributes:[etDefaultSystemSettings objectForKey:@"defaultSystemConfiguration"]]];
        
        [self efUpdateToDisk];
    }
    
    [[self evSetting] addObserverForOldValueChanged:self];
    [[self evSetting] efConfigurate];
}

- (void)_efApplicationWillFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self _efInitFromDisk];
    
    [self _efConfigurateAppEnvironmentWithLaunchOptions:launchOptions];
}

- (void)_efApplicationDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;{
    
    if ([[self evSetting] hasLaunched]) {
        [self setEvFirstLaunch:NO];
    }
    else{
        [self setEvFirstLaunch:YES];
        [[self evSetting] setHasLaunched:YES];
    }
    
    if ([ntoe([[self evSetting] appVersion]) compare:[NSBundle appVersion]] == NSOrderedAscending) {
        [[self evSetting] setAppVersion:[NSBundle appVersion]];
        [self setEvNewVersion:YES];
    }
    else{
        [self setEvNewVersion:NO];
    }
    
    [self _efConfigurateUserEnvironmentWithLaunchOptions:launchOptions];
}

- (void)_efRegisterDeviceToken:(NSData *)deviceToken;{
    
    [GeTuiSdk registerDeviceToken:[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NIF_DEBUG(@"Register use deviceToken : %@",[deviceToken description]);
}

- (void)_efFailedRegisterDeviceTokenWithError:(NSError *)error;{
    
    [GeTuiSdk registerDeviceToken:@""];
    
    NIF_ERROR(@"Failed register deviceToken : %@", error);
}

- (void)_efConfigurateAppEnvironmentWithLaunchOptions:(NSDictionary *)launchOptions{
    
    [CrashlyticsKit setDelegate:self];
    [CrashlyticsKit setDebugMode:YES];
    [[Fabric sharedSDK] setDebug:YES];
    [Fabric with:@[[Crashlytics class]]];
    
    [LFUMengSocialManager efConfigurate];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    egfRegisterGlobalBackgroundColor([UIColor whiteColor]);
}

- (void)_efConfigurateUserEnvironmentWithLaunchOptions:(NSDictionary *)launchOptions{
    
    [LFHttpRequest registerVisibleViewControllerBlockForGlobal:^UIViewController *(UIView *loadingView, BOOL isHiddenLoadingView) {
        
        UIViewController *etVisibleVC = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] evVisibleViewController];
        
        if ([etVisibleVC tabBarController]) {
            return [etVisibleVC tabBarController];
        }
        
        if ([etVisibleVC navigationController]) {
            return [etVisibleVC navigationController];
        }
        
        return etVisibleVC;
    }];
    
    
    [LFLocationManagerRef setEvEnableLocateAddree:NO];
    [LFGetTuiManager efConfigurate:self];
    [LFShareSDKManager efConfigurate];
    [LFLocationManager efConfigurate];
    [LFUserManager efConfigurate];
    [LFCategoryManager efConfigurate];
    
    [self _efRegisterAppId:egAppId];
    [self _efRegisterUserNotification];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self _efHandleNotification:userInfo backgroundFetch:NO];
    }
    
    [self _efClearNotification];
}

/**
 *  注册通知
 */
- (void)_efRegisterUserNotification {
    
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
}

- (void)_efClearNotification{
    
    [GeTuiSdk clearAllNotificationForNotificationBar];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)_efHandleLocalNotification:(UILocalNotification *)notification{
    
    //    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)_efHandleNotification:(NSDictionary *)userInfo backgroundFetch:(BOOL)backgroundFetch;{
    
    [LFNotificationManager efHandleNotification:[[LFNotification alloc] initWithAttributes:userInfo]
                                backgroundFetch:backgroundFetch];
}

- (void)_efInitialApplicationToServer:(NSString *)deviceToken{
    
    LFHttpRequest *etreqInitialApplication = [self efInitialWithDeviceNumber:[UIDevice deviceIdentifier]
                                                                 deviceToken:deviceToken
                                                                  appVersion:[NSBundle appVersion]
                                                               bundleVersion:[NSBundle bundleVersion]
                                                               systemVersion:[UIDevice deviceSystemVersion]
                                                                  deviceName:[UIDevice deviceName]
                                                                 deviceModel:[UIDevice deviceModel]
                                                                     success:[self _efInitialApplicationToServerSuccess]
                                                                     failure:[self _efInitialApplicationToServerFailed]];
    
    [etreqInitialApplication startAsynchronous];
}

- (XLFNoneResultSuccessedBlock)_efInitialApplicationToServerSuccess{
    
    return ^(LFHttpRequest *request){
        
        NIF_SUCCESS(@"应用信息已成功提交到服务器");
    };
}

- (XLFFailedBlock)_efInitialApplicationToServerFailed{
    
    return ^(id request, NSError *error){
        
        if (10012 == [error code] || 10011 == [error code]) {
            
            [LFUserManager efLogout];
        }
        else{
            
            [MBProgressHUD showWithStatus:[error domain]];
        }
    };
}

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    [self efUpdateToDisk];
}

#pragma mark - CrashlyticsDelegate

- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL))completionHandler {
    // Use this opportinity to take synchronous action on a crash. See Crashlytics.h for
    // details and implications.
    
    // Maybe consult NSUserDefaults or show a UI prompt.
    
    // But, make ABSOLUTELY SURE you invoke completionHandler, as the SDK
    // will not submit the report until you do. You can do this from any
    // thread, but that's optional. If you want, you can just call the
    // completionHandler and return.
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completionHandler(YES);
    }];
}

- (BOOL)crashlyticsCanUseBackgroundSessions:(Crashlytics *)crashlytics;{
    
    return YES;
}

#pragma mark - GeTuiSdkDelegate

/**
 *  SDK启动成功返回cid
 *
 *  @param clientId
 */

- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    
    NIF_DEBUG(@"Success register GeTui client id : %@", clientId);
    
    NSAssert([clientId length], @"GeTui client id is nil");
    
    LFGeTuiPushToken *etGeTuiPushToken = [LFGeTuiPushToken tokenWithClientId:clientId version:[GeTuiSdk version]];
    
    [self setEvGeTuiPushToken:etGeTuiPushToken];
    [self _efInitialApplicationToServer:clientId];
}

/**
 *  SDK遇到错误回调
 *
 *  @param error
 */

- (void)GeTuiSdkDidOccurError:(NSError *)error {
    
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NIF_DEBUG(@"Failed register GeTui with error : %@", [error localizedDescription]);
}

/**
 *  前台运行时，接收socket传回的透传消息
 *
 *  @param payloadId 负载ID
 *  @param taskId    任务ID
 *  @param aMsgId    消息ID
 *  @param offLine   是否下线
 *  @param appId     应用ID
 */
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId
                        andTaskId:(NSString *)taskId
                     andMessageId:(NSString *)aMsgId
                       andOffLine:(BOOL)offLine
                  fromApplication:(NSString *)appId {
    
    NSData *etPayload = [GeTuiSdk retrivePayloadById:payloadId];
    
    if (etPayload) {
        
        NIF_DEBUG(@"%@", [[NSString alloc] initWithData:etPayload encoding:NSUTF8StringEncoding]);
        
        LFNotificationCustomContent *etNotificationCustomContent = [LFNotificationCustomContent modelWithAttributes:[etPayload objectFromJSONData]];
        
        LFNotification *etNotification = [LFNotification notificationWithNotificationAps:nil customContent:etNotificationCustomContent];
        
        [LFNotificationManager efHandleNotification:etNotification
                                    backgroundFetch:YES];
    }
}

/**
 *  收到发送消息回调
 *
 *  @param messageId 消息ID
 *  @param result    结果
 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId
                        result:(int)result {
    
    // [4-EXT]:发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    
    NIF_DEBUG(@"GexinSdk send message feedback:%@", msg);
}

/**
 *  SDK运行状态通知
 *
 *  @param aStatus 运行转台
 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    
    NIF_DEBUG(@"GexinSdk sdk state changed:%u", aStatus);
}

/**
 *  SDK设置推送模式回调
 *
 *  @param isModeOff 是否推送关闭
 *  @param error     错误
 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    
    if (error) {
        
        NIF_DEBUG(@"GexinSdk set push mode callback with error:%@", error);
        return;
    }
    
    NIF_DEBUG(@"GexinSdk set push mode callback with state:%@", select(isModeOff, @"开启", @"关闭"));
}

@end
