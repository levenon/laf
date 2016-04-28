//
//  LFRefreshHeaderView.m
//  LFRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "LFRefreshConst.h"
#import "LFRefreshHeaderView.h"
#import "UIScrollView+LFExtension.h"

@interface LFRefreshHeaderView()
// 最后的更新时间
@property(nonatomic, strong) NSDate *lastUpdateTime;
@property(nonatomic, assign) UILabel *lastUpdateTimeLabel;
@end

@implementation LFRefreshHeaderView
#pragma mark - 控件初始化
/**
 *  时间标签
 */
- (UILabel *)lastUpdateTimeLabel
{
    if (!_lastUpdateTimeLabel) {
        // 1.创建控件
        UILabel *lastUpdateTimeLabel = [[UILabel alloc] init];
        lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastUpdateTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        lastUpdateTimeLabel.textColor = LFRefreshLabelTextColor;
        lastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
        lastUpdateTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdateTimeLabel = lastUpdateTimeLabel];
        
        // 2.加载时间
        self.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:LFRefreshHeaderTimeKey];
    }
    return _lastUpdateTimeLabel;
}

+ (instancetype)header
{
    return [[LFRefreshHeaderView alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pullToRefreshText = LFRefreshHeaderPullToRefresh;
        self.releaseToRefreshText = LFRefreshHeaderReleaseToRefresh;
        self.refreshingText = LFRefreshHeaderRefreshing;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat statusX = 0;
    CGFloat statusY = 0;
    CGFloat statusHeight = self.height * 0.5;
    CGFloat statusWidth = self.width;
    // 1.状态标签
    self.statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    // 2.时间标签
    CGFloat lastUpdateY = statusHeight;
    CGFloat lastUpdateX = 0;
    CGFloat lastUpdateHeight = statusHeight;
    CGFloat lastUpdateWidth = statusWidth;
    self.lastUpdateTimeLabel.frame = CGRectMake(lastUpdateX, lastUpdateY, lastUpdateWidth, lastUpdateHeight);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 设置自己的位置和尺寸
    self.top = - self.height;
}

#pragma mark - 状态相关
#pragma mark 设置最后的更新时间
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    // 1.归档
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:LFRefreshHeaderTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 2.更新时间
    [self updateTimeLabel];
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel
{
    if (!self.lastUpdateTime) return;
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:self.lastUpdateTime];
    
    // 3.显示日期
    self.lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}

#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;

    // 如果正在刷新，直接返回
    if (self.state == LFRefreshStateRefreshing) return;

    if ([LFRefreshContentOffset isEqualToString:keyPath]) {
        [self adjustStateWithContentOffset];
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    if ([self state] == LFRefreshStateNormal && ![self contentHide]) {
        [self setContentHide:YES];
    }
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mj_contentOffsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (currentOffsetY >= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        // 普通 和 即将刷新 的临界点
        CGFloat normalPullingOffsetY = happenOffsetY - self.height;
        
        if (self.state == LFRefreshStateNormal && currentOffsetY < normalPullingOffsetY) {
            // 转为即将刷新状态
            self.state = LFRefreshStatePulling;
        } else if (self.state == LFRefreshStatePulling && currentOffsetY >= normalPullingOffsetY) {
            // 转为普通状态
            self.state = LFRefreshStateNormal;
        }
        else{
            [self setContentHide:NO];
        }
    } else if (self.state == LFRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        self.state = LFRefreshStateRefreshing;
    }
    else{
        
        [self setContentHide:YES];
    }
}

- (void)setContentHide:(BOOL)hide;{
    
    [[self arrowImage] setAlpha:!hide];
    [[self statusLabel] setAlpha:!hide];
    [[self lastUpdateTimeLabel] setAlpha:!hide];
}

- (BOOL)contentHide{
    
    return !([[self arrowImage] alpha] || [[self statusLabel] alpha] || [[self lastUpdateTimeLabel] alpha]);
}

#pragma mark 设置状态
- (void)setState:(LFRefreshState)state
{
    // 1.一样的就直接返回
    if (self.state == state) return;
    
    // 2.保存旧状态
    LFRefreshState oldState = self.state;
    
    // 3.调用父类方法
    [super setState:state];
    
    // 4.根据状态执行不同的操作
	switch (state) {
		case LFRefreshStateNormal: // 下拉可以刷新
        {
            // 刷新完毕
            if (LFRefreshStateRefreshing == oldState) {
                self.arrowImage.transform = CGAffineTransformIdentity;
                // 保存刷新时间
                self.lastUpdateTime = [NSDate date];
                
                [UIView animateWithDuration:LFRefreshSlowAnimationDuration animations:^{

                    if ([self superview]) {
                        self.scrollView.mj_contentInsetTop -= self.height;
                        [self setContentHide:YES];
                    }
                    
                }];
            } else {
                // 执行动画
                
                [UIView animateWithDuration:LFRefreshFastAnimationDuration animations:^{
                    
                    self.arrowImage.transform = CGAffineTransformIdentity;
                    [self setContentHide:YES];
                }];
            }
			break;
        }
            
		case LFRefreshStatePulling: // 松开可立即刷新
        {
            [self setContentHide:NO];
            // 执行动画
            [UIView animateWithDuration:LFRefreshFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
            }];
			break;
        }
            
		case LFRefreshStateRefreshing: // 正在刷新中
        {
            [self setContentHide:NO];
            // 执行动画
            [UIView animateWithDuration:LFRefreshFastAnimationDuration animations:^{
                // 1.增加滚动区域
                CGFloat top = self.scrollViewOriginalInset.top + self.height;
                self.scrollView.mj_contentInsetTop = top;
                
                // 2.设置滚动位置
                self.scrollView.mj_contentOffsetY = - top;
            }];
			break;
        }
            
        default:
            break;
	}
}
@end