//
//  LFCategorySelectorVC.h
//  LostAndFound
//
//  Created by Marike Jave on 16/1/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

@class LFCategorySelectorVC;

@protocol LFCategorySelectorVCDelegate <NSObject>

- (void)epCategorySelectorVC:(LFCategorySelectorVC *)categorySelectorVC didSelectedCategory:(LFCategory *)category;

@end

@interface LFCategorySelectorVC : LFBaseViewController

@property(nonatomic, strong, readonly) LFCategory *evSelectedCategory;

@property(nonatomic, assign, readonly) id<LFCategorySelectorVCDelegate> evDelegate;

- (instancetype)initWithDelegate:(id<LFCategorySelectorVCDelegate>)delegate;

@end
