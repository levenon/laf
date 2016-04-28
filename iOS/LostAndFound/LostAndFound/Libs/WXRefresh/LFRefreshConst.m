//
//  LFRefreshConst.m
//  LFRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com


#import "LFRefreshConst.h"

const CGFloat LFRefreshViewHeight = 64.0;
const CGFloat LFRefreshFastAnimationDuration = 0.25;
const CGFloat LFRefreshSlowAnimationDuration = 0.4;

NSString *const LFRefreshBundleName = @"LFRefresh.bundle";

NSString *const LFRefreshFooterPullToRefresh = @"上拉可以加载更多";
NSString *const LFRefreshFooterReleaseToRefresh = @"松开马上加载更多";
NSString *const LFRefreshFooterRefreshing = @"正在加载";

NSString *const LFRefreshHeaderPullToRefresh = @"下拉可以刷新";
NSString *const LFRefreshHeaderReleaseToRefresh = @"松开立即刷新";
NSString *const LFRefreshHeaderRefreshing = @"正在刷新";
NSString *const LFRefreshHeaderTimeKey = @"LFRefreshHeaderView";

NSString *const LFRefreshContentOffset = @"contentOffset";
NSString *const LFRefreshContentSize = @"contentSize";

@implementation UIView(LFExtension)

- (void)setOrigin:(CGPoint)origin{
    
    CGRect frame = [self frame];
    
    frame.origin = origin;
    
    [self setFrame:frame];
}

- (CGPoint)origin{
    
    return [self frame].origin;
}

- (void)setSize:(CGSize)size{
    
    CGRect frame = [self frame];
    
    frame.size = size;
    
    [self setFrame:frame];
}

- (CGSize)size{
    
    return [self frame].size;
}

- (void)setLeft:(CGFloat)left{
    
    CGRect frame = [self frame];
    
    frame.origin.x = left;
    
    [self setFrame:frame];
}

- (CGFloat)left{
    
    return [self frame].origin.x;
}

- (void)setTop:(CGFloat)top{
    
    CGRect frame = [self frame];
    
    frame.origin.y = top;
    
    [self setFrame:frame];
}

- (CGFloat)top{
    
    return [self frame].origin.y;
}

- (CGPoint)termination{
    
    return CGPointMake([self right], [self bottom]);
}

- (CGFloat)right{
    
    return [self left] + [self width];
}

- (CGFloat)bottom{
    
    return [self top] + [self height];
}

- (void)setWidth:(CGFloat)width{
    
    CGRect frame = [self frame];
    
    frame.size.width = width;
    
    [self setFrame:frame];
}

- (CGFloat)width{
    
    return [self frame].size.width;
}

- (void)setHeight:(CGFloat)height{
    
    CGRect frame = [self frame];
    
    frame.size.height = height;
    
    [self setFrame:frame];
}

- (CGFloat)height{
    
    return [self bounds].size.height;
}
@end
