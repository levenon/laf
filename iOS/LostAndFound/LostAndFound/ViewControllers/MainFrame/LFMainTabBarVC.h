//
//  MainTabBarVC.h
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFBaseTabBarController.h"
#import "LFMenuController.h"

@interface LFMainTabBarVC : LFBaseTabBarController<LFMenuControllerChild, LFMenuControllerPresenting>

@property(nonatomic, assign) LFMenuController *menu;

@end
