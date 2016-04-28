//
//  QBAssetBrowserViewController.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/25.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "QBAssetBrowserViewController.h"

@interface QBAssetContentView : UIScrollView<XLFViewConstructor, UIScrollViewDelegate>

@property(nonatomic, strong) ALAsset *asset;

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) UIImageView *contentImageView;

@end

@implementation QBAssetContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self epCreateSubViews];
        [self configSubViewsDefault];
        
        [self installConstraints];
        
        [self relayoutSubViews:[self bounds]];
    }
    return self;
}

- (void)epCreateSubViews{
    
    [self setContentView:[UIView emptyFrameView]];
    [self setContentImageView:[UIImageView emptyFrameView]];
    
    [self addSubview:[self contentView]];
    [[self contentView] addSubview:[self contentImageView]];
    
    [self setDelegate:self];
}

- (void)configSubViewsDefault{
    
    [self setMaximumZoomScale:3];
    [self setMinimumZoomScale:1];
    
    [self setShowsVerticalScrollIndicator:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    
    [[self contentView] setBackgroundColor:[UIColor clearColor]];
    [[self contentImageView] setImage:[UIImage imageNamed:@"photoDefault"]];
}

- (void)installConstraints{
    
    Weakself(ws);
    
    [[self contentView] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws).insets(UIEdgeInsetsZero);
        make.centerX.equalTo(ws.mas_centerX).offset(0);
        make.centerY.equalTo(ws.mas_centerY).offset(0);
    }];
}

- (void)relayoutSubViews:(CGRect)bounds{
    
    CGSize etContentSize = CGRectGetSize(bounds);
    CGSize etImageSize = [[[self contentImageView] image] size];
    
    if (etImageSize.width > etContentSize.width ||
        etImageSize.height > etContentSize.height) {
        
        CGFloat etWidthScale = etImageSize.width / etContentSize.width;
        CGFloat etHeightScale = etImageSize.height / etContentSize.height;
        
        CGFloat etScale = MAX(etWidthScale, etHeightScale);
        CGFloat etWidth = etImageSize.width / etScale;
        CGFloat etHeight = etImageSize.height / etScale;
        
        Weakself(ws);
        
        [[self contentImageView] mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(ws.contentView.mas_centerX).offset(0);
            make.centerY.equalTo(ws.contentView.mas_centerY).offset(0);
            make.height.equalTo(@(etHeight));
            make.width.equalTo(@(etWidth));
        }];
    }
    else {
        
        Weakself(ws);
        
        [[self contentImageView] mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(ws.contentView.mas_centerX).offset(0);
            make.centerY.equalTo(ws.contentView.mas_centerY).offset(0);
            make.height.equalTo(@(etImageSize.height));
            make.width.equalTo(@(etImageSize.width));
        }];
    }
}

- (void)configSubViews{
    
    ALAssetRepresentation *assetRepresentation = [[self asset] defaultRepresentation];
    
    UIImage *image = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
    
    [[self contentImageView] setImage:image];
    
    [self relayoutSubViews:[self bounds]];
}

#pragma mark - accessory

