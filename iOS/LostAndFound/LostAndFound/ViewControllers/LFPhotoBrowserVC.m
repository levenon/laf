//
//  LFPhotoBrowserVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/22.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFPhotoBrowserVC.h"

@implementation LFPhotoContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self epCreateSubViews];
        [self epConfigSubViewsDefault];
        
        [self epInstallConstraints];
        
        [self epRelayoutSubViews:[self bounds]];
    }
    return self;
}

- (void)epCreateSubViews{
    
    [self setEvvContent:[UIView emptyFrameView]];
    [self setEvimgvContent:[LFWebImageView emptyFrameView]];
    
    [self addSubview:[self evvContent]];
    [[self evvContent] addSubview:[self evimgvContent]];
    
    [self setDelegate:self];
}

- (void)epConfigSubViewsDefault{
    
    [self setMaximumZoomScale:3];
    [self setMinimumZoomScale:1];
    
    [[self evvContent] setBackgroundColor:[UIColor clearColor]];
    
    [[self evimgvContent] setEvShowProgress:YES];
    [[self evimgvContent] setImage:[UIImage imageNamed:@"photoDefault"]];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evvContent] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws).insets(UIEdgeInsetsZero);
        make.centerX.equalTo(ws.mas_centerX).offset(0);
        make.centerY.equalTo(ws.mas_centerY).offset(0);
    }];
}

- (void)epRelayoutSubViews:(CGRect)bounds{
    
    CGSize etContentSize = CGRectGetSize(bounds);
    CGSize etImageSize = [[[self evimgvContent] image] size];
    
    if (etImageSize.width > etContentSize.width ||
        etImageSize.height > etContentSize.height) {
        
        CGFloat etWidthScale = etImageSize.width / etContentSize.width;
        CGFloat etHeightScale = etImageSize.height / etContentSize.height;
        
        CGFloat etScale = MAX(etWidthScale, etHeightScale);
        CGFloat etWidth = etImageSize.width / etScale;
        CGFloat etHeight = etImageSize.height / etScale;
        
        Weakself(ws);
        
        [[self evimgvContent] mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(ws.evvContent.mas_centerX).offset(0);
            make.centerY.equalTo(ws.evvContent.mas_centerY).offset(0);
            make.height.equalTo(@(etHeight));
            make.width.equalTo(@(etWidth));
        }];
    }
    else {
        
        Weakself(ws);
        
        [[self evimgvContent] mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(ws.evvContent.mas_centerX).offset(0);
            make.centerY.equalTo(ws.evvContent.mas_centerY).offset(0);
            make.height.equalTo(@(etImageSize.height));
            make.width.equalTo(@(etImageSize.width));
        }];
    }
}

- (void)epConfigSubViews{
    
    Weakself(ws);
    [[self evimgvContent] sd_setImageWithURL:[NSURL URLWithString:egfImageUrl([[self evImage] remoteId], fmts(@"%.fx", SCREEN_WIDTH * 2), nil, nil, 100, 0, nil)]
                            placeholderImage:select([[self evImage] image], [[self evImage] image], [UIImage imageNamed:@"photoDefault"])
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       
                                       [ws epRelayoutSubViews:[ws bounds]];
                                   }];
}

#pragma mark - accessory

- (void)setEvImage:(LFImage *)evImage{
    
    if (_evImage != evImage) {
        
        _evImage = evImage;
    }
    
    [self epConfigSubViews];
}

- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated{
    [super setZoomScale:scale animated:animated];
    
    [(UIScrollView *)[self superview] setScrollEnabled:scale == 1];
}

#pragma mark - actions

