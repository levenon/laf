//
//  LFApplicationRootVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/11/23.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFApplicationRootVC.h"

#import "LFBaseNavigationController.h"

#import "LFMenuController.h"

#import "LFWelcomeVC.h"

#import "LFAppManager.h"

#import "LFUserManager.h"

#import "LFMenuController.h"
#import "LFMainTabBarVC.h"
#import "LFUserCenterVC.h"

@interface LFApplicationRootVC ()

@property(nonatomic, strong) LFBaseNavigationController *evWelcomeNC;

@property(nonatomic, strong) LFMenuController *evMainRootVC;

@end

@implementation LFApplicationRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)efConfigurate;{
    
//    if ([[LFAppManager sharedInstance] evIsNewVersion]) {
//        [self _efConfigurateWelcomeViewController];
//    }
//    else{
    
        [self _efConfigurateNormalViewController];
//    }
}

#pragma mark - accessory{

- (UIViewController *)evVisibleViewController{
    
    if ([[self childViewControllers] lastObject]) {
        
        return [[[self childViewControllers] lastObject] evVisibleViewController];
    }
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return [[self evVisibleViewController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [[self evVisibleViewController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return [[self evVisibleViewController] preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate{
    
    return [[self evVisibleViewController] shouldAutorotate];
}

- (BOOL)prefersStatusBarHidden{
    
    return [[self evVisibleViewController] prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return  [[self evVisibleViewController] preferredStatusBarStyle];
}

#pragma mark - private

- (void)_efAddChildViewController:(UIViewController *)childViewController{
    
    [childViewController willMoveToParentViewController:self];
    [self addChildViewController:childViewController];
    [childViewController didMoveToParentViewController:self];
    
    [[childViewController view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [[childViewController view] setFrame:[[self view] bounds]];
    [[self view] addSubview:[childViewController view]];
}

- (void)_efRemoveChildViewController:(UIViewController *)childViewController{
    
    [[childViewController view] removeFromSuperview];
    
    [childViewController willMoveToParentViewController:nil];
    [childViewController removeFromParentViewController];
    [childViewController didMoveToParentViewController:nil];
}

- (void)_efPushTransformFromViewController:(UIViewController *)fromViewController
                          toViewController:(UIViewController *)toViewController
                                   animate:(BOOL)animate
                                completion:(void (^)())completion{
    
    [self _efAddChildViewController:toViewController];
    
    Weakself(ws);
    void (^etblcTransformCompletion)() = ^(){
        
        [ws _efRemoveChildViewController:fromViewController];
        
        if (completion) {
            completion();
        }
    };
    
    if (animate) {
        
        [[toViewController view] setFrame:CGRectMake(CGRectGetWidth([[self view] bounds]), 0,
                                                     CGRectGetWidth([[self view] bounds]), CGRectGetHeight([[self view] bounds]))];
        
        void (^etblcTransform)() = ^(){
            
            [[fromViewController view] setFrame:CGRectMake(-CGRectGetWidth([[ws view] bounds]), 0,
                                                           CGRectGetWidth([[ws view] bounds]), CGRectGetHeight([[ws view] bounds]))];
            
            [[toViewController view] setFrame:[[ws view] bounds]];
        };
        
        [UIView animateWithDuration:0.3
                         animations:etblcTransform
                         completion:^(BOOL finished) {
                             
                             etblcTransformCompletion();
                         }];
    }
    else{
        
        etblcTransformCompletion();
    }
}

- (void)_efPresentTransformFromViewController:(UIViewController *)fromViewController
                             toViewController:(UIViewController *)toViewController
                                      animate:(BOOL)animate
                                   completion:(void (^)())completion{
    
    [self _efAddChildViewController:toViewController];
    
    [[self view] exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
    
    Weakself(ws);
    
    void (^etblcTransformCompletion)() = ^(){
        
        [ws _efRemoveChildViewController:fromViewController];
        
        if (completion) {
            completion();
        }
    };
    
    if (animate) {
            
        void (^etblcTransform)() = ^(){
            
            [[fromViewController view] setFrame:CGRectMake(0, CGRectGetHeight([[ws view] bounds]),
                                                           CGRectGetWidth([[ws view] bounds]), CGRectGetHeight([[ws view] bounds]))];
        };
        
        [UIView animateWithDuration:0.3
                         animations:etblcTransform
                         completion:^(BOOL finished) {
                             
                             etblcTransformCompletion();
                         }];
    }
    else{
        
        etblcTransformCompletion();
    }
}

- (void)_efConfigurateWelcomeViewController{
    
    LFWelcomeVC *etWelcomeVC = [[LFWelcomeVC alloc] initWithTransformCallback:[self _efWelcomeTransformCallback]
                                                                     callback:[self _efWelcomeOverCallback]];
    
    LFBaseNavigationController *etWelcomeNC = [[LFBaseNavigationController alloc] initWithRootViewController:etWelcomeVC];
    
    [self setEvWelcomeNC:etWelcomeNC];
    [self _efAddChildViewController:etWelcomeNC];
}

- (void)_efConfigurateNormalViewController{
    
    [self _efAddChildViewController:[self _efCreateMainRootVC]];
    
    [LFUserManager efAutoLogin];
}

- (LFMenuController *)_efCreateMainRootVC{
    
    LFUserCenterVC *etUserCenterVC = [LFUserCenterVC viewController];
    LFMainTabBarVC *etMainTabBarVC = [LFMainTabBarVC viewController];
    
    LFMenuController *etMainRootVC = [[LFMenuController alloc] initWithLeftViewController:etUserCenterVC
                                                                     centerViewController:etMainTabBarVC];
    
    [self setEvMainRootVC:etMainRootVC];
    return etMainRootVC;
}

- (void (^)(LFWelcomeVC *welcomeVC, UIViewController *viewController))_efWelcomeTransformCallback{
    
    Weakself(ws);
    
    return ^(LFWelcomeVC *welcomeVC, UIViewController *viewController){
        
        if ([[ws evVisibleViewController] navigationController]) {
            
            UINavigationController *etNavigationController = [[ws evVisibleViewController] navigationController];
            
            [etNavigationController pushViewController:viewController animated:YES];
        }
        else{
            
            [ws _efPushTransformFromViewController:welcomeVC
                                  toViewController:viewController
                                           animate:YES
                                        completion:nil];
        }
    };
}

- (void (^)(LFWelcomeVC *welcomeVC, UIViewController *viewController, void (^afterCallback)()))_efWelcomeOverCallback{
    
    Weakself(ws);
    
    return ^(LFWelcomeVC *welcomeVC, UIViewController *viewController, void (^afterCallback)()){
        
        UIViewController *etFromViewController = welcomeVC;
        
        if ([etFromViewController navigationController]) {
            etFromViewController = [welcomeVC navigationController];
        }
        
        UIViewController *etMainRootVC = [self _efCreateMainRootVC];
        
        [ws _efPresentTransformFromViewController:etFromViewController
                                 toViewController:etMainRootVC
                                          animate:YES
                                       completion:^{
                                           
                                           afterCallback();
                                       }];
    };
}

@end