- (void)setEvImage:(ALAsset *)asset{
    
    if (_asset != asset) {
        
        _asset = asset;
    }
    
    [self configSubViews];
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
    
    return [self contentView];
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


@interface QBAssetBrowserViewController ()<UIScrollViewDelegate>

@property(nonatomic, assign) id<QBAssetBrowserViewControllerDelegate> delegate;

@property(nonatomic, assign) NSInteger currentIndex;

@property(nonatomic, assign) NSInteger numberOfVisibleItems;

@property(nonatomic, strong) NSArray<ALAsset *> *assets;

@property(nonatomic, strong) NSMutableOrderedSet<ALAsset *> *mutableSelectedAssets;

@property(nonatomic, strong) NSMutableDictionary<NSNumber *, QBAssetContentView *> *photoContentItems;

@property(nonatomic, strong) UIScrollView *containerScrollView;

@property(nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;

@property(nonatomic, strong) NSTimer *doubleClickDelayTimer;

@property(nonatomic, strong) UIToolbar *toolbar;

@property(nonatomic, strong) UIBarButtonItem *checkBarButtonItem;
@property(nonatomic, strong) UIBarButtonItem *doneBarButtonItem;

@property(nonatomic, strong) UIButton *checkButton;

@property(nonatomic, assign) BOOL previousBarHidden;
@property(nonatomic, assign) UIBarStyle previousBarStyle;
@property(nonatomic, assign) BOOL previousBarTranslucent;
@property(nonatomic, assign) BOOL previousStatusBarHidden;
@property(nonatomic, strong) UIColor *previousBarTintColor;
@property(nonatomic, strong) UIImage *previousBarShadowImage;
@property(nonatomic, strong) UIColor *previousBarBarTintColor;
@property(nonatomic, strong) UIImage *previousBarBackgroundImage;
@property(nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

@end

@implementation QBAssetBrowserViewController

- (id)initWithDelegate:(id<QBAssetBrowserViewControllerDelegate>)delegate
        selectedAssets:(NSOrderedSet<ALAsset *> *)selectedAssets
                assets:(NSArray<ALAsset *> *)assets
          defaultIndex:(NSInteger)defaultIndex;{
    
    self = [super init];
    if (self) {
        
        [self setTitle:@"图片浏览"];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationBarStyle = UIBarStyleBlack;
        self.navigationBarTranslucent = YES;
        self.navigationBarBackgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.7]];
        self.navigationBarShadowImage = [UIImage new];
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationBarTintColor = [UIColor whiteColor];
        self.navigationBarBarTintColor = [UIColor whiteColor];
        self.statusBarHidden = NO;
        
        [self setDelegate:delegate];
        [self setAssets:[assets copy]];
        [[self mutableSelectedAssets] unionOrderedSet:selectedAssets];
        [self setCurrentIndex:defaultIndex];
        [self setNumberOfVisibleItems:3];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self navigationItem] setRightBarButtonItem:[self checkBarButtonItem]];
    
    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [[self view] addSubview:[self containerScrollView]];
    [[self view] addSubview:[self toolbar]];
    [[self view] addGestureRecognizer:[self singleTapGestureRecognizer]];
    
    [self _efInstallConstraints];
    
    [self _efUpdateCurrentItemsState];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self _efReloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.previousBarStyle = [[[self navigationController] navigationBar] barStyle];
    self.previousBarTranslucent = [[[self navigationController] navigationBar] isTranslucent];
    self.previousBarHidden = [[self navigationController] isNavigationBarHidden];
    self.previousBarBackgroundImage = [[[self navigationController] navigationBar] backgroundImageForBarMetrics:UIBarMetricsDefault];
    self.previousBarShadowImage = [[[self navigationController] navigationBar] shadowImage];
    
    self.previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    self.previousStatusBarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
    
    [self _efUpdateBarStatus];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self _efUpdateBarStatus];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self previousStatusBarStyle]];
    
    [[[self navigationController] navigationBar] setBarStyle:[self previousBarStyle]];
    [[[self navigationController] navigationBar] setTranslucent:[self previousBarTranslucent]];
    [[[self navigationController] navigationBar] setTintColor:[self previousBarTintColor]];
    [[[self navigationController] navigationBar] setBarTintColor:[self previousBarBarTintColor]];
    [[[self navigationController] navigationBar] setBackgroundImage:[self previousBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setShadowImage:[self previousBarShadowImage]];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self statusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return [self statusBarHidden];
}

#pragma mark - accessory

- (UIScrollView *)containerScrollView{
    
    if (!_containerScrollView) {
        
        _containerScrollView = [UIScrollView emptyFrameView];
        [_containerScrollView setShowsVerticalScrollIndicator:NO];
        [_containerScrollView setShowsHorizontalScrollIndicator:NO];
        [_containerScrollView setBounces:NO];
        [_containerScrollView setPagingEnabled:YES];
        [_containerScrollView setDelegate:self];
    }
    return _containerScrollView;
}

- (NSArray *)assets{
    
    if (!_assets) {
        
        _assets = @[];
    }
    return _assets;
}

- (NSMutableOrderedSet<ALAsset *> *)mutableSelectedAssets{
    
    if (!_mutableSelectedAssets) {
        
        _mutableSelectedAssets = [NSMutableOrderedSet<ALAsset *> orderedSet];
    }
    return _mutableSelectedAssets;
}

- (NSOrderedSet<ALAsset *> *)selectedAssets{
    
    return [NSOrderedSet orderedSetWithOrderedSet:[self mutableSelectedAssets]];
}

- (NSMutableDictionary<NSNumber *, QBAssetContentView *> *)photoContentItems{
    
    if (!_photoContentItems) {
        
        _photoContentItems = [NSMutableDictionary<NSNumber *, QBAssetContentView *> dictionary];
    }
    return _photoContentItems;
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer{
    
    if (!_singleTapGestureRecognizer) {
        
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContent:)];
        [_singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [_singleTapGestureRecognizer setNumberOfTouchesRequired:1];
        [_singleTapGestureRecognizer setDelaysTouchesBegan:YES];
    }
    return _singleTapGestureRecognizer;
}

- (UIToolbar *)toolbar{
    
    if (!_toolbar) {
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _toolbar.items = @[flexibleSpace, [self doneBarButtonItem]];
    }
    return _toolbar;
}

