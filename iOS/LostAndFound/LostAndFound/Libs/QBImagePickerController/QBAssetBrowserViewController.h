//
//  QBAssetBrowserViewController.h
//  LostAndFound
//
//  Created by Marke Jave on 15/12/25.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QBAssetBrowserViewController;

@protocol QBAssetBrowserViewControllerDelegate <NSObject>

- (BOOL)assetBrowserViewController:(QBAssetBrowserViewController *)assetBrowserViewController canSelectAssetAtIndex:(NSUInteger)index;
- (void)assetBrowserViewController:(QBAssetBrowserViewController *)assetBrowserViewController didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index;

- (void)assetDidDoneInBrowserViewController:(QBAssetBrowserViewController *)assetBrowserViewController;

@end

@interface QBAssetBrowserViewController : UIViewController

@property(nonatomic, assign, readonly) id<QBAssetBrowserViewControllerDelegate> delegate;
@property(nonatomic, assign, readonly) NSInteger currentIndex;
@property(nonatomic, strong, readonly) NSArray<ALAsset *> *assets;
@property(nonatomic, strong, readonly) NSOrderedSet<ALAsset *> *selectedAssets;

@property(nonatomic, assign) BOOL showSelectButton;
@property(nonatomic, assign) BOOL showDoneButton;

@property(nonatomic, assign) UIBarStyle navigationBarStyle;
@property(nonatomic, assign) BOOL navigationBarTranslucent;
@property(nonatomic, strong) UIColor *navigationBarTintColor;
@property(nonatomic, strong) UIColor *navigationBarBarTintColor;
@property(nonatomic, strong) UIImage *navigationBarBackgroundImage;
@property(nonatomic, strong) UIImage *navigationBarShadowImage;
@property(nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property(nonatomic, assign) BOOL statusBarHidden;

- (id)initWithDelegate:(id<QBAssetBrowserViewControllerDelegate>)delegate
        selectedAssets:(NSOrderedSet<ALAsset *> *)selectedAssets
                assets:(NSArray<ALAsset *> *)assets
          defaultIndex:(NSInteger)defaultIndex;
@end
