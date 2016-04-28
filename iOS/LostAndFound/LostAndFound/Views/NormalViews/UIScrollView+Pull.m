//
//  UIScrollView
//  LostAndFound
//
//  Created by Marike Jave on 14-12-7.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "UIScrollView+Pull.h"
#import <objc/runtime.h>

const NSInteger UIScrollViewPullTriggerRefreshHegiht = 60.f;
const NSInteger UIScrollViewPullTriggerLoadMoreHegiht = 60.f;

@implementation UIMessageInterceptor : NSObject

- (void)dealloc{

    [self setReceiver:nil];
    [self setMiddleMan:nil];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {

    if ([[self middleMan] respondsToSelector:aSelector]) { return [self middleMan]; }
    if ([[self receiver] respondsToSelector:aSelector]) { return [self receiver]; }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {

    if ([[self middleMan] respondsToSelector:aSelector]) { return YES; }
    if ([[self receiver] respondsToSelector:aSelector]) { return YES; }
    return [super respondsToSelector:aSelector];
}

@end

@interface UIScrollView(PullScrollView_Private)

// For intercepting the scrollView delegate messages.
@property(nonatomic, strong) UIMessageInterceptor* delegateInterceptor;

@end

@implementation UIScrollView(PullScrollView)

#pragma mark - property

- (UIMessageInterceptor *)delegateInterceptor {
    return (UIMessageInterceptor *)objc_getAssociatedObject(self, @selector(delegateInterceptor));
}

- (void)setDelegateInterceptor:(UIMessageInterceptor *)delegateInterceptor {

    [delegateInterceptor setMiddleMan:self];
    if (![[self delegate] isKindOfClass:[UIMessageInterceptor class]]) {
        [delegateInterceptor setReceiver:[self delegate]];
    }

    objc_setAssociatedObject(self, @selector(delegateInterceptor), delegateInterceptor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)willRefresh{

    return [objc_getAssociatedObject(self,@selector(willRefresh)) boolValue];
}

- (void)setWillRefresh:(BOOL)willRefresh{

    objc_setAssociatedObject(self, @selector(willRefresh), [NSNumber numberWithBool:willRefresh], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)willLoadMore{

    return [objc_getAssociatedObject(self,@selector(willLoadMore)) boolValue];
}

- (void)setWillLoadMore:(BOOL)willLoadMore{

    objc_setAssociatedObject(self, @selector(willLoadMore), [NSNumber numberWithBool:willLoadMore], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enableRefresh{

    return [objc_getAssociatedObject(self,@selector(enableRefresh)) boolValue];
}

- (void)setEnableRefresh:(BOOL)enableRefresh{

    if ([self enableRefresh] != enableRefresh) {

        if (enableRefresh && ![self delegateInterceptor]) {

            [self registerDelegateInterceptor];
        }
        else if (!enableRefresh && [self delegateInterceptor] && [self enableLoadMore]){

            [self removeDelegateInterceptor];
        }

        objc_setAssociatedObject(self, @selector(enableRefresh), [NSNumber numberWithBool:enableRefresh], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BOOL)enableLoadMore{

    return [objc_getAssociatedObject(self,@selector(enableLoadMore)) boolValue];
}

- (void)setEnableLoadMore:(BOOL)enableLoadMore{

    if ([self enableLoadMore] != enableLoadMore) {

        if (enableLoadMore && ![self delegateInterceptor]) {
            [self registerDelegateInterceptor];
        }
        else if (!enableLoadMore && [self delegateInterceptor] && [self enableRefresh]){
            [self removeDelegateInterceptor];
        }
        objc_setAssociatedObject(self, @selector(enableLoadMore), [NSNumber numberWithBool:enableLoadMore], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setRefreshTriggerHeight:(CGFloat)refreshTriggerHeight{

    objc_setAssociatedObject(self, @selector(refreshTriggerHeight), [NSNumber numberWithFloat:refreshTriggerHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)refreshTriggerHeight{

    CGFloat refreshTriggerHeight = [objc_getAssociatedObject(self,@selector(refreshTriggerHeight)) floatValue];

    return refreshTriggerHeight ? refreshTriggerHeight : UIScrollViewPullTriggerRefreshHegiht;
}

- (void)setLoadMoreTriggerHeight:(CGFloat)loadMoreTriggerHeight{

    objc_setAssociatedObject(self, @selector(loadMoreTriggerHeight), [NSNumber numberWithFloat:loadMoreTriggerHeight], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)loadMoreTriggerHeight{

    CGFloat loadMoreTriggerHeight = [objc_getAssociatedObject(self,@selector(loadMoreTriggerHeight)) floatValue];

    return loadMoreTriggerHeight ? loadMoreTriggerHeight : UIScrollViewPullTriggerLoadMoreHegiht;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"delegate"] && ![object isKindOfClass:[UIMessageInterceptor class]] && [self delegateInterceptor]) {

        [[self delegateInterceptor] setReceiver:object];
        [self setDelegate:(id)[self delegateInterceptor]];
    }
}

- (void)registerDelegateInterceptor{

    [self setDelegateInterceptor:[[UIMessageInterceptor alloc] init]];
    [self setDelegate:(id)[self delegateInterceptor]];
    [self addObserver:self forKeyPath:@"delegate" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeDelegateInterceptor{

    [self removeObserver:self forKeyPath:@"delegate"];
    [self setDelegate:[[self delegateInterceptor] receiver]];
    [self setDelegateInterceptor:nil];
}

- (CGSize)scrollOffsetArea{

    CGSize size = {0,0};
    if (CGRectGetHeight([self bounds]) >= [self contentSize].height) {
        size.height = 0;
    }
    else{
        size.height = [self contentSize].height - CGRectGetHeight([self bounds]) + [self contentInset].top;
    }

    if (CGRectGetWidth([self bounds]) >= [self contentSize].width) {
        size.width = 0;
    }
    else{
        size.width = [self contentSize].width - CGRectGetWidth([self bounds]) + [self contentInset].left;
    }
    return size;
}

- (void)triggerRefresh;{

    if ([self enableRefresh]){

        [self setContentOffset:CGPointMake([self contentOffset].x, -[self refreshTriggerHeight] - [self contentInset].top) animated:YES];

        [self performSelector:@selector(endPullDown) withObject:nil afterDelay:0.3];
//
//        [UIView animateWithDuration:0.3 animations:^{
//
//            [self setContentOffset:CGPointMake([self contentOffset].x, -[self refreshTriggerHeight] - [self contentInset].top) animated:NO];
//
//        } completion:^(BOOL finished) {
//
//            [self endTriggerRefresh];
//        }];
    }
}

- (void)endPullDown;{

    [self setContentOffset:CGPointMake([self contentOffset].x, - [self contentInset].top) animated:YES];

    [self performSelector:@selector(endTriggerRefresh) withObject:nil afterDelay:0.3];
}

- (void)endTriggerRefresh{

    BOOL shouldRefresh = YES;
    if ([[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewShouldTriggerRefresh:)]) {

        shouldRefresh = [[[self delegateInterceptor] receiver] scrollViewShouldTriggerRefresh:self];
    }

    if (shouldRefresh && [[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewDidTriggerRefresh:)]) {

        [[[self delegateInterceptor] receiver] scrollViewDidTriggerRefresh:self];
    }
    NIF_INFO(@"%@",[self description]);
    NIF_INFO(@"UIScrollView did trigger refrsh");
}

- (void)triggerLoadMore;{

    if ([self enableLoadMore]){

        [self setContentOffset:CGPointMake([self contentOffset].x, [self scrollOffsetArea].height + [self loadMoreTriggerHeight]) animated:YES];
        
        [self performSelector:@selector(endPullUp) withObject:nil afterDelay:0.3];
//
//        [UIView animateWithDuration:0.3 animations:^{
//
//            [self setContentOffset:CGPointMake([self contentOffset].x, [self scrollOffsetArea].height + [self loadMoreTriggerHeight]) animated:NO];
//
//        } completion:^(BOOL finished) {
//
//            [self endTriggerLoadMore];
//        }];
    }
}

- (void)endPullUp;{

    [self performSelector:@selector(endTriggerLoadMore) withObject:nil afterDelay:0.3];
}

- (void)endTriggerLoadMore{

    [self setContentOffset:CGPointMake([self contentOffset].x, [self scrollOffsetArea].height) animated:YES];

    BOOL shouldLoadMore = YES;
    if ([[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewShouldTriggerLoadMore:)]) {

        shouldLoadMore = [[[self delegateInterceptor] receiver] scrollViewShouldTriggerLoadMore:self];
    }
    if (shouldLoadMore && [[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewDidTriggerLoadMore:)]) {

        [[[self delegateInterceptor] receiver] scrollViewDidTriggerLoadMore:self];
    }
    NIF_INFO(@"%@",[self description]);
    NIF_INFO(@"UIScrollView trigger load more");
}

- (NSString*)description{

    return [[super description] stringByAppendingFormat:@"\ncontentSize:%@ \ncontentOffset:%@ \ncontentInset:%@",[NSValue valueWithCGSize:[self contentSize]],[NSValue valueWithCGPoint:[self contentOffset]],[NSValue valueWithUIEdgeInsets:[self contentInset]]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if ([scrollView isDragging]) {

        [self setWillRefresh:YES];
        [self setWillLoadMore:YES];
    }
    if ([self willRefresh] && [self enableRefresh] && [scrollView contentOffset].y + [self contentInset].top < -[self refreshTriggerHeight]) {

        if ([[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewWillTriggerRefresh:)]) {

            [[[self delegateInterceptor] receiver] scrollViewWillTriggerRefresh:scrollView];
        }
        NIF_INFO(@"%@",[scrollView description]);
        NIF_INFO(@"UIScrollView will trigger refrsh");
    }
    if ([self willLoadMore] && [self enableLoadMore] && [scrollView contentOffset].y - [self scrollOffsetArea].height > [self loadMoreTriggerHeight]) {

        if ([[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewWillTriggerLoadMore:)]) {

            [[[self delegateInterceptor] receiver] scrollViewWillTriggerLoadMore:scrollView];
        }
        NIF_INFO(@"%@",[scrollView description]);
        NIF_INFO(@"UIScrollView will trigger laod more");
    }

    if ([self willRefresh] && ![scrollView isDragging]) {

        [scrollView scrollViewTrigger:scrollView];

        [self setWillRefresh:NO];
        [self setWillLoadMore:NO];
    }

    // Also forward the message to the real delegate
    if ([[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewDidScroll:)]) {

        [[[self delegateInterceptor] receiver] scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewTrigger:(UIScrollView*)scrollView;{

    if ([self enableRefresh] && [scrollView contentOffset].y + [self contentInset].top < -[self refreshTriggerHeight]) {

        BOOL shouldRefresh = YES;
        if ([[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewShouldTriggerRefresh:)]) {

            shouldRefresh = [[[self delegateInterceptor] receiver] scrollViewShouldTriggerRefresh:scrollView];
        }

        if (shouldRefresh && [[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewDidTriggerRefresh:)]) {

            [[[self delegateInterceptor] receiver] scrollViewDidTriggerRefresh:scrollView];
        }
        NIF_INFO(@"%@",[scrollView description]);
        NIF_INFO(@"UIScrollView did trigger refrsh");
    }
    if ([self enableLoadMore] && [scrollView contentOffset].y - [self scrollOffsetArea].height > [self loadMoreTriggerHeight]) {

        BOOL shouldLoadMore = YES;
        if ([[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewShouldTriggerLoadMore:)]) {

            shouldLoadMore = [[[self delegateInterceptor] receiver] scrollViewShouldTriggerLoadMore:scrollView];
        }
        if (shouldLoadMore && [[[self delegateInterceptor] receiver] respondsToSelector:@selector(scrollViewDidTriggerLoadMore:)]) {

            [[[self delegateInterceptor] receiver] scrollViewDidTriggerLoadMore:scrollView];
        }
        NIF_INFO(@"%@",[scrollView description]);
        NIF_INFO(@"UIScrollView trigger load more");
    }
}

@end
