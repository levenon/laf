//
//  LFNoticeSummaryCell.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/29.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNoticeSummaryCell.h"

#import "LFWebImageView.h"

@interface LFNoticeSummaryCell ()

@property(nonatomic, strong) LFWebImageView *evimgvNoticeThumb;

@property(nonatomic, strong) UIImageView *evimgvState;

@property(nonatomic, strong) UILabel *evlbTitle;

@property(nonatomic, strong) UILabel *evlbTime;

@end

@implementation LFNoticeSummaryCell

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
    
    [self setEvimgvNoticeThumb:[LFWebImageView emptyFrameView]];
    [self setEvimgvState:[UIImageView emptyFrameView]];
    [self setEvlbTitle:[UILabel emptyFrameView]];
    [self setEvlbTime:[UILabel emptyFrameView]];
    
    [[self contentView] addSubview:[self evimgvNoticeThumb]];
    [[self contentView] addSubview:[self evlbTitle]];
    [[self contentView] addSubview:[self evlbTime]];
    [[self contentView] addSubview:[self evimgvState]];
}

- (void)epConfigSubViewsDefault{
    
    [[self evimgvNoticeThumb] setImage:[UIImage imageNamed:@"photoDefault"]];
    [[self evimgvState] setImage:[UIImage imageNamed:@"img_notice_closed"]];
    
    [[self evlbTitle] setTextColor:[UIColor colorWithHexRGB:0x333333]];
    [[self evlbTitle] setFont:[UIFont systemFontOfSize:14]];
    [[self evlbTitle] setNumberOfLines:3];
    
    [[self evlbTime] setTextColor:[UIColor lightGrayColor]];
    [[self evlbTime] setFont:[UIFont systemFontOfSize:12]];
    [[self evlbTime] setTextAlignment:NSTextAlignmentRight];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evimgvNoticeThumb] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(8);
        make.top.equalTo(ws.contentView.mas_top).offset(8);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-8);
        
        make.height.equalTo(@80);
        make.width.equalTo(@80);
    }];
    
    [[self evimgvState] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ws.contentView.mas_top).offset(0);
        make.right.equalTo(ws.contentView.mas_right).offset(0);
        
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    [[self evlbTitle] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evimgvNoticeThumb.mas_right).offset(8);
        make.right.lessThanOrEqualTo(ws.evimgvState.mas_left).offset(-8);
        
        make.top.equalTo(ws.contentView.mas_top).offset(12);
    }];
    
    [[self evlbTime] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evimgvNoticeThumb.mas_right).offset(8);
        make.right.equalTo(ws.contentView.mas_right).offset(-8);
        
        make.top.greaterThanOrEqualTo(ws.evlbTitle.mas_bottom).offset(8);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-8);
        
        make.height.equalTo(@14);
    }];
}

- (void)epConfigSubViews{
    
    [[self evimgvNoticeThumb] setFitSizeImageWithURL:[[[self evNotice] image] defaultUrl]
                                    placeholderImage:[UIImage imageNamed:@"photoDefault"]];
    [[self evlbTitle] setText:[[self evNotice] title]];
    [[self evlbTime] setText:[[self evNotice] time]];
    [[self evimgvState] setHidden:[[self evNotice] state] == LFNoticeStateNew];
    
    Weakself(ws);
    [[self evimgvState] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(select([[ws evNotice] state] == LFNoticeStateNew, 0, 50)));
    }];
}

- (void)setEvNotice:(LFNotice *)evNotice{
    
    if (_evNotice != evNotice) {
        
        _evNotice = evNotice;
    }
    
    [self epConfigSubViews];
}

@end
