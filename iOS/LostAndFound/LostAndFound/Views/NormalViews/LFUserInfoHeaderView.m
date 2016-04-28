//
//  LFUserInfoHeaderView.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-12.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFUserInfoHeaderView.h"

#import "LFUser.h"

#import "LFWebImageView.h"

@interface LFUserPortrait : LFWebImageView

@end

@implementation LFUserPortrait

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [[self layer] setCornerRadius:MIN(CGRectGetWidth([self bounds]), CGRectGetHeight([self bounds]))/2];
}

@end

@interface LFUserInfoHeaderView ()

@property(nonatomic, strong) LFUserPortrait *evimgvUserPortrait;
@property(nonatomic, strong) UILabel *evlbNickname;
@property(nonatomic, strong) UILabel *evlbTelephone;

@end

@implementation LFUserInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 100)];
    
    if (self) {
        
        [self epCreateSubViews];
        [self epConfigSubViewsDefault];
        [self epInstallConstraints];
    }
    return self;
}

- (void)epCreateSubViews{
    
    [self setEvimgvUserPortrait:[LFUserPortrait emptyFrameView]];
    [self setEvlbNickname:[UILabel emptyFrameView]];
    [self setEvlbTelephone:[UILabel emptyFrameView]];
    
    [self addSubview:[self evimgvUserPortrait]];
    [self addSubview:[self evlbNickname]];
    [self addSubview:[self evlbTelephone]];
}

- (void)epConfigSubViewsDefault{
    
    [[self evlbNickname] setTextColor:[UIColor whiteColor]];
    [[self evlbNickname] setFont:[UIFont systemFontOfSize:14]];
    
    [[self evlbTelephone] setTextColor:[UIColor lightGrayColor]];
    [[self evlbTelephone] setFont:[UIFont systemFontOfSize:13]];
    
    [[self evimgvUserPortrait] setImage:[UIImage imageNamed:@"img_user_portrait_default"]];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evimgvUserPortrait] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(40);
        make.centerY.equalTo(ws.mas_centerY).offset(0);
        
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    
    [[self evlbNickname] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evimgvUserPortrait.mas_right).offset(8);
        make.bottom.equalTo(ws.evimgvUserPortrait.mas_centerY).offset(-3);
    }];
    
    [[self evlbTelephone] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evimgvUserPortrait.mas_right).offset(8);
        make.top.equalTo(ws.evimgvUserPortrait.mas_centerY).offset(3);
    }];
}

- (void)epConfigSubViews{
    
    [[self evimgvUserPortrait] sd_setImageWithURL:[NSURL URLWithString:[[self evUser] headImageUrl]]
                                 placeholderImage:[UIImage imageNamed:@"img_user_portrait_default"]];
    
    [[self evlbNickname] setText:nstodefault([[self evUser] salutation], @"未登录")];
    [[self evlbTelephone] setText:nstodefault([[self evUser] telephone], @"")];
    
    Weakself(ws);
    [[self evlbNickname] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evimgvUserPortrait.mas_right).offset(8);
        
        if ([[[ws evUser] telephone] length]) {
            make.bottom.equalTo(ws.evimgvUserPortrait.mas_centerY).offset(-3);
        }
        else{
            make.centerY.equalTo(ws.evimgvUserPortrait.mas_centerY).offset(0);
        }
    }];
    
    [[self evlbTelephone] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evimgvUserPortrait.mas_right).offset(8);
        
        if ([[[ws evUser] salutation] length]) {
            make.top.equalTo(ws.evimgvUserPortrait.mas_centerY).offset(3);
        }
        else{
            make.centerY.equalTo(ws.evimgvUserPortrait.mas_centerY).offset(0);
        }
    }];
}

- (void)setEvUser:(LFUser *)evUser{
    
    if (_evUser != evUser) {
        
        _evUser = evUser;
    }
    
    [self epConfigSubViews];
}


@end
