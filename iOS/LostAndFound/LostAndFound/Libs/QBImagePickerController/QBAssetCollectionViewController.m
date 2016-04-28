/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBAssetCollectionViewController.h"

// Views
#import "QBImagePickerAssetCell.h"
#import "QBImagePickerFooterView.h"

#import "QBAssetBrowserViewController.h"

@implementation UIImage (Utils)

- (UIImage *)scaleToSize:(CGSize)size stretch:(BOOL)stretch{
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    if (!stretch) {
        
        CGFloat vScale = size.height/[self size].height;
        CGFloat hScale = size.width/[self size].width;
        
        // 垂直放大 水平放大 幅度大优先
        if ((vScale > 1 && hScale > 1 && (vScale - 1) > (hScale - 1)) ||
            // 垂直放大 水平缩小 放大优先
            (vScale > 1 && hScale < 1) ||
            // 垂直缩小 水平缩小 幅度小优先
            (vScale < 1 && hScale < 1 && fabs(vScale - 1) < fabs(hScale - 1))) {
            
            CGFloat width = [self size].width * vScale;
            rect.origin.x = -(width - size.width) / 2.;
            rect.size.width = width;
        }
        else {
            
            CGFloat height = [self size].height * hScale;
            rect.origin.y = -(height - size.height) / 2.;
            rect.size.height = height;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [self scale]);
    //    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:rect];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

@interface QBAssetCollectionViewController ()<QBAssetBrowserViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray<ALAsset *> *assets;
@property (nonatomic, strong) NSMutableOrderedSet<ALAsset *> *selectedAssets;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *previewButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property(nonatomic, assign) UIBarStyle previousBarStyle;
@property(nonatomic, assign) BOOL previousBarTranslucent;
@property(nonatomic, strong) UIColor *previousBarTintColor;
@property(nonatomic, strong) UIColor *previousBarBarTintColor;
@property(nonatomic, strong) UIImage *previousBarBackgroundImage;
@property(nonatomic, strong) UIImage *previousBarShadowImage;
@property(nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

- (void)reloadData;
- (void)updateRightBarButtonItem;
- (void)updateBarButton;
- (void)done;
- (void)cancel;

@end

@implementation QBAssetCollectionViewController

- (id)init{
    self = [super init];
    
    if(self) {
        
        /* Initialization */
        self.navigationBarTranslucent = YES;
        self.navigationBarStyle = UIBarStyleBlack;
        self.navigationBarShadowImage = [UIImage new];
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationBarTintColor = [UIColor whiteColor];
        self.navigationBarBarTintColor = [UIColor whiteColor];
        self.navigationBarBackgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.7]];
        self.imageSize = CGSizeMake(95, 95);
        self.assets = [NSMutableArray array];
        self.selectedAssets = [NSMutableOrderedSet orderedSet];
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        // Layout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.itemSize = self.imageSize;
        flowLayout.minimumLineSpacing = 6;
        flowLayout.minimumInteritemSpacing = 6;
        
        // Collection View
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.allowsSelection = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        self.collectionView = collectionView;
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        toolbar.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.previewButton = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStyleDone target:self action:@selector(didClickPreview:)];
        self.previewButton.enabled = NO;
        self.previewButton.tintColor = [UIColor grayColor];
        [self.previewButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
        
        self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        self.doneButton.tintColor = [UIColor colorWithRed:0.04 green:0.74 blue:0.04 alpha:1];
        [self.doneButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolbar = toolbar;
        self.toolbar.items = @[self.previewButton, flexibleSpace, self.doneButton];
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.toolbar];
    
    NSMutableArray *constraints = [NSMutableArray array];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.collectionView
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:8];
    [constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.collectionView
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant:-8];
    [constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.collectionView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0
                                               constant:0];
    [constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.collectionView
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:0];
    [constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.toolbar
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0
                                               constant:0];
    [constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.toolbar
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant:0];
    [constraints addObject:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.toolbar
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:0];
    [constraints addObject:constraint];
    
    [self.view addConstraints:constraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[QBImagePickerAssetCell class] forCellWithReuseIdentifier:NSStringFromClass([QBImagePickerAssetCell class])];
    
    self.previousBarStyle = [[[self navigationController] navigationBar] barStyle];
    self.previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    self.previousBarTintColor = [[[self navigationController] navigationBar] tintColor];
    self.previousBarShadowImage = [[[self navigationController] navigationBar] shadowImage];
    self.previousBarBarTintColor = [[[self navigationController] navigationBar] barTintColor];
    self.previousBarTranslucent = [[[self navigationController] navigationBar] isTranslucent];
    self.previousBarBackgroundImage = [[[self navigationController] navigationBar] backgroundImageForBarMetrics:UIBarMetricsDefault];
    
    CGFloat top = 8;
    if(![[UIApplication sharedApplication] isStatusBarHidden]) top = top + 20;
    if (!self.navigationController.isNavigationBarHidden) top = top + 44;
    self.collectionView.contentInset = UIEdgeInsetsMake(top, 0, (44 + 8) * self.showToolbar, 0);
    
    self.toolbar.hidden = !self.showToolbar;
    
    [self reloadData];
    
    [[self collectionView] scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[self assets] count] - 1 inSection:0]
                                  atScrollPosition:UICollectionViewScrollPositionBottom
                                          animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateBarStatus];
    
    [[self collectionView] scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[self assets] count] - 1 inSection:0]
                                  atScrollPosition:UICollectionViewScrollPositionBottom
                                          animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateBarStatus];
    
    [[self collectionView] scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[self assets] count] - 1 inSection:0]
                                  atScrollPosition:UICollectionViewScrollPositionBottom
                                          animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self previousStatusBarStyle]];
    
    [[[self navigationController] navigationBar] setBarStyle:[self previousBarStyle]];
    [[[self navigationController] navigationBar] setTintColor:[self previousBarTintColor]];
    [[[self navigationController] navigationBar] setTranslucent:[self previousBarTranslucent]];
    [[[self navigationController] navigationBar] setShadowImage:[self previousBarShadowImage]];
    [[[self navigationController] navigationBar] setBarTintColor:[self previousBarBarTintColor]];
    [[[self navigationController] navigationBar] setBackgroundImage:[self previousBarBackgroundImage] forBarMetrics:UIBarMetricsDefault];
}

