//
//  LFCommonImageCell.m
//  LostAndFound
//
//  Created by Marike Jave on 16/2/21.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFCommonImageCell.h"

#import "LFWebImageView.h"

@interface LFCommonImageCell ()<XLFViewInterface>

@property(nonatomic, strong) LFWebImageView *evimgThumb;

@property(nonatomic, strong) UILabel *evlbTitle;

@property(nonatomic, strong) UIView *evvContentBackground;

@end

@implementation LFCommonImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self epCreateSubViews];
        [self epConfigSubViewsDefault];
        [self epInstallConstraints];
    }
    return self;
}

- (void)epCreateSubViews{
    
    [self setEvimgThumb:[LFWebImageView emptyFrameView]];
    [self setEvvContentBackground:[UIView emptyFrameView]];
    [self setEvlbTitle:[UILabel emptyFrameView]];
    
    [[self contentView] addSubview:[self evimgThumb]];
    [[self contentView] addSubview:[self evvContentBackground]];
    [[self contentView] addSubview:[self evlbTitle]];
}

- (void)epConfigSubViewsDefault{
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [[self evvContentBackground] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    
    [[self evlbTitle] setTextColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [[self evlbTitle] setFont:[UIFont boldSystemFontOfSize:14]];
    
    [[self evimgThumb] setEnableCut:YES];
    [[self evimgThumb] setImage:[UIImage imageNamed:@"photoDefault"]];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    [[self evimgThumb] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.contentView).insets(UIEdgeInsetsMake(0, 0, 2, 0));
        make.height.equalTo(@(SCREEN_WIDTH * 0.7));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [[self evvContentBackground] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(0);
        make.right.equalTo(ws.contentView.mas_right).offset(0);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-2);
    }];
    
    [[self evlbTitle] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(8);
        make.right.equalTo(ws.contentView.mas_right).offset(-8);
        make.top.equalTo(ws.evvContentBackground.mas_top).offset(8);
        make.bottom.equalTo(ws.evvContentBackground.mas_bottom).offset(-8);
        make.height.greaterThanOrEqualTo(@20);
    }];
}

- (void)epConfigSubViews{
    
    [[self evlbTitle] setText:[[self evImage] title]];
    
    [[self evimgThumb] setFitSizeImageWithURL:[[self evImage] defaultUrl]
                             placeholderImage:[UIImage imageNamed:@"photoDefault"]];
}

#pragma mark - accessory

- (void)setEvImage:(LFImage *)evImage{
    
    if (_evImage != evImage) {
        
        _evImage = evImage;
    }
    
    [self epConfigSubViews];
}

@end