- (IBAction)didDoubleClickContent:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    [self setZoomScale:([self zoomScale] <= 1) + 1 animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;{
    
    return [self evvContent];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView;{
    
    [(UIScrollView *)[self superview] setScrollEnabled:[scrollView zoomScale] == 1];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;{
    
    if ([scrollView isDragging] && ![scrollView isDecelerating]) {
        
        CGSize etContentSize = [scrollView contentSize];
        CGPoint etContentOffset = [scrollView contentOffset];
        CGFloat etBoundWidth = CGRectGetWidth([scrollView bounds]);
        
        if (etContentOffset.x < 0 ||
            ((etContentSize.width < etBoundWidth && etContentOffset.x > etContentSize.width) ||
             (etContentSize.width >= etBoundWidth && etContentOffset.x > (etContentSize.width - etBoundWidth)))) {
                
                [self setZoomScale:1 animated:YES];
            }
    }
}

@end

@interface LFPhotoBrowserVC ()<UIScrollViewDelegate>

@property(nonatomic, assign) id<LFPhotoBrowserDelegate> evDelegate;

@property(nonatomic, assign) NSInteger evCurrentIndex;

@property(nonatomic, assign) NSInteger evNumberOfVisibleItems;

@property(nonatomic, strong) NSMutableArray<LFImage *> *evMutablePhotos;

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, LFPhotoContentView *> *evvPhotoContentItems;

@property(nonatomic, strong) UIScrollView *evscvContainer;

@property(nonatomic, strong) UITapGestureRecognizer *evtgrSingleTap;

@property(nonatomic, strong) NSTimer *evDoubleClickDelayTimer;

@end

@implementation LFPhotoBrowserVC

- (id)initWithDelegate:(id<LFPhotoBrowserDelegate>)delegate
                photos:(NSArray<LFImage *> *)photos
          defaultIndex:(NSInteger)defaultIndex;{
    
    self = [super init];
    if (self) {
        
        [self setTitle:@"图片浏览"];
        [self setEvDelegate:delegate];
        [self setEvMutablePhotos:[NSMutableArray arrayWithArray:photos]];
        [self setEvCurrentIndex:defaultIndex];
        [self setEvNumberOfVisibleItems:3];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [[self view] addSubview:[self evscvContainer]];
    [[self view] addGestureRecognizer:[self evtgrSingleTap]];
    
    [self _efInstallConstraints];
    
    [self _efUpdateItemsDisplay];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[self evscvContainer] setContentInset:UIEdgeInsetsZero];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self _efReloadData];
}

#pragma mark - accessory

- (UIScrollView *)evscvContainer{
    
    if (!_evscvContainer) {
        
        _evscvContainer = [UIScrollView emptyFrameView];
        [_evscvContainer setShowsVerticalScrollIndicator:NO];
        [_evscvContainer setShowsHorizontalScrollIndicator:NO];
        [_evscvContainer setBounces:NO];
        [_evscvContainer setPagingEnabled:YES];
        [_evscvContainer setDelegate:self];
    }
    return _evscvContainer;
}

- (NSMutableArray *)evMutablePhotos{
    
    if (!_evMutablePhotos) {
        
        _evMutablePhotos = [NSMutableArray array];
    }
    return _evMutablePhotos;
}

- (NSArray<LFImage *> *)evPhotos{
    
    return [NSArray arrayWithArray:[self evMutablePhotos]];
}

- (NSMutableDictionary<NSNumber *, LFPhotoContentView *> *)evvPhotoContentItems{
    
    if (!_evvPhotoContentItems) {
        
        _evvPhotoContentItems = [NSMutableDictionary<NSNumber *, LFPhotoContentView *> dictionary];
    }
    return _evvPhotoContentItems;
}

- (UITapGestureRecognizer *)evtgrSingleTap{
    
    if (!_evtgrSingleTap) {
        
        _evtgrSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContent:)];
        [_evtgrSingleTap setNumberOfTapsRequired:1];
        [_evtgrSingleTap setNumberOfTouchesRequired:1];
        [_evtgrSingleTap setDelaysTouchesBegan:YES];
    }
    return _evtgrSingleTap;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evscvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)_efReloadData{
    
    if (![[self evMutablePhotos] count]) {
        return;
    }
    
    [self _efUpdateContentSize];
    
    if ([self evCurrentIndex] > 0 && [self evCurrentIndex] < [[self evMutablePhotos] count] - 1) {
        [self _efLoadItemViewAtIndex:[self evCurrentIndex] - 1];
    }
    
    [self _efLoadItemViewAtIndex:[self evCurrentIndex]];
    
    if ([self evCurrentIndex] < [[self evMutablePhotos] count] - 1) {
        [self _efLoadItemViewAtIndex:[self evCurrentIndex] + 1];
    }
    
    [self _efUpdateContentOffset];
    
    [self _efUpdateItemsDisplay];
}

- (void)_efUpdateContentOffset{
    
    [[self evscvContainer] setContentOffset:CGPointMake(CGRectGetWidth([[self view] bounds]) * [self evCurrentIndex], 0)];
}

