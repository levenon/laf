//
//  LFRefreshConst.h
//  LFRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

//#ifdef DEBUG
#define MJLog(...) NIF_DEBUG(__VA_ARGS__)
//#else
//#define MJLog(...) 
//#endif

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)


#define MJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define LFRefreshLabelTextColor MJColor(150, 150, 150)

extern const CGFloat LFRefreshViewHeight;
extern const CGFloat LFRefreshFastAnimationDuration;
extern const CGFloat LFRefreshSlowAnimationDuration;

extern NSString *const LFRefreshBundleName;
#define LFRefreshSrcName(file) [LFRefreshBundleName stringByAppendingPathComponent:file]

extern NSString *const LFRefreshFooterPullToRefresh;
extern NSString *const LFRefreshFooterReleaseToRefresh;
extern NSString *const LFRefreshFooterRefreshing;

extern NSString *const LFRefreshHeaderPullToRefresh;
extern NSString *const LFRefreshHeaderReleaseToRefresh;
extern NSString *const LFRefreshHeaderRefreshing;
extern NSString *const LFRefreshHeaderTimeKey;

extern NSString *const LFRefreshContentOffset;
extern NSString *const LFRefreshContentSize;


@interface UIView(LFExtension)

@property(nonatomic , assign) CGPoint origin;
@property(nonatomic , assign) CGFloat left;
@property(nonatomic , assign) CGFloat top;
@property(nonatomic , assign , readonly) CGPoint termination;
@property(nonatomic , assign , readonly) CGFloat right;  // right
@property(nonatomic , assign , readonly) CGFloat bottom;  // bottom
@property(nonatomic , assign) CGSize  size;
@property(nonatomic , assign) CGFloat width;
@property(nonatomic , assign) CGFloat height;

@end

