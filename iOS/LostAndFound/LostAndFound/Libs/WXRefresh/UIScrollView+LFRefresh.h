//
//  UIScrollView+LFRefresh.h
//  LFRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface UIScrollView (LFRefresh)

#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback;

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)beginRefresh;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)endRefresh;

/**
 *  下拉刷新头部控件的可见性
 */
@property(nonatomic, assign, getter = isHeaderHidden) BOOL headerHidden;

/**
 *  是否正在下拉刷新
 */
@property(nonatomic, assign, readonly, getter = isRefreshing) BOOL refreshing;

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback;

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action;

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter;

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)beginLoadMore;

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)endLoadMore;

/**
 *  上拉刷新头部控件的可见性
 */
@property(nonatomic, assign, getter = isFooterHidden) BOOL footerHidden;

/**
 *  是否正在上拉刷新
 */
@property(nonatomic, assign, readonly, getter = isLoadingMore) BOOL loadingMore;

/**
 *  设置尾部控件的文字
 */
@property(nonatomic, strong) UIColor *loadMoreTintIndicatorColor;
@property(nonatomic, strong) UIColor *loadMoreTintTextColor;

@property(copy, nonatomic) NSString *pullToLoadMoreText; // 默认:@"上拉可以加载更多数据"
@property(copy, nonatomic) NSString *releaseToLoadMoreText; // 默认:@"松开立即加载更多数据"
@property(copy, nonatomic) NSString *loadingMoreText; // 默认:@"MJ哥正在帮你加载数据..."

/**
 *  设置头部控件的文字
 */
@property(nonatomic, strong) UIColor *refreshTintIndicatorColor;
@property(nonatomic, strong) UIColor *refreshTintTextColor;

@property(copy, nonatomic) NSString *pullToRefreshText; // 默认:@"下拉可以刷新"
@property(copy, nonatomic) NSString *releaseToRefreshText; // 默认:@"松开立即刷新"
@property(copy, nonatomic) NSString *refreshingText; // 默认:@"MJ哥正在帮你刷新..."
@end