- (UIBarButtonItem *)doneBarButtonItem{
    
    if (!_doneBarButtonItem) {
        
        _doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didClickDone:)];
        _doneBarButtonItem.tintColor = [UIColor colorWithRed:0.04 green:0.74 blue:0.04 alpha:1];
        [_doneBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    }
    return _doneBarButtonItem;
}

- (UIBarButtonItem *)checkBarButtonItem{
    
    if (!_checkBarButtonItem) {
        
        _checkBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self checkButton]];
    }
    return _checkBarButtonItem;
}

- (UIButton *)checkButton{
    
    if (!_checkButton) {
        
        _checkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_checkButton setImage:[UIImage imageNamed:@"QBImagePickerController.bundle/btn_nav_check_normal"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"QBImagePickerController.bundle/btn_nav_check_selected"] forState:UIControlStateSelected];
        
        [_checkButton addTarget:self action:@selector(didClickCheckAsset:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self containerScrollView] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
    
    [[self toolbar] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(0);
        make.right.equalTo(ws.view.mas_right).offset(0);
        make.bottom.equalTo(ws.view.mas_bottom).offset(0);
    }];
}

- (void)_efReloadData{
    
    if (![[self assets] count]) {
        return;
    }
    
    [[self photoContentItems] enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, QBAssetContentView * _Nonnull itemView, BOOL * _Nonnull stop) {
        [itemView removeFromSuperview];
    }];
    [[self photoContentItems] removeAllObjects];
    
    [[self containerScrollView] setContentSize:CGSizeMake([[self assets] count] * CGRectGetWidth([[self view] bounds]), 0)];
    
    if ([self currentIndex] > 0 && [self currentIndex] < [[self assets] count] - 1) {
        [self _efLoadItemViewAtIndex:[self currentIndex] - 1];
    }
    
    [self _efLoadItemViewAtIndex:[self currentIndex]];
    
    if ([self currentIndex] < [[self assets] count] - 1) {
        [self _efLoadItemViewAtIndex:[self currentIndex] + 1];
    }
    
    [[self containerScrollView] setContentOffset:CGPointMake(CGRectGetWidth([[self view] bounds]) * [self currentIndex], 0)];
    
    [self _efUpdateCurrentItemsState];
}

- (void)_efUnloadItemViewAtIndex:(NSInteger)nIndex;{
    
    if (nIndex < 0 || nIndex >= [[self assets] count]) {
        return;
    }
    
    QBAssetContentView *etscvPhotoContent = [[self photoContentItems] objectForKey:@(nIndex)];
    
    if (etscvPhotoContent) {
        
        [etscvPhotoContent removeFromSuperview];
        [[self photoContentItems] removeObjectForKey:@(nIndex)];
    }
}

- (void)_efLoadItemViewAtIndex:(NSInteger)nIndex;{
    
    if (nIndex < 0 || nIndex >= [[self assets] count]) {
        return;
    }
    
    if ([[[self photoContentItems] allKeys] containsObject:@(nIndex)]) {
        
        QBAssetContentView *etscvPhotoContent = [[self photoContentItems] objectForKey:@(nIndex)];
        [etscvPhotoContent setZoomScale:1 animated:YES];
        
        return;
    }
    
    ALAsset *etPhoto = [[self assets] objectAtIndex:nIndex];
    
    QBAssetContentView *etscvPhotoContent = [[QBAssetContentView alloc] initWithFrame:CGRectMake(CGRectGetWidth([[self view] bounds]) * nIndex, 0, CGRectGetWidth([[self view] bounds]), CGRectGetHeight([[self view] bounds]))];
    
    [etscvPhotoContent setEvImage:etPhoto];
    
    [[self photoContentItems] setObject:etscvPhotoContent forKey:@(nIndex)];
    [[self containerScrollView] addSubview:etscvPhotoContent];
}

- (void)_efUpdateCurrentItemsState{
    
    ALAsset *asset = [[self assets] objectAtIndex:[self currentIndex]];
    
    [[self checkButton] setSelected:[[self mutableSelectedAssets] containsObject:asset]];
    
    if ([[self mutableSelectedAssets] count]) {
        
        [[self doneBarButtonItem] setTitle:[NSString stringWithFormat:@"（%d）完成", [[self mutableSelectedAssets] count]]];
    }
    else{
        
        [[self doneBarButtonItem] setTitle:@"完成"];
    }
    
    [self setTitle:[NSString stringWithFormat:@"%d/%d", [self currentIndex] + 1, [[self assets] count]]];
}

