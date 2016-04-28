//
//  UIScrollView+Extension.h
//  LFRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@interface UIScrollView (LFExtension)
@property(nonatomic, assign) CGFloat mj_contentInsetTop;
@property(nonatomic, assign) CGFloat mj_contentInsetBottom;
@property(nonatomic, assign) CGFloat mj_contentInsetLeft;
@property(nonatomic, assign) CGFloat mj_contentInsetRight;

@property(nonatomic, assign) CGFloat mj_contentOffsetX;
@property(nonatomic, assign) CGFloat mj_contentOffsetY;

@property(nonatomic, assign) CGFloat mj_contentSizeWidth;
@property(nonatomic, assign) CGFloat mj_contentSizeHeight;
@end
