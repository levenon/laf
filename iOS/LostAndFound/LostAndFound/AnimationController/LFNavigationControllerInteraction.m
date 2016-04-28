//
//  LFNavigationControllerInteraction.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-26.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFNavigationControllerInteraction.h"

@interface  LFNavigationControllerInteraction()<UIGestureRecognizerDelegate>

@property(nonatomic, assign) BOOL shouldCompleteTransition;
@property(nonatomic, assign) UIViewController *viewController;
@property(nonatomic, strong) UIPanGestureRecognizer *gesture;
@property(nonatomic, assign) CEInteractionOperation operation;

@end

@implementation LFNavigationControllerInteraction{
}

- (void)dealloc {
    [self.gesture.view removeGestureRecognizer:self.gesture];
}

- (void)wireToViewController:(UIViewController *)viewController forOperation:(CEInteractionOperation)operation{
    self.operation = operation;
    self.viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    self.gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.gesture.delegate = self;
    [view addGestureRecognizer:self.gesture];
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{

    NSParameterAssert([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);

    CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview];

    return velocity.x > 0 && velocity.y > 0 && velocity.x >= velocity.y;
}

- (void)handleGesture:(UIPanGestureRecognizer*)gestureRecognizer {

    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view.superview];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {

            BOOL leftToRightSwipe = translation.x > 0;

            // perform the required navigation operation ...

            if (self.operation == CEInteractionOperationPop) {
                // for pop operation, fire on right-to-left
                if (leftToRightSwipe) {
                    self.interactionInProgress = YES;
                    [self.viewController.navigationController popViewControllerAnimated:YES];
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.interactionInProgress) {
                // compute the current position
                CGFloat fraction = fabs(location.x / gestureRecognizer.view.superview.frame.size.width);
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                self.shouldCompleteTransition = (fraction > 0.5);

//                if (fraction >= 1.0)
//                    fraction = 0.99;

                [self updateInteractiveTransition:fraction];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                if (!self.shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
}

- (void)setEnable:(BOOL)enable{
    [_gesture setEnabled:enable];
}

- (BOOL)enable{
    return [_gesture isEnabled];
}

@end