- (void)_efUpdateContentSize{
    
    [[self evscvContainer] setContentSize:CGSizeMake([[self evMutablePhotos] count] * CGRectGetWidth([[self view] bounds]), 0)];
}

- (void)_efUnloadItemViewAtIndex:(NSInteger)nIndex;{
    
    if (nIndex < 0 || nIndex >= [[self evMutablePhotos] count]) {
        return;
    }
    
    LFPhotoContentView *etscvPhotoContent = [[self evvPhotoContentItems] objectForKey:@(nIndex)];
    
    if (etscvPhotoContent) {
        
        [etscvPhotoContent removeFromSuperview];
        
        [[self evvPhotoContentItems] removeObjectForKey:@(nIndex)];
    }
}

- (void)_efLoadItemViewAtIndex:(NSInteger)nIndex;{
    
    if (nIndex < 0 || nIndex >= [[self evMutablePhotos] count]) {
        return;
    }
    
    if ([[[self evvPhotoContentItems] allKeys] containsObject:@(nIndex)]) {
        
        LFPhotoContentView *etscvPhotoContent = [[self evvPhotoContentItems] objectForKey:@(nIndex)];
        [etscvPhotoContent setZoomScale:1 animated:YES];
        
        return;
    }
    
    LFImage *etPhoto = [[self evMutablePhotos] objectAtIndex:nIndex];
    
    LFPhotoContentView *etscvPhotoContent = [[LFPhotoContentView alloc] initWithFrame:CGRectMake(CGRectGetWidth([[self view] bounds]) * nIndex, 0, CGRectGetWidth([[self view] bounds]), CGRectGetHeight([[self view] bounds]))];
    
    [etscvPhotoContent setEvImage:etPhoto];
    
    [[self evvPhotoContentItems] setObject:etscvPhotoContent forKey:@(nIndex)];
    [[self evscvContainer] addSubview:etscvPhotoContent];
}

- (void)_efUpdateItemsDisplay{
    
    [self setTitle:[NSString stringWithFormat:@"%d/%d", [self evCurrentIndex] + 1, [[self evMutablePhotos] count]]];
}

- (void)_efScheduleDoubleClickDelayTimer{
    
    [self _efDestroyDoubleClickDelayTimer];
    
    [self setEvDoubleClickDelayTimer:[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(didTriggerDoubleClickDelayTimer:) userInfo:nil repeats:NO]];
}

- (void)_efDestroyDoubleClickDelayTimer{
    
    if ([self evDoubleClickDelayTimer]) {
        
        [[self evDoubleClickDelayTimer] invalidate];
    }
    
    [self setEvDoubleClickDelayTimer:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger etIndex = floor([scrollView contentOffset].x / CGRectGetWidth([[self view] bounds]));
    
    if ([self evCurrentIndex] != etIndex && ([scrollView isDragging] || (![scrollView isDragging] && [scrollView isDecelerating]))) {
        
        [self _efUnloadItemViewAtIndex:etIndex - 2];
        [self _efLoadItemViewAtIndex:etIndex - 1];
        [self _efLoadItemViewAtIndex:etIndex];
        [self _efLoadItemViewAtIndex:etIndex + 1];
        [self _efUnloadItemViewAtIndex:etIndex + 2];
        
        [self setEvCurrentIndex:etIndex];
        
        [self _efUpdateItemsDisplay];
        
        if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epPhotoBrowserVC:didSelectedIndex:)]) {
            [[self evDelegate] epPhotoBrowserVC:self didSelectedIndex:etIndex];
        }
    }
}

#pragma mark - actions

- (IBAction)didTriggerDoubleClickDelayTimer:(id)sender{
    
    [[self navigationController] setNavigationBarHidden:![[self navigationController] isNavigationBarHidden]
                                               animated:YES];
    [self _efDestroyDoubleClickDelayTimer];
}

- (IBAction)didTapContent:(UITapGestureRecognizer *)sender{
    
    if ([self evDoubleClickDelayTimer]) {
        
        LFPhotoContentView *etscvPhotoContent = [[self evvPhotoContentItems] objectForKey:@([self evCurrentIndex])];
        
        [etscvPhotoContent didDoubleClickContent:sender];
        
        [self _efDestroyDoubleClickDelayTimer];
    }
    else{
        
        [self _efScheduleDoubleClickDelayTimer];
    }
}

@end
