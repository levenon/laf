/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <objc/runtime.h>

#import "QBImagePickerAssetCell.h"

// Views
#import "QBImagePickerVideoInfoView.h"

@interface QBImagePickerAssetCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) QBImagePickerVideoInfoView *videoInfoView;
@property (nonatomic, strong) UIButton *checkButton;

- (UIImage *)thumbnail;
- (UIImage *)tintedThumbnail;

@end

@implementation QBImagePickerAssetCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self) {
        /* Initialization */
        // Image View
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:imageView];
        self.imageView = imageView;
        
        // Video Info View
        QBImagePickerVideoInfoView *videoInfoView = [[QBImagePickerVideoInfoView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 17, self.bounds.size.width, 17)];
        videoInfoView.hidden = YES;
        videoInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:videoInfoView];
        self.videoInfoView = videoInfoView;
        
        // Overlay button
        UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([self bounds]) - 50, 0, 50, 50)];
        [checkButton setImage:[UIImage imageNamed:@"QBImagePickerController.bundle/btn_check_normal"] forState:UIControlStateNormal];
        [checkButton setImage:[UIImage imageNamed:@"QBImagePickerController.bundle/btn_check_selected"] forState:UIControlStateSelected];
        [checkButton setImage:[UIImage imageNamed:@"QBImagePickerController.bundle/btn_check_disable"] forState:UIControlStateDisabled];
        [checkButton addTarget:self action:@selector(didClickCheckButton:) forControlEvents:UIControlEventTouchUpInside];
        [checkButton setImageEdgeInsets:UIEdgeInsetsMake(-10, 10, 0, 0)];
        [self addSubview:checkButton];
        
        self.checkButton = checkButton;
    }
    return self;
}

- (void)setAsset:(ALAsset *)asset{
    if (_asset != asset) {
        _asset = asset;
    }
    
    if (asset) {
        
        // Set thumbnail image
        self.imageView.image = [self thumbnail];
        
        if (self.asset.hdThumbnail) {
            self.imageView.image = self.asset.hdThumbnail;
        }
        
        if([self.asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
            double duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
            
            self.videoInfoView.hidden = NO;
            self.videoInfoView.duration = round(duration);
        } else {
            self.videoInfoView.hidden = YES;
        }
    }
}

- (void)setCellSelected:(BOOL)cellSelected{
    if(self.allowsMultipleSelection) {
        self.checkButton.selected = cellSelected;
    }
}

- (BOOL)isCellSelected{
    return self.checkButton.isSelected;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    self.imageView.image = highlighted ? [self tintedThumbnail] : [self thumbnail];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    
    _allowsMultipleSelection = allowsMultipleSelection;
    
    self.checkButton.hidden = !allowsMultipleSelection;
}

- (void)dealloc{
    
    [self setAsset:nil];
    [self setImageView:nil];
    [self setCheckButton:nil];
    [self setVideoInfoView:nil];
}

- (void)didClickCheckButton:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(assetCellCanSelect:)] && [self.delegate assetCellCanSelect:self]) {
        self.cellSelected = !self.isCellSelected;
    }
    else {
        if(self.allowsMultipleSelection && self.isCellSelected) {
            self.cellSelected = !self.isCellSelected;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCell:didChangeAssetSelectionState:)]) {
        [self.delegate assetCell:self didChangeAssetSelectionState:self.isCellSelected];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    self.imageView.image = [self thumbnail];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCellDidOpen:)]) {
        [self.delegate assetCellDidOpen:self];
    }
}


#pragma mark - Instance Methods

- (UIImage *)thumbnail{
    
    return [UIImage imageWithCGImage:[[self asset] thumbnail]];
}

- (UIImage *)tintedThumbnail{
    
    UIImage *thumbnail = [self thumbnail];
    
    UIGraphicsBeginImageContext(thumbnail.size);
    
    CGRect rect = CGRectMake(0, 0, thumbnail.size.width, thumbnail.size.height);
    [thumbnail drawInRect:rect];
    
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
    
    UIImage *tintedThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedThumbnail;
}

@end

@implementation ALAsset (Extension)

- (UIImage *)hdThumbnail{
    
    return objc_getAssociatedObject(self, @selector(hdThumbnail));
}

- (void)setHdThumbnail:(UIImage *)hdThumbnail{
    
    objc_setAssociatedObject(self, @selector(hdThumbnail), hdThumbnail, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
