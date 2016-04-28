//
//  LFWebImageCell.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFWebImageCell.h"

@implementation LFWebImageCellModel

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                  temporaryImage:(UIImage *)temporaryImage
                placeholderImage:(UIImage *)placeholderImage
                       limitSize:(CGSize)limitSize
                           title:(NSString *)title;{
    self = [super initWithTitle:title detailText:nil];
    if (self) {
        
        [self setEvImageUrl:imageUrl];
        [self setEvSize:limitSize];
        [self setEvTemporaryImage:temporaryImage];
        [self setEvPlaceholderImage:placeholderImage];
    }
    return self;
}

- (Class<XLFTableViewCellInterface>)evCellClass{
    
    if (!_evCellClass) {
        
        _evCellClass = [LFWebImageCell class];
    }
    
    return _evCellClass;
}

- (CGFloat)evHeight{
    
    if (_evHeight <= 0) {
        
        return 80;
    }
    return _evHeight;
}

@end

@interface XLFNormalCell (Private)<XLFViewConstructor>

@end

@interface LFWebImageCell ()<XLFViewConstructor>

@property(nonatomic, strong) LFWebImageView *evimgvWebImageContent;

@end

@implementation LFWebImageCell

+ (CGFloat)epTableView:(UITableView *)tableView heightWithModel:(LFWebImageCellModel *)model;{
    
    return [model evHeight];
}

- (void)epCreateSubViews{
    [super epCreateSubViews];
    
    [self setEvimgvWebImageContent:[LFWebImageView emptyFrameView]];
    
    [self setAccessoryView:[self evimgvWebImageContent]];
}

- (void)epConfigSubViewsDefault{
    [super epConfigSubViewsDefault];
}

- (void)epConfigSubViews{
    [super epConfigSubViews];
    
    [[self evimgvWebImageContent] setFrame:CGRectMakePS(CGPointZero, [[self evModel] evSize])];
    
    if ([[self evModel] evTemporaryImage]) {
        
        [[self evimgvWebImageContent] setImage:[[self evModel] evTemporaryImage]];
    }
    else {
        
        [[self evimgvWebImageContent] sd_setImageWithURL:[NSURL URLWithString:[[self evModel] evImageUrl]]
                                     placeholderImage:[[self evModel] evPlaceholderImage]];
    }
}

@end
