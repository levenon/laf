//
//  LFUserInfoCell.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/21.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFUserInfoCell.h"

#import "LFWebImageView.h"

@interface LFUserInfoCell ()<XLFViewConstructor>

@property(nonatomic, strong) LFWebImageView *evimgvPortrait;

@property(nonatomic, strong) UILabel *evlbNickname;

@end

@implementation LFUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self epCreateSubViews];
        [self epConfigSubViewsDefault];
        [self epInstallConstraints];
    }
    return self;
}

+ (CGFloat)epTableView:(UITableView *)tableView heightWithModel:(XLFNormalCellModel *)model{
    
    return [model evHeight];
}

- (void)setEvModel:(LFWebImageCellModel *)evModel{
    
    if (_evModel != evModel) {
        
        _evModel = evModel;
    }
    
    [self epConfigSubViews];
}

- (void)epCreateSubViews{
    
    [self setEvimgvPortrait:[LFWebImageView emptyFrameView]];
    [self setEvlbNickname:[UILabel emptyFrameView]];
    
    [[self contentView] addSubview:[self evimgvPortrait]];
    [[self contentView] addSubview:[self evlbNickname]];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evimgvPortrait] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(20);
        make.top.equalTo(ws.contentView.mas_top).offset(8);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-8);
        make.height.equalTo(ws.evimgvPortrait.mas_width).multipliedBy(1.0);
    }];
    
    [[self evlbNickname] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(ws.contentView.mas_right).offset(-20);
        make.centerY.equalTo(ws.contentView.mas_centerY).offset(0);
    }];
}

- (void)epConfigSubViewsDefault{
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[self evlbNickname] setTextColor:[UIColor colorWithHexRGB:0xB7B8B9]];
    [[self evlbNickname] setFont:[UIFont systemFontOfSize:36/3.]];
}

- (void)epConfigSubViews{
    
    [[self evlbNickname] setText:[[self evModel] evTitle]];
    if ([[self evModel] evTitleColor]) {
        
        [[self evlbNickname] setTextColor:[[self evModel] evTitleColor]];
    }
    else{
        
        [[self evlbNickname] setTextColor:[UIColor grayColor]];
    }
    if ([[self evModel] evTitleFont]) {
        
        [[self evlbNickname] setFont:[[self evModel] evTitleFont]];
    }
    else{
        
        [[self evlbNickname] setFont:[UIFont systemFontOfSize:36/3.]];
    }
    
    if ([[self evModel] evBackgroundColor]) {
        
        [self setBackgroundColor:[[self evModel] evBackgroundColor]];
    }
    if ([[self evModel] evContentColor]) {
        
        [[self contentView] setBackgroundColor:[[self evModel] evContentColor]];
    }
    
    [[self evlbNickname] setNumberOfLines:[[self evModel] evTitleNumberOfLines]];
    
    [[self evlbNickname] setTextAlignment:[[self evModel] evTitleAlignment]];
    
    [self setSelectionStyle:[[self evModel] evSelectionStyle]];
    [self setAccessoryType:[[self evModel] evAccessoryType]];
    
    [[[self evimgvPortrait] layer] setMasksToBounds:YES];
    [[[self evimgvPortrait] layer] setCornerRadius:5];
    
    if ([[self evModel] evTemporaryImage]) {
        
        [[self evimgvPortrait] setImage:[[self evModel] evTemporaryImage]];
    }
    else {
        
        [[self evimgvPortrait] sd_setImageWithURL:[NSURL URLWithString:[[self evModel] evImageUrl]]
                                 placeholderImage:[[self evModel] evPlaceholderImage]];
    }
}

@end