//
//  LFTabBarItemNC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseNavigationController.h"
#import "LFPullMenuViewController.h"

@interface LFTabBarItemNC : LFBaseNavigationController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting>

@property(nonatomic, assign) LFPullMenuViewController *menu;

@end
