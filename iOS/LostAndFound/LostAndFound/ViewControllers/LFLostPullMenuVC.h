//
//  LFLostPullMenuVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFPullMenuViewController.h"

#import "LFCreateNoticeVC.h"

@interface LFLostPullMenuVC : LFPullMenuViewController

- (id)initWithRightViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *)rightViewController
             centerViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting, LFCreateNoticeDelegate> *)centerViewController;

@end
