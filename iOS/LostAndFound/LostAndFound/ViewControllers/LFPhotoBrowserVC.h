//
//  LFPhotoBrowserVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/22.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

#import "LFImage.h"

#import "LFWebImageView.h"

@interface LFPhotoContentView : UIScrollView<XLFViewConstructor, UIScrollViewDelegate>

@property(nonatomic, strong) LFImage *evImage;

@property(nonatomic, strong) UIView *evvContent;

@property(nonatomic, strong) LFWebImageView *evimgvContent;

@end

@class LFPhotoBrowserVC;

@protocol LFPhotoBrowserDelegate <NSObject>

@optional
- (void)epPhotoBrowserVC:(LFPhotoBrowserVC *)photoBrowserVC didSelectedIndex:(NSInteger)selectedIndex;

@end

@interface LFPhotoBrowserVC : LFBaseViewController

@property(nonatomic, assign, readonly) id<LFPhotoBrowserDelegate> evDelegate;

@property(nonatomic, assign, readonly) NSInteger evCurrentIndex;

@property(nonatomic, strong, readonly) NSArray<LFImage *> *evPhotos;

- (id)initWithDelegate:(id<LFPhotoBrowserDelegate>)delegate
                photos:(NSArray<LFImage *> *)photos
          defaultIndex:(NSInteger)defaultIndex;

@end
