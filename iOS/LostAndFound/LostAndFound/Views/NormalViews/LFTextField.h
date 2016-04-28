//
//  LFTextField.h
//  LostAndFound
//
//  Created by Marike Jave on 14-12-19.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

@interface LFTextField : XLFLimitTextField

@property(nonatomic, strong) UIColor *evNormalBorderColor;
@property(nonatomic, strong) UIColor *evDisableBorderColor;
@property(nonatomic, strong) UIColor *evHighlightedBorderColor;

@property(nonatomic, strong) UIColor *evNormalTextColor;
@property(nonatomic, strong) UIColor *evHighlightedTextColor;

@property(nonatomic, strong) UIColor *evNormalPlaceholderColor;
@property(nonatomic, strong) UIColor *evHighlightedPlaceholderColor;

@property(nonatomic, strong) UIImage *evimgNormalLeft;
@property(nonatomic, strong) UIImage *evimgHightlightedLeft;
@property(nonatomic, strong) UIImage *evimgNormalRight;
@property(nonatomic, strong) UIImage *evimgHightlightedRight;

- (void)setNeedsDefaultStyle;
- (void)setNeedsBorder;

@end