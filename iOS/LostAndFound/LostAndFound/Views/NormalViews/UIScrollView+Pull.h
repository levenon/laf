//
//  UIScrollView
//  LostAndFound
//
//  Created by Marike Jave on 14-12-7.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XLFCommonKit/XLFCommonKit.h>

@interface UIMessageInterceptor : NSObject<UIScrollViewDelegate>

@property(nonatomic, strong) id receiver;
@property(nonatomic, strong) id middleMan;

@end

@protocol UIScrollViewPullDelegate <UIScrollViewDelegate>

@optional
- (void)scrollViewWillTriggerRefresh:(UIScrollView *)scrollView;
- (void)scrollViewWillTriggerLoadMore:(UIScrollView *)scrollView;

- (BOOL)scrollViewShouldTriggerRefresh:(UIScrollView *)scrollView;
- (BOOL)scrollViewShouldTriggerLoadMore:(UIScrollView *)scrollView;

- (void)scrollViewDidTriggerRefresh:(UIScrollView *)scrollView;
- (void)scrollViewDidTriggerLoadMore:(UIScrollView *)scrollView;

@end

extern const NSInteger UIScrollViewPullTriggerRefreshHegiht;
extern const NSInteger UIScrollViewPullTriggerLoadMoreHegiht;

@interface UIScrollView(PullScrollView)<UIScrollViewDelegate>

// For intercepting the scrollView delegate messages.
@property(nonatomic, strong, readonly) UIMessageInterceptor* delegateInterceptor;

@property(nonatomic, assign) id<UIScrollViewPullDelegate>  delegate;

@property(nonatomic, assign) BOOL willRefresh;         // Default is NO;
@property(nonatomic, assign) BOOL willLoadMore;        // Default is NO;

@property(nonatomic, assign) BOOL enableRefresh;       // Default is NO;
@property(nonatomic, assign) BOOL enableLoadMore;      // Default is NO;

@property(nonatomic, assign) CGFloat refreshTriggerHeight;    // it can't be 0, if it's 0, will use defatul value, Default is UIScrollViewPullTriggerRefreshHegiht;
@property(nonatomic, assign) CGFloat loadMoreTriggerHeight;   // it can't be 0, if it's 0, will use defatul value, Default is UIScrollViewPullTriggerLoadMoreHegiht;

- (void)triggerRefresh;
- (void)triggerLoadMore;

- (void)endTriggerRefresh;
- (void)endTriggerLoadMore;

@end
