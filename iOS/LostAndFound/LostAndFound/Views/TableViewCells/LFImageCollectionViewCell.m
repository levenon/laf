//
//  LFImageCollectionViewCell.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/23.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFImageCollectionViewCell.h"
#import "LFWebImageView.h"

@interface LFImageCollectionViewCell ()<XLFViewConstructor>

@property(nonatomic, strong) LFWebImageView *evimgvContent;

@end

@implementation LFImageCollectionViewCell

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
    
    [[self contentView] addSubview:[self evimgvContent]];
}

- (void)epConfigSubViewsDefault{
    
    [self setBackgroundColor:[UIColor clearColor]];
    [[self contentView] setBackgroundColor:[UIColor clearColor]];
    
    [[self evimgvContent] setImage:[UIImage imageNamed:@"photoDefault"]];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evimgvContent] mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(ws.contentView).insets(UIEdgeInsetsZero);
    }];
}

- (void)epConfigSubViews{
    
    if ([[self evPhoto] thumbnail]) {
        
        [[self evimgvContent] setImage:[[self evPhoto] thumbnail]];
    }
    else{
        
        [[self evimgvContent] setFitSizeImageWithURL:[[self evPhoto] defaultUrl] placeholderImage:[UIImage imageNamed:@"photoDefault"]];
    }
}

- (void)setEvPhoto:(LFPhoto *)evPhoto{
    
    if (_evPhoto != evPhoto) {
        
        _evPhoto = evPhoto;
    }
    
    [self epConfigSubViews];
}

@end