- (void)_efScheduleDoubleClickDelayTimer{
    
    [self _efDestroyDoubleClickDelayTimer];
    
    [self setDoubleClickDelayTimer:[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(didTriggerDoubleClickDelayTimer:) userInfo:nil repeats:NO]];
}

- (void)_efDestroyDoubleClickDelayTimer{
    
    if ([self doubleClickDelayTimer]) {
        
        [[self doubleClickDelayTimer] invalidate];
    }
    
    [self setDoubleClickDelayTimer:nil];
}

- (void)_efUpdateBarStatus{
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self statusBarStyle]];
    
    [[[self navigationController] navigationBar] setBarStyle:[self navigationBarStyle]];
    [[[self navigationController] navigationBar] setTranslucent:[self navigationBarTranslucent]];
    [[[self navigationController] navigationBar] setTintColor:[self navigationBarTintColor]];
    [[[self navigationController] navigationBar] setBarTintColor:[self navigationBarBarTintColor]];
    [[[self navigationController] navigationBar] setBackgroundImage:[self navigationBarBackgroundImage]
                                                      forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setShadowImage:[self navigationBarShadowImage]];
    
    [[self toolbar] setBackgroundImage:[self navigationBarBackgroundImage] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[self toolbar] setShadowImage:[self navigationBarBackgroundImage] forToolbarPosition:UIBarPositionAny];
}

- (void)_efUpdateBarDisplay{
    
    BOOL display = [[self navigationController] isNavigationBarHidden];
    
    [[self view] layoutIfNeeded];
    
    Weakself(ws);
    [UIView animateWithDuration:0.3 animations:^{
        
        [[ws toolbar] mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(ws.view.mas_bottom).offset(display ? 0 : 50);
        }];
        
        [[ws view] layoutIfNeeded];
    }];
    
    [self setStatusBarHidden:!display];
    [[self navigationController] setNavigationBarHidden:!display
                                               animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger etIndex = floor( [scrollView contentOffset].x / CGRectGetWidth([[self view] bounds]));
    
    if ([self currentIndex] != etIndex) {
        
        [self _efUnloadItemViewAtIndex:etIndex - 2];
        [self _efLoadItemViewAtIndex:etIndex - 1];
        [self _efLoadItemViewAtIndex:etIndex];
        [self _efLoadItemViewAtIndex:etIndex + 1];
        [self _efUnloadItemViewAtIndex:etIndex + 2];
        
        [self setCurrentIndex:etIndex];
        
        [self _efUpdateCurrentItemsState];
    }
}

#pragma mark - actions

- (IBAction)didTriggerDoubleClickDelayTimer:(id)sender{
    
    [self _efUpdateBarDisplay];
    
    [self _efDestroyDoubleClickDelayTimer];
}

- (IBAction)didTapContent:(UITapGestureRecognizer *)sender{
    
    if ([self doubleClickDelayTimer]) {
        
        QBAssetContentView *etscvPhotoContent = [[self photoContentItems] objectForKey:@([self currentIndex])];
        
        [etscvPhotoContent didDoubleClickContent:sender];
        
        [self _efDestroyDoubleClickDelayTimer];
    }
    else{
        
        [self _efScheduleDoubleClickDelayTimer];
    }
}

- (IBAction)didClickCheckAsset:(id)sender{
    
    ALAsset *etAsset = [[self assets] objectAtIndex:[self currentIndex]];
    BOOL etContained = [[self mutableSelectedAssets] containsObject:etAsset];
    
    if (etContained) {
        
        [[self mutableSelectedAssets] removeObject:etAsset];
    } else {
        
        [[self mutableSelectedAssets] addObject:etAsset];
    }
    
    [self _efUpdateCurrentItemsState];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetBrowserViewController:didChangeAssetSelectionState:atIndex:)]) {
        [self.delegate assetBrowserViewController:self didChangeAssetSelectionState:!etContained atIndex:[self currentIndex]];
    }
}

- (IBAction)didClickDone:(id)sender{
    
    if (![[self mutableSelectedAssets] count]) {
        
        ALAsset *etAsset = [[self assets] objectAtIndex:[self currentIndex]];
        [[self mutableSelectedAssets] addObject:etAsset];
        [self _efUpdateCurrentItemsState];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetBrowserViewController:didChangeAssetSelectionState:atIndex:)]) {
            [self.delegate assetBrowserViewController:self didChangeAssetSelectionState:YES atIndex:[self currentIndex]];
        }
    }
    
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(assetDidDoneInBrowserViewController:)]) {
        [[self delegate] assetDidDoneInBrowserViewController:self];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        Weakself(ws);
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            [ws _efReloadData];
        } completion:nil];
    }
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        Weakself(ws);
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            [ws _efReloadData];
        } completion:nil];
    }
}




@end
