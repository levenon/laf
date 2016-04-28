//
//  LFWebImageView.m
//  LostAndFound
//
//  Created by Marike Jave on 16/3/10.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFWebImageView.h"

@interface LFWebImageView ()

@end

@implementation LFWebImageView

#pragma mark - public

- (void)sd_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(SDWebImageDownloaderProgressBlock)progress
                 completed:(SDWebImageCompletionBlock)completed;{
    
    if ([self evShowProgress]) {
        [self startLoading];
        
        Weakself(ws);
        [[self evaivLoading] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws).insets(UIEdgeInsetsZero);
        }];
    }
    
    Weakself(ws);
    [super sd_setImageWithURL:url
             placeholderImage:placeholder
                      options:options
                     progress:progress
                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                        
                        if (completed) {
                            completed(image, error, cacheType, imageURL);
                        }
                        
                        if ([ws evShowProgress]) {
                            [ws stopLoading];
                        }
                    }];
}

- (void)setFitSizeImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;{
    
    [self setFitSizeImageWithURL:url placeholderImage:placeholder completed:nil];
}

- (void)setFitSizeImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completed;{
    
    CGSize size = CGRectGetSize([self bounds]);
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = [self systemLayoutSizeFittingSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    }
    
    [self setFitSizeImageWithURL:url size:size placeholderImage:placeholder completed:completed];
}

- (void)setFitSizeImageWithURL:(NSString *)url size:(CGSize)size placeholderImage:(UIImage *)placeholder;{
    
    [self setFitSizeImageWithURL:url size:size placeholderImage:placeholder completed:nil];
}

- (void)setFitSizeImageWithURL:(NSString *)url size:(CGSize)size placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completed;{
    
    CGFloat etScale = 1;
    
    [self sd_setImageWithURL:[NSURL URLWithString:fmts(@"%@&scale=!%.fx%.fr&crop=%.fx%.f", url, size.width * etScale, size.height * etScale, size.width * etScale, size.height * etScale)] placeholderImage:placeholder completed:completed];
}

@end
