//
//  LFUserManager.m
//  LostAndFound
//
//  Created by Marike Jave on 15/6/27.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import "GeTuiSdk.h"

#import "LFAppManager.h"

#import "LFHttpRequestManager.h"

#import "LFUserManager.h"

#import "LFLoginVC.h"

#import "LFBaseNavigationController.h"

#import "LFConfigManager.h"

#import "LFNotificationManager.h"

#import "NSObject+LFHttpRequestManager.h"

NSString *const LFUserManagerArchiveFileName = @"com.laf.userManager.archive";

@interface LFUserManager ()<XLFNotificationHandleDelegate, LFHttpRequestManagerProtocol>

@property(nonatomic, strong) LFUser *evLocalUser;

@property(nonatomic, assign, getter=evIsBeingLogin) BOOL evBeingLogin;

@end

@implementation LFUserManager

+ (void)load{
    [super load];
    
    if(![NSFileManager fileExistsAtPath:SDArchiverDirectory]){
        [NSFileManager createDirectoryAtPath:SDArchiverDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [[self shareManager] _efInitFromDisk];
}

+ (id)shareManager;{
    
    static LFUserManager *etUserManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        etUserManager = [[LFUserManager alloc] init];
    });
    return etUserManager;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self efRegisterNotification];
    }
    return self;
}

#pragma mark - accessory

- (LFUser *)evLocalUser{
    
    if (!_evLocalUser) {
        
        _evLocalUser = [LFUser model];
    }
    return _evLocalUser;
}

#pragma mark - public

- (BOOL)evIsLogin{
    
    return [[[self evLocalUser] sid] length] && [[[self evLocalUser] id] length];
}

+ (void)efConfigurate;{
    
    Reachability *etReachability = [Reachability reachabilityForInternetConnection];
    [etReachability startNotifier];
}

+ (void)efAutoLogin;{
    
    [[self shareManager] _efAutoLogin];
}

+ (void)efLogin;{
    
    [[self shareManager] _efLogin];
}

+ (void)efUpdateToDisk;{
    
    [[self shareManager] _efUpdateToDisk];
}

+ (void)efLogoutOnServer;{
    
    [[self shareManager] _efLogoutOnServer];
}

+ (void)efLogout;{
    
    [[self shareManager] _efLogout];
}

+ (void)efClearLogin;{
    
    [[self shareManager] _efClearLogin];
}

+ (void)efUpdateUser:(LFUser *)user;{
    
    [[self shareManager] _efUpdateUser:user];
}

+ (void)efAppendFoundsCount:(NSInteger)count;{
    
    [[self shareManager] _efAppendFoundsCount:count];
}

+ (void)efAppendLostsCount:(NSInteger)count;{
    
    [[self shareManager] _efAppendLostsCount:count];
}

#pragma mark - instance method

- (void)efRegisterNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateNetworkStatusChanged:) name:kReachabilityChangedNotification object:nil];
}

#pragma mark - private

- (void)_efUpdateToDisk;{
    
    [NSKeyedArchiver archiveRootObject:[self evLocalUser] toFile:SDArchiverFolder(LFUserManagerArchiveFileName)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:[self evLocalUser]];
}

- (void)_efInitFromDisk;{
    
    [self setEvLocalUser:[NSKeyedUnarchiver unarchiveObjectWithFile:SDArchiverFolder(LFUserManagerArchiveFileName)]];
    
    NIF_INFO(@"Local user info is : %@", [self evLocalUser]);
}

- (void)_efUpdateUser:(LFUser *)user;{
    
    [self setEvLocalUser:user];
    
    [self _efUpdateToDisk];
}

- (void)_efAppendFoundsCount:(NSInteger)count;{
    
    [self evLocalUser].foundsCount += count;
    [self _efUpdateToDisk];
}

- (void)_efAppendLostsCount:(NSInteger)count;{
    
    [self evLocalUser].lostsCount += count;
    [self _efUpdateToDisk];
}

- (void)_efLogout;{
    
    void (^etblcCompletionThird)() = ^(){
        
        [GeTuiSdk registerDeviceToken:@""];
        
        [[self evLocalUser] clear];
        [self _efUpdateToDisk];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutNotification object:nil];
    };
    
    void (^etblcCompletionSecond)() = ^(){
        
        UIViewController *etVisibleVC = [self evVisibleViewController];
        [[etVisibleVC navigationController] popToRootViewControllerAnimated:NO];
        
        etblcCompletionThird();
    };
    
    void (^etblcCompletionFirst)() = ^(){
        
        UIViewController *etVisibleVC = [self evVisibleViewController];
        
        if ([etVisibleVC isKindOfClass:[UIAlertController class]]) {
            
            [etVisibleVC dismissViewControllerAnimated:YES completion:etblcCompletionSecond];
        }
        else{
            etblcCompletionSecond();
        }
    };
    
    etblcCompletionFirst();
}

- (void)_efAutoLogin;{
    
    Weakself(ws);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([ws evIsLogin]){
                        
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
        }
    });
}

- (XLFFailedBlock)_efLoadOrderDetailFailed{
    
    return ^(id request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efLogin{
    
    NSArray *etChildViewControllers = [[[self evVisibleViewController] navigationController] childViewControllers];
    
    for (UIViewController *etChildViewController in etChildViewControllers) {
        
        if ([etChildViewController isKindOfClass:[LFLoginVC class]]) {
            return;
        }
    }
    
    [self setEvBeingLogin:YES];
    
    LFLoginVC *etLoginVC = [[LFLoginVC alloc] initWithLoginCallback:[self _efLoginSuccess]];
    
    LFBaseNavigationController *etLoginNC = [[LFBaseNavigationController alloc] initWithRootViewController:etLoginVC];
    
    [[self evVisibleViewController] presentViewController:etLoginNC animated:YES completion:nil];
}

- (void)_efClearLogin{
    
    [self setEvLocalUser:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutNotification object:nil];
    
    NIF_LOG(@"用户已退出");
}

- (void)_efLogoutOnServer{
    
    LFHttpRequest *etreqLogout = [self efLogoutWithSuccess:[self _efLogoutOnServerSuccess]
                                                   failure:[self _efLogoutOnServerFailed]];
    
    [etreqLogout setHiddenLoadingView:NO];
    [etreqLogout setLoadingHintsText:@"正在退出"];
    [etreqLogout startAsynchronous];
}

- (XLFNoneResultSuccessedBlock)_efLogoutOnServerSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request){
        
        [ws _efLogout];
    };
}

- (XLFFailedBlock)_efLogoutOnServerFailed{
    
    Weakself(ws);
    return ^(id request, NSError *error){
        
        [ws _efLogout];
        
        NIF_ERROR(@"从服务器中登出失败，%@", error);
    };
}

#pragma mark - LFLoginVC success Block

- (void (^)(LFLoginVC *loginVC, BOOL success))_efLoginSuccess{

    Weakself(ws);
    
    return ^(LFLoginVC *loginVC, BOOL success){
        
        [ws setEvBeingLogin:NO];
        
        if (success) {
            
            [[loginVC navigationController] dismissViewControllerAnimated:YES completion:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification object:nil];
            }];
        }
    };
}

#pragma mark - actions

- (IBAction)didNotificateNetworkStatusChanged:(NSNotification *)sender{
    
    Reachability *etReachablity = [sender object];
    
    if ([etReachablity isReachable]) {
        
        if ([self evIsLogin]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshNotification object:nil];
        }
        else{
            
            [self _efAutoLogin];
        }
    }
}

@end
