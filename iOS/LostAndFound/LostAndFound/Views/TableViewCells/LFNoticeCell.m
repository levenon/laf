//
//  LFNoticeCell.m
//  NoticeAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFNoticeCell.h"

#import "LFWebImageView.h"

@interface LFNoticeCell ()<XLFViewInterface>

@property(nonatomic, strong) LFWebImageView *evimgvThumb;

@property(nonatomic, strong) LFWebImageView *evimgvUserPortrait;

@property(nonatomic, strong) UIView *evvContentBackground;

@property(nonatomic, strong) UILabel *evlbTitle;

@property(nonatomic, strong) UILabel *evlbDistance;

@property(nonatomic, strong) UIImageView *evimgvLocation;

@property(nonatomic, strong) UILabel *evlbAddress;

@end

@implementation LFNoticeCell

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    
    [self setEvimgvThumb:[LFWebImageView emptyFrameView]];
    [self setEvvContentBackground:[UIView emptyFrameView]];
    [self setEvimgvUserPortrait:[LFWebImageView emptyFrameView]];
    [self setEvlbTitle:[UILabel emptyFrameView]];
    [self setEvlbDistance:[UILabel emptyFrameView]];
    [self setEvlbAddress:[UILabel emptyFrameView]];
    [self setEvimgvLocation:[UIImageView emptyFrameView]];
    
    [[self contentView] addSubview:[self evimgvThumb]];
    [[self contentView] addSubview:[self evvContentBackground]];
    [[self contentView] addSubview:[self evimgvUserPortrait]];
    [[self contentView] addSubview:[self evlbTitle]];
    [[self contentView] addSubview:[self evlbAddress]];
    [[self contentView] addSubview:[self evlbDistance]];
    [[self contentView] addSubview:[self evimgvLocation]];
}

- (void)epConfigSubViewsDefault{
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [[self evvContentBackground] setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    
    [[self evlbTitle] setNumberOfLines:3];
    [[self evlbTitle] setLineBreakMode:NSLineBreakByCharWrapping];
    [[self evlbTitle] setFont:[UIFont boldSystemFontOfSize:14]];
    [[self evlbTitle] setTextColor:[UIColor colorWithWhite:0.8 alpha:1]];
    
    [[self evlbDistance] setTextColor:[UIColor grayColor]];
    [[self evlbDistance] setFont:[UIFont systemFontOfSize:12]];
    [[self evlbDistance] setTextAlignment:NSTextAlignmentRight];
    
    [[self evlbAddress] setTextColor:[UIColor grayColor]];
    [[self evlbAddress] setFont:[UIFont systemFontOfSize:12]];
    
    [[self evimgvThumb] setEvShowProgress:YES];
    [[self evimgvThumb] setImage:[UIImage imageNamed:@"photoDefault"]];
    
    [[self evimgvUserPortrait] setImage:[UIImage imageNamed:@"img_user_portrait_default"]];
    
    [[[self evimgvUserPortrait] layer] setCornerRadius:20];
    [[[self evimgvUserPortrait] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[[self evimgvUserPortrait] layer] setBorderWidth:2];
    [[[self evimgvUserPortrait] layer] setMasksToBounds:YES];
    
    [[self evimgvLocation] setImage:[UIImage imageNamed:@"img_location_normal"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateUserInfoChanged:) name:kUserInfoChangedNotification object:nil];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evimgvThumb] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.contentView).insets(UIEdgeInsetsMake(0, 0, 2, 0));
        make.height.equalTo(@(SCREEN_WIDTH * 0.7));
        make.width.equalTo(@(SCREEN_WIDTH));
    }];
    
    [[self evimgvUserPortrait] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(8);
        make.top.equalTo(ws.contentView.mas_top).offset(8);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    [[self evvContentBackground] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(0);
        make.right.equalTo(ws.contentView.mas_right).offset(0);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-2);
    }];
    
    [[self evlbTitle] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(8);
        make.right.equalTo(ws.contentView.mas_right).offset(-8);
        make.top.equalTo(ws.evvContentBackground.mas_top).offset(8);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [[self evimgvLocation] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.contentView.mas_left).offset(8);
        make.top.equalTo(ws.evlbTitle.mas_bottom).offset(8);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-10);
        make.height.equalTo(@12);
        make.width.equalTo(@7);
    }];
    
    [[self evlbAddress] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evimgvLocation.mas_right).offset(8);
        make.centerY.equalTo(ws.evimgvLocation.mas_centerY).offset(0);
    }];
    
    [[self evlbDistance] mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(ws.contentView.mas_right).offset(-8);
        make.left.equalTo(ws.evlbAddress.mas_right).offset(0);
        make.centerY.equalTo(ws.evlbAddress.mas_centerY).offset(0);
    }];
}

- (void)epConfigSubViews{
    
    [[self evlbTitle] setText:[[self evNotice] title]];
    [[self evlbDistance] setText:[LFConstants distanceDescription:[[self evNotice] distance]]];
    [[self evlbAddress] setText:[[[self evNotice] location] name]];
    [[self evimgvUserPortrait] sd_setImageWithURL:[NSURL URLWithString:[[[self evNotice] user] headImageUrl]]
                                 placeholderImage:[UIImage imageNamed:@"img_user_portrait_default"]];
    [[self evimgvThumb] setFitSizeImageWithURL:[[[self evNotice] image] defaultUrl]
                              placeholderImage:[UIImage imageNamed:@"photoDefault"]];
}


- (NSArray<UITransitionCoordinatorTransformer *> *)viewWillTransitionToSize:(CGSize)size
                                                  withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator;{
    
    NSArray *etTransformers = [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    return [self _efTransformersWithSuperTransformers:etTransformers];
}

- (NSArray<UITransitionCoordinatorTransformer *> *)willTransitionToTraitCollection:(UITraitCollection *)newCollection
                                                         withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator;{
    
    NSArray *etTransformers = [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    return [self _efTransformersWithSuperTransformers:etTransformers];
}

#pragma mark - private

- (NSArray *)_efTransformersWithSuperTransformers:(NSArray *)superTransformers{
    
    UITransitionCoordinatorTransformer *etTransformer = [UITransitionCoordinatorTransformer new];
    
    Weakself(ws);
    [etTransformer setCompletion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [ws epConfigSubViews];
    }];
    
    if (superTransformers) {
        
        return [superTransformers arrayByAddingObject:etTransformer];
    }
    else{
        return @[etTransformer];
    }
}

#pragma mark - accessory

- (void)setEvNotice:(LFNotice *)evNotice{
    
    if (_evNotice != evNotice) {
        
        _evNotice = evNotice;
    }
    
    [self epConfigSubViews];
}

#pragma mark - actions

- (IBAction)didNotificateUserInfoChanged:(NSNotification *)notification{
    
    LFUser *etUser = [notification object];
    if ([[etUser id] isEqualToString:[[self evNotice] uid]]) {
        [[self evNotice] setUser:[etUser mutableCopy]];
    }
    
    [self epConfigSubViews];
}

@end