- (void)setShowCancelButton:(BOOL)showCancelButton{
    _showCancelButton = showCancelButton;
    
    [self updateRightBarButtonItem];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    [self updateRightBarButtonItem];
}

- (void)dealloc{
    [self setAssetsGroup:nil];
    [self setAssets:nil];
    [self setSelectedAssets:nil];
    [self setCollectionView:nil];
    [self setDoneButton:nil];
    [self setPreviewButton:nil];
    [self setCancelButton:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self statusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark - Instance Methods

- (void)reloadData{
    // Reload assets
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [self.assets addObject:result];
        }
    }];
    
    [self.collectionView reloadData];
    
    switch(self.filterType) {
        case QBImagePickerFilterTypeAllAssets:
            [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
            break;
        case QBImagePickerFilterTypeAllPhotos:
            [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            break;
        case QBImagePickerFilterTypeAllVideos:
            [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
            break;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        
        [self.assets enumerateObjectsUsingBlock:^(ALAsset * _Nonnull asset, NSUInteger nIndex, BOOL * _Nonnull stop) {
            
            UIImage *fullScreenImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            
            UIImage *hdThumbnail = [fullScreenImage scaleToSize:CGSizeMake(self.imageSize.width * scale, self.imageSize.height * scale) stretch:NO];
            
            asset.hdThumbnail = hdThumbnail;
            
            dispatch_async(dispatch_get_main_queue(), ^{
    
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:nIndex inSection:0]]];
            });
        }];
    });
}

- (void)updateBarStatus{
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self statusBarStyle]];
    
    [[[self navigationController] navigationBar] setBarStyle:[self navigationBarStyle]];
    [[[self navigationController] navigationBar] setTintColor:[self navigationBarTintColor]];
    [[[self navigationController] navigationBar] setShadowImage:[self navigationBarShadowImage]];
    [[[self navigationController] navigationBar] setTranslucent:[self navigationBarTranslucent]];
    [[[self navigationController] navigationBar] setBarTintColor:[self navigationBarBarTintColor]];
    [[[self navigationController] navigationBar] setBackgroundImage:[self navigationBarBackgroundImage]
                                                      forBarMetrics:UIBarMetricsDefault];
}

- (void)updateRightBarButtonItem{
    
    if(self.showCancelButton) {
        // Set cancel button
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        
        [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
        
        self.cancelButton = cancelButton;
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (void)updateBarButton{
    
    self.doneButton.enabled = (self.selectedAssets.count > 0);
    self.previewButton.enabled = (self.selectedAssets.count > 0);
    self.doneButton.title = self.selectedAssets.count > 0 ? [NSString stringWithFormat:@"（%d）完成", self.selectedAssets.count] : @"完成";
}

- (void)done{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCollectionViewController:didFinishPickingAssets:)]) {
        [self.delegate assetCollectionViewController:self didFinishPickingAssets:self.selectedAssets.array];
    }
}

