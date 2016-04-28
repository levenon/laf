//
//  LFImageView.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/19.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFImageView.h"
#import "LFWebImageView.h"

@interface LFImageView ()<XLFViewInterface>

@property(nonatomic, strong) LFWebImageView *evimgvContent;

@property(nonatomic, strong) UIView *evvTextBackground;

@property(nonatomic, strong) UILabel *evlbDescription;

@end

@implementation LFImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self epCreateSubViews];
        [self epConfigSubViewsDefault];
        [self epInstallConstraints];
    }
    return self;
}

- (void)epCreateSubViews{
    
    [self setEvimgvContent:[LFWebImageView emptyFrameView]];
    [self setEvlbDescription:[UILabel emptyFrameView]];
    [self setEvvTextBackground:[UIView emptyFrameView]];
    
    [self addSubview:[self evimgvContent]];
    [self addSubview:[self evvTextBackground]];
    [self addSubview:[self evlbDescription]];
}

- (void)epConfigSubViewsDefault{
    
    [[self evimgvContent] setEvShowProgress:YES];
    [[self evimgvContent] setImage:[UIImage imageNamed:@"photoDefault"]];
    
    [[self evvTextBackground] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    
    [[self evlbDescription] setTextColor:[UIColor colorWithWhite:0.7 alpha:1]];
    [[self evlbDescription] setFont:[UIFont systemFontOfSize:14]];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evimgvContent] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws).insets(UIEdgeInsetsZero);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_WIDTH * 0.6));
    }];
    
    [[self evvTextBackground] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(0);
        make.right.equalTo(ws.mas_right).offset(0);
        make.bottom.equalTo(ws.mas_bottom).offset(0);
    }];
    
    [[self evlbDescription] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.evvTextBackground.mas_top).offset(8);
        make.bottom.equalTo(ws.evvTextBackground.mas_bottom).offset(-8);
        
        make.left.equalTo(ws.evvTextBackground.mas_left).offset(8);
        make.right.equalTo(ws.evvTextBackground.mas_right).offset(-8);
    }];
}

- (void)epConfigSubViews{
    
    [[self evimgvContent] setFitSizeImageWithURL:[[self evImage] defaultUrl]
                                placeholderImage:[UIImage imageNamed:@"photoDefault"]];
    [[self evlbDescription] setText:[[self evImage] title]];
    
    [[self evvTextBackground] setHidden:![[[self evImage] title] length]];
}

- (void)setEvImage:(LFImage *)evImage{
    
    if (_evImage != evImage) {
        
        _evImage = evImage;
    }
    
    [self epConfigSubViews];
}

- (UIImage *)image{
    
    return [[self evimgvContent] image];
}

- (void)setImage:(UIImage *)image{
    
    [[self evimgvContent] setImage:image];
}

@end
