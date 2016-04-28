//
//  LFBaseNavigationController.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-10.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFBaseNavigationController.h"
#import "LFNavigationControllerAnimation.h"
#import "LFNavigationControllerInteraction.h"
#import "LFHttpRequestManager.h"

@interface LFBaseNavigationController ()

@property(nonatomic, strong) CEReversibleAnimationController *evAnimationController;
@property(nonatomic, strong) CEBaseInteractionController *evInteractionController;

@end

@implementation LFBaseNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self navigationBar] setBarStyle:UIBarStyleBlack];
    
    // create the interaction / animation controllers
    [self setEvAnimationController:[LFNavigationControllerAnimation new]];
    [self setEvInteractionController:[LFNavigationControllerInteraction new]];
}

- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated{
    [super pushViewController:viewController
                     animated:animated];

}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated;{
    [super navigationController:navigationController didShowViewController:viewController animated:animated];

    [[self evInteractionController] setEnable:[[self childViewControllers] count] > 1];
}

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                  animationControllerForOperation:(UINavigationControllerOperation)operation
//                                               fromViewController:(UIViewController *)fromVC
//                                                 toViewController:(UIViewController *)toVC{
//
//    // when a push occurs, wire the interaction controller to the to- view controller
//    if ([self evInteractionController]) {
//        [[self evInteractionController] wireToViewController:toVC forOperation:CEInteractionOperationPop];
//    }
//
//    if ([self evAnimationController]) {
//        [[self evAnimationController] setReverse:operation == UINavigationControllerOperationPush];
//    }
//
//    return [self evAnimationController];
//
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
//                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
//
//    // if we have an interaction controller - and it is currently in progress, return it
//    return [self evInteractionController] && [[self evInteractionController] interactionInProgress] ? [self evInteractionController] : nil;
//}

@end
