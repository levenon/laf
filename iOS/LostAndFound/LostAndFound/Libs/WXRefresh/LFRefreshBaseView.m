//
//  LFRefreshBaseView.m
//  LFRefresh
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LFRefreshConst.h"

#import "LFRefreshBaseView.h"
#import "UIScrollView+LFExtension.h"
#import <objc/message.h>

@interface  LFRefreshBaseView()
{
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIActivityIndicatorView *_activityView;
}
@end

@implementation LFRefreshBaseView
#pragma mark - 控件初始化
/**
 *  状态标签
 */
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = LFRefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}

/**
 *  箭头图片
 */
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LFRefreshSrcName(@"arrow.png")]];
        arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

/**
 *  状态标签
 */
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        activityView.autoresizingMask = self.arrowImage.autoresizingMask;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = LFRefreshViewHeight;
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.设置默认状态
        self.state = LFRefreshStateNormal;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.箭头
    CGFloat arrowX = self.width * 0.5 - 100;
    self.arrowImage.center = CGPointMake(arrowX, self.height * 0.5);
    
    // 2.指示器
    self.activityView.center = self.arrowImage.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:LFRefreshContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:LFRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.width = newSuperview.width;
        // 设置位置
        self.left = 0;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

#pragma mark - 显示到屏幕上
- (void)drawRect:(CGRect)rect
{
    if (self.state == LFRefreshStateWillRefreshing) {
        self.state = LFRefreshStateRefreshing;
    }
}

#pragma mark - 刷新相关
#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return LFRefreshStateRefreshing == self.state;
}

#pragma mark 开始刷新
typedef void (*send_type)(void *, SEL, UIView *);

- (void)beginRefreshing
{
    if (self.state == LFRefreshStateRefreshing) {
        // 回调
        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
            msgSend((__bridge void *)(self.beginRefreshingTaget), self.beginRefreshingAction, self);
        }
        
        if (self.beginRefreshingCallback) {
            self.beginRefreshingCallback();
        }
    } else {
        if (self.window) {
            self.state = LFRefreshStateRefreshing;
        } else {
//#warning can not call setter
            _state = LFRefreshStateWillRefreshing;
            [super setNeedsDisplay];
        }
    }
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = LFRefreshStateNormal;
    });
}

#pragma mark - 设置状态
- (void)setPullToRefreshText:(NSString *)pullToRefreshText
{
    _pullToRefreshText = [pullToRefreshText copy];
    [self settingLabelText];
}
- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText
{
    _releaseToRefreshText = [releaseToRefreshText copy];
    [self settingLabelText];
}
- (void)setRefreshingText:(NSString *)refreshingText
{
    _refreshingText = [refreshingText copy];
    [self settingLabelText];
}
- (void)settingLabelText
{
	switch (self.state) {
		case LFRefreshStateNormal:
            // 设置文字
            self.statusLabel.text = self.pullToRefreshText;
			break;
		case LFRefreshStatePulling:
            // 设置文字
            self.statusLabel.text = self.releaseToRefreshText;
			break;
        case LFRefreshStateRefreshing:
            // 设置文字
            self.statusLabel.text = self.refreshingText;
			break;
        default:
            break;
	}
}

- (void)setState:(LFRefreshState)state
{
    // 0.存储当前的contentInset
    if (self.state != LFRefreshStateRefreshing && [self superview]) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    // 1.一样的就直接返回(暂时不返回)
    if (self.state == state) return;
    
    // 2.根据状态执行不同的操作
    switch (state) {
		case LFRefreshStateNormal: // 普通状态
        {
            if (self.state == LFRefreshStateRefreshing) {
                [UIView animateWithDuration:LFRefreshSlowAnimationDuration * 0.6 animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 停止转圈圈
                    [self.activityView stopAnimating];
                    
                    // 恢复alpha
                    self.activityView.alpha = 1.0;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LFRefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 再次设置回normal
                    _state = LFRefreshStatePulling;
                    self.state = LFRefreshStateNormal;
                });
                // 直接返回
                return;
            } else {
                // 显示箭头
                self.arrowImage.hidden = NO;
                
                // 停止转圈圈
                [self.activityView stopAnimating];
            }
			break;
        }
            
        case LFRefreshStatePulling:
            break;
            
		case LFRefreshStateRefreshing:
        {
            // 开始转圈圈
			[self.activityView startAnimating];
            // 隐藏箭头
			self.arrowImage.hidden = YES;
            
            // 回调
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                
                SuppressPerformSelectorLeakWarning(
                    [[self beginRefreshingTaget] performSelector:self.beginRefreshingAction withObject:self];
                );
//                objc_msgSend(self.beginRefreshingTaget, self.beginRefreshingAction, self);
            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
			break;
        }
        default:
            break;
	}
    
    // 3.存储状态
    _state = state;
    
    // 4.设置文字
    [self settingLabelText];
}
@end