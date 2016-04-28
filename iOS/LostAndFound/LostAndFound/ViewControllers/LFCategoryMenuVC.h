//
//  LFCategoryMenuVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"
#import "LFPullMenuViewController.h"

#import "LFCategory.h"

@class LFCategoryMenuVC;

@protocol LFCategoryMenuVCDelegate <NSObject>

- (void)epMenuVC:(LFCategoryMenuVC *)menuVC didSelectedCategory:(LFCategory *)category;

@end

@interface LFCategoryMenuVC : LFBaseViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting>

@property(nonatomic, assign) LFPullMenuViewController *menu;

@property(nonatomic, strong, readonly) LFCategory *evSelectedCategory;

@property(nonatomic, assign, readonly) id<LFCategoryMenuVCDelegate> evDelegate;

- (instancetype)initWithDelegate:(id<LFCategoryMenuVCDelegate>)delegate;

@end
