//
//  LFPullMenuViewController.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

@protocol LFPullMenuViewControllerChild;
@protocol LFPullMenuViewControllerPresenting;

@interface LFPullMenuViewController : LFBaseViewController

@property(nonatomic, assign) BOOL enablePull;
@property(nonatomic, assign) CGFloat pullProgress;

@property(nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

@property(nonatomic, strong, readonly) UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *rightViewController;

@property(nonatomic, strong, readonly) UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *centerViewController;

- (id)initWithRightViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *)leftViewController
            centerViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *)centerViewController;

- (void)close;

@end


@protocol LFPullMenuViewControllerChild <NSObject>

@property(nonatomic, assign) LFPullMenuViewController *menu;

@end

@protocol  LFPullMenuViewControllerPresenting <NSObject>
@optional

- (void)menuControllerWillOpen:(LFPullMenuViewController *)menuController;

- (void)menuControllerDidSwip:(LFPullMenuViewController *)menuController progress:(CGFloat)progress;

- (void)menuControllerDidClose:(LFPullMenuViewController *)menuController;

@end
