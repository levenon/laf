//
//  LFBaseTabBarController.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-10.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <XLFViewControllerAnimationKit/XLFViewControllerAnimationKit.h>
#import "LFBaseTabBarController.h"
#import "LFRefreshProtocol.h"
#import "LFHttpRequestManager.h"

@interface LFBaseTabBarController ()<UITabBarControllerDelegate>

@property(nonatomic, strong) CECrossfadeAnimationController *animationController;

@end

@implementation LFBaseTabBarController

- (void)dealloc{

    [LFHttpRequestManager removeAndCancelAllRequestByUserTag:NSStringFromClass([self class])];
    [self efDeregisterNotification];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [self setDelegate:self];
    [self setSelectedIndex:1];

    // create the interaction / animation controllers
    [self setAnimationController:[CECrossfadeAnimationController new]];
    [[self animationController] setDuration:0.2];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController<LFRefreshProtocol> *)viewController;{

    if ([self selectedViewController] == viewController) {

        BOOL enableRefresh = YES;
        if ([[(id)viewController evVisibleViewController] respondsToSelector:@selector(evIsRefreshing)]) {

            enableRefresh = ![(id)[(id)viewController evVisibleViewController] evIsRefreshing];
        }
        if (enableRefresh && [[(id)viewController evVisibleViewController] respondsToSelector:@selector(efRefreshTrigger)]) {

            [(id)[(id)viewController evVisibleViewController] efRefreshTrigger];
        }
    }
    return YES;
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {

    NSUInteger fromVCIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toVCIndex = [tabBarController.viewControllers indexOfObject:toVC];

    [[self animationController] setReverse:fromVCIndex < toVCIndex];
    return [self animationController];
}

@end
