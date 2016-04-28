//
//  LFNavigationControllerAnimation.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-26.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFNavigationControllerAnimation.h"

@implementation LFNavigationControllerAnimation

- (id)init {
    if (self = [super init]) {
        self.duration = 0.3f;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                   fromVC:(UIViewController *)fromVC
                     toVC:(UIViewController *)toVC
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView {

    if ([self reverse]) {
        [self pushAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    else{
        [self popAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
               fromVC:(UIViewController *)fromVC
                 toVC:(UIViewController *)toVC
             fromView:(UIView *)fromView
               toView:(UIView *)toView {

    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView insertSubview:toView aboveSubview:fromView];

    [toView setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, CGRectGetWidth([toView frame]), 0)];

    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{

                         [fromView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
                         [toView setTransform:CGAffineTransformIdentity];
                     }
                     completion:^(BOOL finished) {

                         [fromView setTransform:CGAffineTransformIdentity];
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
               fromVC:(UIViewController *)fromVC
                 toVC:(UIViewController *)toVC
             fromView:(UIView *)fromView
               toView:(UIView *)toView {

    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView insertSubview:toView belowSubview:fromView];

    [toView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];

    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{

                         [fromView setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, CGRectGetWidth([fromView frame]), 0)];
                         [toView setTransform:CGAffineTransformIdentity];
                     }
                     completion:^(BOOL finished) {

                         if (![transitionContext transitionWasCancelled]) {
                             [fromView removeFromSuperview];
                         }
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
