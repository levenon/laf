//
//  AppDelegate.m
//  LostAndFound
//
//  Created by Marike Jave on 14/7/23.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

#import "GeTuiSdk.h"

#import "LFAppDelegate.h"

#import "LFUMengSocialManager.h"

#import "LFAppManager.h"

#import "LFApplicationRootVC.h"

@implementation LFAppDelegate

/**
 *  应用即将启动
 *
 *  @param application   应用实例
 *  @param launchOptions 启动选项
 *
 *  @return 是否成功
 */
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions{
    
    [LFAppManager efApplicationWillFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

/**
 *  应用启动
 *
 *  @param application   应用实例
 *  @param launchOptions 启动选项
 *
 *  @return 是否成功
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    
    LFApplicationRootVC *etApplicationRootVC = [LFApplicationRootVC viewController];
    
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setBackgroundColor:[UIColor blackColor]];
    [[self window] setRootViewController:etApplicationRootVC];
    [[self window] makeKeyAndVisible];
    
    [LFAppManager efApplicationDidFinishLaunchingWithOptions:launchOptions];
    [etApplicationRootVC efConfigurate];
    
    return YES;
}

/**
 *  应用失去激活状态
 *
 *  @param application 应用实例
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

/**
 *  应用已经进入后台
 *
 *  @param application 应用实例
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [GeTuiSdk runBackgroundEnable:YES];
}

/**
 *  应用即将进入前台运行
 *
 *  @param application 应用实例
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

/**
 *  应用获得激活状态
 *
 *  @param application 应用实例
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];
    
    [LFUMengSocialManager efApplicationDidBecomeActive];
}

/**
 *  应用被终止运行
 *
 *  @param application 应用实例
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  应用打开连接
 *
 *  @param application 应用实例
 *  @param url         要打开的链接
 *
 *  @return 是否打开成功
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return [LFUMengSocialManager efHandleOpenURL:url];
}

/**
 *  应用打开连接
 *
 *  @param application       应用实例
 *  @param url               要打开的链接
 *  @param sourceApplication 源应用名
 *  @param annotation        注释
 *
 *  @return 是否打开成功
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [LFUMengSocialManager efOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

/**
 *  注册通知设置
 *
 *  @param application          应用实例
 *  @param notificationSettings 通知设置
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    
    [application registerForRemoteNotifications];
}

/**
 *  注册远程通知失败
 *
 *  @param application 应用实例
 *  @param deviceToken 错误
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;{
    
    [LFAppManager efFailedRegisterDeviceTokenWithError:error];
}

/**
 *  成功注册远程通知
 *
 *  @param application 应用实例
 *  @param deviceToken 设备令牌
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [LFAppManager efRegisterDeviceToken:deviceToken];
}

/**
 *  收到远程推送
 *
 *  @param application 应用实例
 *  @param userInfo    推送附加用户信息
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NIF_DEBUG(@"Receive remote notification : %@", userInfo);
    
    [LFAppManager efHandleNotification:userInfo backgroundFetch:NO];
}

///**
// *  收到本地推送
// *
// *  @param application  应用实例
// *  @param notification 本地通知
// */
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//
//    NIF_DEBUG(@"Receive local notification : %@", notification);
//
//    [LFAppManager efHandleLocalNotification:notification];
//}
//
///**
// *  静默推送
// *
// *  @param application       应用实例
// *  @param userInfo          推送附加用户信息
// *  @param completionHandler 完成回调
// */
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
//
//    [LFAppManager efHandleNotification:userInfo backgroundFetch:YES];
//
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
///**
// *  后台抓取数据
// *
// *  @param application       应用实例
// *  @param completionHandler 完成操作回调
// */
//- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//    [GeTuiSdk resume];
//
//    completionHandler(UIBackgroundFetchResultNewData);
//}

@end
