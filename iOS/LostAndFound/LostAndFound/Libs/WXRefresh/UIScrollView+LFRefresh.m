//
//  UIScrollView+LFRefresh.m
//  LFRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "UIScrollView+LFRefresh.h"
#import "LFRefreshHeaderView.h"
#import "LFRefreshFooterView.h"
#import <objc/runtime.h>

@interface UIScrollView()
@property(nonatomic, assign) LFRefreshHeaderView *header;
@property(nonatomic, assign) LFRefreshFooterView *footer;
@end


@implementation UIScrollView (LFRefresh)

#pragma mark - 运行时相关
static char LFRefreshHeaderViewKey;
static char LFRefreshFooterViewKey;

- (void)setHeader:(LFRefreshHeaderView *)header {
    [self willChangeValueForKey:@"LFRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &LFRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LFRefreshHeaderViewKey"];
}

- (LFRefreshHeaderView *)header {
    return objc_getAssociatedObject(self, &LFRefreshHeaderViewKey);
}

- (void)setFooter:(LFRefreshFooterView *)footer {
    [self willChangeValueForKey:@"LFRefreshFooterViewKey"];
    objc_setAssociatedObject(self, &LFRefreshFooterViewKey,
                             footer,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"LFRefreshFooterViewKey"];
}

- (LFRefreshFooterView *)footer {
    return objc_getAssociatedObject(self, &LFRefreshFooterViewKey);
}

#pragma mark - 下拉刷新
/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeaderWithCallback:(void (^)())callback
{
    // 1.创建新的header
    if (!self.header) {
        LFRefreshHeaderView *header = [LFRefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.beginRefreshingCallback = callback;
}

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action
{
    // 1.创建新的header
    if (!self.header) {
        LFRefreshHeaderView *header = [LFRefreshHeaderView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置目标和回调方法
    self.header.beginRefreshingTaget = target;
    self.header.beginRefreshingAction = action;
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader
{
    [self.header removeFromSuperview];
    self.header = nil;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)beginRefresh
{
    [self.header beginRefreshing];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)endRefresh
{
    [self.header endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setHeaderHidden:(BOOL)hidden
{
    self.header.hidden = hidden;
}

- (BOOL)isHeaderHidden
{
    return self.header.isHidden;
}

- (BOOL)isRefreshing
{
    return self.header.state == LFRefreshStateRefreshing;
}

#pragma mark - 上拉刷新
/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param callback 回调
 */
- (void)addFooterWithCallback:(void (^)())callback
{
    // 1.创建新的footer
    if (!self.footer) {
        LFRefreshFooterView *footer = [LFRefreshFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置block回调
    self.footer.beginRefreshingCallback = callback;
}

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action
{
    // 1.创建新的footer
    if (!self.footer) {
        LFRefreshFooterView *footer = [LFRefreshFooterView footer];
        [self addSubview:footer];
        self.footer = footer;
    }
    
    // 2.设置目标和回调方法
    self.footer.beginRefreshingTaget = target;
    self.footer.beginRefreshingAction = action;
}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter
{
    [self.footer removeFromSuperview];
    self.footer = nil;
}

/**
 *  主动让上拉刷新尾部控件进入刷新状态
 */
- (void)beginLoadMore
{
    [self.footer beginRefreshing];
}

/**
 *  让上拉刷新尾部控件停止刷新状态
 */
- (void)endLoadMore
{
    [self.footer endRefreshing];
}

/**
 *  下拉刷新头部控件的可见性
 */
- (void)setFooterHidden:(BOOL)hidden{
    
    self.footer.hidden = hidden;
}

- (BOOL)isFooterHidden{
    
    return self.footer.isHidden;
}

- (BOOL)isLoadingMore{
    
    return self.footer.state == LFRefreshStateRefreshing;
}

/**
 *  文字
 */
- (void)setPullToLoadMoreText:(NSString *)pullToLoadMoreText{
    
    self.footer.pullToRefreshText = pullToLoadMoreText;
}

- (NSString *)pullToLoadMoreText{
    
    return self.footer.pullToRefreshText;
}

- (void)setReleaseToLoadMoreText:(NSString *)releaseToLoadMoreText{
    
    self.footer.releaseToRefreshText = releaseToLoadMoreText;
}

- (NSString *)releaseToLoadMoreText{
    
    return self.footer.releaseToRefreshText;
}

- (void)setLoadingMoreText:(NSString *)loadingMoreText
{
    self.footer.refreshingText = loadingMoreText;
}

- (NSString *)loadingMoreText
{
    return self.footer.refreshingText;
}

- (void)setPullToRefreshText:(NSString *)pullToRefreshText
{
    self.header.pullToRefreshText = pullToRefreshText;
}

- (NSString *)pullToRefreshText
{
    return self.header.pullToRefreshText;
}

- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText
{
    self.header.releaseToRefreshText = releaseToRefreshText;
}

- (NSString *)releaseToRefreshText
{
    return self.header.releaseToRefreshText;
}

- (void)setRefreshingText:(NSString *)refreshingText
{
    self.header.refreshingText = refreshingText;
}

- (NSString *)refreshingText
{
    return self.header.refreshingText;
}

- (void)setRefreshTintIndicatorColor:(UIColor *)refreshTintIndicatorColor{
    
    [[[self header] activityView] setTintColor:refreshTintIndicatorColor];
    [[[self header] activityView] setColor:refreshTintIndicatorColor];
}

- (UIColor *)refreshTintIndicatorColor{
    
    return [[[self header] activityView] color];
}

- (void)setRefreshTintTextColor:(UIColor *)refreshTintTextColor{
    [[[self header] statusLabel] setTextColor:refreshTintTextColor];
}

- (UIColor *)refreshTintTextColor{
    
    return [[[self header] statusLabel] textColor];
}

- (void)setLoadMoreTintIndicatorColor:(UIColor *)loadMoreTintIndicatorColor{
    
    [[[self footer] activityView] setTintColor:loadMoreTintIndicatorColor];
    [[[self footer] activityView] setColor:loadMoreTintIndicatorColor];
}

- (UIColor *)loadMoreTintIndicatorColor{
    
    return [[[self footer] activityView] color];
}

- (void)setLoadMoreTintTextColor:(UIColor *)loadMoreTintTextColor{
    [[[self footer] statusLabel] setTextColor:loadMoreTintTextColor];
}

- (UIColor *)loadMoreTintTextColor{
    
    return [[[self footer] statusLabel] textColor];
}

@end
