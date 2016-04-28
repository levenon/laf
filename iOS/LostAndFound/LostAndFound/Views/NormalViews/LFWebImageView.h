//
//  LFWebImageView.h
//  LostAndFound
//
//  Created by Marike Jave on 16/3/10.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "SDImageCache.h"

#import "UIImageView+WebCache.h"

@interface LFWebImageView : UIWebImageView

@property(nonatomic, assign) BOOL evShowProgress;

- (void)setFitSizeImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder;

- (void)setFitSizeImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completed;

- (void)setFitSizeImageWithURL:(NSString *)url size:(CGSize)size placeholderImage:(UIImage *)placeholder;

- (void)setFitSizeImageWithURL:(NSString *)url size:(CGSize)size placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completed;

@end
