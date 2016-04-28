/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBImagePickerController.h"

// Views
#import "QBImagePickerGroupCell.h"

// Controllers
#import "QBAssetCollectionViewController.h"

NSString const *UIImagePickerControllerThunbnailImage = @"UIImagePickerControllerThunbnailImage";

@interface QBImagePickerController ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray<ALAssetsGroup *> *assetsGroups;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) UIBarStyle previousBarStyle;
@property(nonatomic, assign) BOOL previousBarTranslucent;
@property(nonatomic, strong) UIColor *previousBarTintColor;
@property(nonatomic, strong) UIColor *previousBarBarTintColor;
@property(nonatomic, strong) UIImage *previousBarBackgroundImage;
@property(nonatomic, strong) UIImage *previousBarShadowImage;
@property(nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

- (void)cancel;
- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset;

@end

@implementation QBImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        /* Check sources */
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        /* Initialization */
        self.title = @"相册";
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.filterType = QBImagePickerFilterTypeAllPhotos;
        self.showCancelButton = YES;
        
        self.allowsMultipleSelection = NO;
        self.limitsMinimumNumberOfSelection = NO;
        self.limitsMaximumNumberOfSelection = NO;
        self.minimumNumberOfSelection = 0;
        self.maximumNumberOfSelection = 0;
        self.navigationBarStyle = UIBarStyleBlack;
        self.navigationBarTranslucent = YES;
        self.navigationBarBackgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.7]];
        self.navigationBarShadowImage = [UIImage new];
        self.statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationBarTintColor = [UIColor whiteColor];
        self.navigationBarBarTintColor = [UIColor whiteColor];
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = assetsLibrary;
        
        self.assetsGroups = [NSMutableArray array];
        
        // Table View
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        if(assetsGroup) {
            switch(self.filterType) {
                case QBImagePickerFilterTypeAllAssets:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                    break;
                case QBImagePickerFilterTypeAllPhotos:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                    break;
                case QBImagePickerFilterTypeAllVideos:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                    break;
            }
            if(assetsGroup.numberOfAssets > 0) {
                [self.assetsGroups addObject:assetsGroup];
                
                [self.tableView reloadData];
            }
        }
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.previousBarStyle = [[[self navigationController] navigationBar] barStyle];
    self.previousBarTranslucent = [[[self navigationController] navigationBar] isTranslucent];
    self.previousBarTintColor = [[[self navigationController] navigationBar] tintColor];
    self.previousBarBarTintColor = [[[self navigationController] navigationBar] barTintColor];
    self.previousBarBackgroundImage = [[[self navigationController] navigationBar] backgroundImageForBarMetrics:UIBarMetricsDefault];
    self.previousBarShadowImage = [[[self navigationController] navigationBar] shadowImage];
    self.previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    [self updateBarStatus];
    
    CGFloat top = 8;
    if(![[UIApplication sharedApplication] isStatusBarHidden]) top = top + 20;
    if (!self.navigationController.isNavigationBarHidden) top = top + 44;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateBarStatus];
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

- (void)setShowCancelButton:(BOOL)showCancelButton{
    _showCancelButton = showCancelButton;
    
    if(self.showCancelButton) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (void)dealloc{
    [self setAssetsLibrary:nil];
    [self setAssetsGroups:nil];
    [self setTableView:nil];
}

- (void)updateBarStatus{
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self statusBarStyle]];
    
    [[[self navigationController] navigationBar] setBarStyle:[self navigationBarStyle]];
    [[[self navigationController] navigationBar] setTranslucent:[self navigationBarTranslucent]];
    [[[self navigationController] navigationBar] setTintColor:[self navigationBarTintColor]];
    [[[self navigationController] navigationBar] setBarTintColor:[self navigationBarBarTintColor]];
    [[[self navigationController] navigationBar] setBackgroundImage:[self navigationBarBackgroundImage]
                                                      forBarMetrics:UIBarMetricsDefault];
    [[[self navigationController] navigationBar] setShadowImage:[self navigationBarShadowImage]];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self statusBarStyle];
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark - Instance Methods

- (void)cancel{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset{
    
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:[UIImage imageWithCGImage:[asset thumbnail]] forKey:UIImagePickerControllerThunbnailImage];
    [mediaInfo setObject:[asset valueForProperty:ALAssetPropertyType] forKey:UIImagePickerControllerMediaType];
    [mediaInfo setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:UIImagePickerControllerOriginalImage];
    [mediaInfo setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:UIImagePickerControllerReferenceURL];
    
    return mediaInfo;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    QBImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[QBImagePickerGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    cell.countLabel.text = [NSString stringWithFormat:@"(%d)", assetsGroup.numberOfAssets];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    
    // Show assets collection view
    QBAssetCollectionViewController *assetCollectionViewController = [[QBAssetCollectionViewController alloc] init];
    assetCollectionViewController.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    assetCollectionViewController.delegate = self;
    assetCollectionViewController.assetsGroup = assetsGroup;
    assetCollectionViewController.filterType = self.filterType;
    assetCollectionViewController.showCancelButton = self.showCancelButton;
    assetCollectionViewController.showToolbar = self.showToolbar;
    assetCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
    assetCollectionViewController.limitsMinimumNumberOfSelection = self.limitsMinimumNumberOfSelection;
    assetCollectionViewController.limitsMaximumNumberOfSelection = self.limitsMaximumNumberOfSelection;
    assetCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
    assetCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    
    [self.navigationController pushViewController:assetCollectionViewController animated:YES];
}

#pragma mark - QBAssetCollectionViewControllerDelegate

- (void)assetCollectionViewController:(QBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAsset:(ALAsset *)asset{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerWillFinishPickingMedia:)]) {
        [self.delegate imagePickerControllerWillFinishPickingMedia:self];
    }
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfos:)]) {
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfos:@[[self mediaInfoFromAsset:asset]]];
    }
}

- (void)assetCollectionViewController:(QBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAssets:(NSArray *)assets{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerWillFinishPickingMedia:)]) {
        [self.delegate imagePickerControllerWillFinishPickingMedia:self];
    }
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfos:)]) {
        NSMutableArray *infos = [NSMutableArray array];
        
        for(ALAsset *asset in assets) {
            [infos addObject:[self mediaInfoFromAsset:asset]];
        }
        
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfos:infos];
    }
}

- (void)assetCollectionViewControllerDidCancel:(QBAssetCollectionViewController *)assetCollectionViewController{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

@end
