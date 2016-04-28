//
//  LFWebImageCell.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import "LFWebImageView.h"

@interface LFWebImageCellModel : XLFNormalCellModel

@property(nonatomic, assign) CGSize evSize;

@property(nonatomic, copy  ) NSString *evImageUrl;

@property(nonatomic, strong) UIImage *evPlaceholderImage;

@property(nonatomic, strong) UIImage *evTemporaryImage;

- (instancetype)initWithImageUrl:(NSString *)imageUrl
                  temporaryImage:(UIImage *)temporaryImage
                placeholderImage:(UIImage *)placeholderImage
                       limitSize:(CGSize)limitSize
                           title:(NSString *)title;
@end

@interface LFWebImageCell : XLFNormalCell

@property(nonatomic, strong) LFWebImageCellModel *evModel;

@property(nonatomic, strong, readonly) LFWebImageView *evimgvWebImageContent;

@end