- (void)cancel{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetCollectionViewControllerDidCancel:)]) {
        [self.delegate assetCollectionViewControllerDidCancel:self];
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QBImagePickerAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([QBImagePickerAssetCell class])
                                                                             forIndexPath:indexPath];
    ALAsset *asset = [self.assets objectAtIndex:[indexPath row]];
    
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 8.0) {
        [cell setAsset:asset];
    }
    
    [cell setDelegate:self];
    [cell setAllowsMultipleSelection:self.allowsMultipleSelection];
    [cell setCellSelected:[self.selectedAssets containsObject:asset]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(QBImagePickerAssetCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ALAsset *asset = [self.assets objectAtIndex:[indexPath row]];
    
    [cell setAsset:asset];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)selectAllAssets:(BOOL)selectAll{
    
    if(selectAll) {
        
        // Select all assets
        [[self selectedAssets] removeAllObjects];
        [self.selectedAssets addObjectsFromArray:self.assets];
    }
    else {
        
        // Deselect all assets
        [self.selectedAssets removeAllObjects];
    }
    
    // Set done button state
    [self updateBarButton];
    
    // Update assets
    [[self collectionView] reloadData];
}

- (IBAction)didClickPreview:(id)sender{
    
    [self openBrowserControllerAtIndex:0];
}

- (IBAction)didClickSelectAll:(UIBarButtonItem *)sender{
    
    [self selectAllAssets:self.selectedAssets.count != self.assets.count];
}

- (void)openBrowserControllerAtIndex:(NSInteger)nIndex{
    
    QBAssetBrowserViewController *assetBrowserViewController = [[QBAssetBrowserViewController alloc] initWithDelegate:self
                                                                                                       selectedAssets:[self selectedAssets]
                                                                                                               assets:[self assets]
                                                                                                         defaultIndex:nIndex];
    
    [assetBrowserViewController setShowDoneButton:YES];
    [assetBrowserViewController setShowSelectButton:YES];
    
    [[self navigationController] pushViewController:assetBrowserViewController animated:YES];
}

#pragma mark - QBImagePickerAssetCellDelegate

- (BOOL)assetCellCanSelect:(QBImagePickerAssetCell *)assetCell{
    BOOL canSelect = YES;
    
    if(self.allowsMultipleSelection && self.limitsMaximumNumberOfSelection) {
        canSelect = (self.selectedAssets.count < self.maximumNumberOfSelection);
    }
    
    return canSelect;
}

- (void)assetCell:(QBImagePickerAssetCell *)assetCell didChangeAssetSelectionState:(BOOL)selected{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:assetCell];
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    if(self.allowsMultipleSelection) {
        if(selected) {
            [self.selectedAssets addObject:asset];
        } else {
            [self.selectedAssets removeObject:asset];
        }
        
        // Set done button state
        [self updateBarButton];
        
    } else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetCollectionViewController:didFinishPickingAsset:)]) {
            [self.delegate assetCollectionViewController:self didFinishPickingAsset:asset];
        }
    }
}

- (void)assetCellDidOpen:(QBImagePickerAssetCell *)assetCell;{
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:assetCell];
    
    [self openBrowserControllerAtIndex:indexPath.row];
}

#pragma mark -

- (BOOL)assetBrowserViewController:(QBAssetBrowserViewController *)assetBrowserViewController canSelectAssetAtIndex:(NSUInteger)index;{
    BOOL canSelect = YES;
    
    if(self.allowsMultipleSelection && self.limitsMaximumNumberOfSelection) {
        canSelect = (self.selectedAssets.count < self.maximumNumberOfSelection);
    }
    return canSelect;
}

- (void)assetBrowserViewController:(QBAssetBrowserViewController *)assetBrowserViewController didChangeAssetSelectionState:(BOOL)selected atIndex:(NSUInteger)index;{
    
    ALAsset *asset = [self.assets objectAtIndex:index];
    
    if(self.allowsMultipleSelection) {
        if(selected) {
            [self.selectedAssets addObject:asset];
        } else {
            [self.selectedAssets removeObject:asset];
        }
        // Set done button state
        [self updateBarButton];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetCollectionViewController:didFinishPickingAsset:)]) {
            [self.delegate assetCollectionViewController:self didFinishPickingAsset:asset];
        }
    }
}

- (void)assetDidDoneInBrowserViewController:(QBAssetBrowserViewController *)assetBrowserViewController;{
    
    [self done];
}

@end
