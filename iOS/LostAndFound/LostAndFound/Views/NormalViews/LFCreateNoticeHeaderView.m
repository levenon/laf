
//
//  LFCreateNoticeHeaderView.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/23.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFCreateNoticeHeaderView.h"

#import "LFImageCollectionViewCell.h"

#import "QBImagePickerController.h"

#import "LFEditablePhotoBrowserVC.h"

#import "LFCommonImagesSelectorVC.h"

#import "LFPhoto.h"

@interface LFCreateNoticeHeaderView ()<XLFViewConstructor, UICollectionViewDelegate, UICollectionViewDataSource, QBImagePickerControllerDelegate, LFPhotoBrowserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) UIView *evvBackground;

@property(nonatomic, strong) XLFPlaceholderTextView *evtxvTitleInput;

@property(nonatomic, strong) UICollectionView *evclcImageContainer;

@property(nonatomic, strong) NSMutableArray *evPhotos;

@end

@implementation LFCreateNoticeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMakePWH(CGPointZero, 0, 300)];
    
    if (self) {
        
        [self epCreateSubViews];
        [self epConfigSubViewsDefault];
        [self epInstallConstraints];
    }
    return self;
}

- (void)epCreateSubViews{
    
    [self setEvPhotos:[NSMutableArray array]];
    
    UICollectionViewFlowLayout *etCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [etCollectionViewLayout setItemSize:CGSizeMake(85, 85)];
    [etCollectionViewLayout setMinimumInteritemSpacing:5];
    [etCollectionViewLayout setMinimumLineSpacing:5];
    
    [self setEvvBackground:[UIView emptyFrameView]];
    [self setEvtxvTitleInput:[XLFPlaceholderTextView emptyFrameView]];
    [self setEvclcImageContainer:[[UICollectionView alloc] initWithFrame:CGRectZero
                                                    collectionViewLayout:etCollectionViewLayout]];
    
    [self addSubview:[self evvBackground]];
    [self addSubview:[self evtxvTitleInput]];
    [self addSubview:[self evclcImageContainer]];
}

- (void)epConfigSubViewsDefault{
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [[self evvBackground] setBackgroundColor:[UIColor whiteColor]];
    [[self evtxvTitleInput] setFont:[UIFont systemFontOfSize:14]];
    [[self evtxvTitleInput] setPlaceholderTextColor:[UIColor lightGrayColor]];
    [[self evtxvTitleInput] setPlaceholder:@"请描述一下您的宝贝"];
    [[self evtxvTitleInput] setTextLimitType:XLFTextLimitTypeByte];
    [[self evtxvTitleInput] setTextLimitSize:254];
    [[self evtxvTitleInput] setBackgroundColor:[UIColor clearColor]];
    [[[self evtxvTitleInput] textContainer] setLineBreakMode:NSLineBreakByCharWrapping];
    
    [[self evclcImageContainer] setDelegate:self];
    [[self evclcImageContainer] setDataSource:self];
    [[self evclcImageContainer] registerClass:[LFImageCollectionViewCell class]
                   forCellWithReuseIdentifier:NSStringFromClass([LFImageCollectionViewCell class])];
    [[self evclcImageContainer] registerClass:[UICollectionViewCell class]
                   forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [[self evclcImageContainer] setBackgroundColor:[UIColor clearColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTitleInputTextViewChange:) name:UITextViewTextDidChangeNotification object:[self evtxvTitleInput]];
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evvBackground] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(0);
        make.right.equalTo(ws.mas_right).offset(-0);
        make.bottom.equalTo(ws.mas_bottom).offset(0);
        make.height.equalTo(@(CGFLOAT_MAX));
    }];
    
    [[self evtxvTitleInput] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(0);
        make.right.equalTo(ws.mas_right).offset(-0);
        make.top.equalTo(ws.mas_top).offset(8);
    }];
    
    NSInteger etNumberOfRows = (SCREEN_WIDTH - 8) / 90;
    CGFloat etWidth = etNumberOfRows * 85 + (etNumberOfRows - 1) * 5;
    
    [[self evclcImageContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(8);
        make.top.equalTo(ws.evtxvTitleInput.mas_bottom).offset(8);
        make.bottom.equalTo(ws.mas_bottom).offset(-8);
        
        make.width.equalTo(@(etWidth));
        make.height.equalTo(@(85));
    }];
}

- (void)epConfigSubViews{
    
    [[self evtxvTitleInput] setText:[[self evNotice] title]];
    [[self evtxvTitleInput] setPlaceholder:[[self evNotice] titlePlaceHolder]];
    
    [[self evclcImageContainer] reloadData];
}

#pragma mark - accessory

- (void)setEvNotice:(LFEditableNotice *)evNotice{
    
    if (_evNotice != evNotice) {
        
        _evNotice = evNotice;
    }
    
    [self epConfigSubViews];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    
    return [[self evPhotos] count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    if ([indexPath row] < [[self evPhotos] count]) {
        
        LFImageCollectionViewCell *etclcImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LFImageCollectionViewCell class]) forIndexPath:indexPath];
        
        LFPhoto *etPhoto = [[self evPhotos] objectAtIndex:[indexPath row]];
        
        [etclcImageCell setEvPhoto:etPhoto];
        
        return etclcImageCell;
    }
    else{
        
        UICollectionViewCell *etclcImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        
        UIImageView *etimgvContent =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_add_photo_normal"]
                                                      highlightedImage:[UIImage imageNamed:@"btn_add_photo_selected"]];
        
        [etclcImageCell setBackgroundView:etimgvContent];
        
        return etclcImageCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;{
    
    if ([indexPath row] >= [[self evPhotos] count]) {
        
        if ([[self evPhotos] count] < 5) {
            
            [self _efWantSelectPhotos];
        }
        else{
            
            [MBProgressHUD showWithStatus:@"最多可选9张图片"];
        }
    }
    else{
        
        LFEditablePhotoBrowserVC *etPhotoBrowserVC = [[LFEditablePhotoBrowserVC alloc] initWithDelegate:self
                                                                                                 photos:[self evPhotos]
                                                                                           defaultIndex:[indexPath row]];
        
        [[[self evVisibleViewController] navigationController] pushViewController:etPhotoBrowserVC animated:YES];
    }
}

#pragma mark - LFPhotoBrowserDelegate

- (void)epEditablePhotoBrowserVC:(LFEditablePhotoBrowserVC *)editablePhotoBrowserVC didDeleteAtIndex:(NSInteger)nIndex;{
    
    [self _efDeletePhotoAtIndex:nIndex];
    
    if (![[self evPhotos] count]) {
        
        [[editablePhotoBrowserVC navigationController] popViewControllerAnimated:YES];
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfos:(NSArray<NSDictionary *> *)infos{
    
    NSMutableArray *etPhotos = [NSMutableArray array];
    
    for (NSDictionary *info in infos) {
        
        LFPhoto *etPhoto = [LFPhoto model];
        [etPhoto setImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        [etPhoto setThumbnail:[info objectForKey:UIImagePickerControllerThunbnailImage]];
    
        [etPhotos addObject:etPhoto];
    }
    
    [self _efAddLocalPhotos:etPhotos];
    
    [[imagePickerController navigationController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;{
    
    UIImage *etImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    etImage = [etImage scaleToSize:CGSizeMake(SCREEN_WIDTH * 2, [etImage size].height / [etImage size].width * SCREEN_WIDTH * 2 )];
    
    LFPhoto *etPhoto = [LFPhoto model];
    [etPhoto setImage:etImage];
    [etPhoto setThumbnail:[etImage scaleToSize:CGSizeMake(200, 200) stretch:NO]];
    
    [self _efAddLocalPhotos:@[etPhoto]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIViewController *)imagePickerController{
    
    if ([imagePickerController isKindOfClass:[QBImagePickerController class]]) {
        
        [[imagePickerController navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - private

- (void)_efDeletePhoto:(LFPhoto *)photo{
    
    NSAssert(photo, @"photo can't be nil.");
    NSAssert([[self evPhotos] containsObject:photo], @"photo isn't exsit.");
    
    [self _efDeletePhotoAtIndex:[[self evPhotos] indexOfObject:photo]];
}

- (void)_efDeletePhotoAtIndex:(NSInteger)nIndex{
    
    NSInteger etNumberOfRows = (SCREEN_WIDTH - 8) / 90;
    NSInteger etLastNumberOfLines = [[self evPhotos] count] / etNumberOfRows + 1;
    
    LFPhoto *etPhoto = [[self evPhotos] objectAtIndex:nIndex];
    
    [[[self evNotice] images] removeObject:etPhoto];
    [[[self evNotice] remoteImages] removeObject:etPhoto];
    
    [[self evPhotos] removeObjectAtIndex:nIndex];
    [[self evclcImageContainer] deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:nIndex inSection:0]]];
    
    NSInteger etNumberOfLines = [[self evPhotos] count] / etNumberOfRows + 1;
    
    if (etLastNumberOfLines != etNumberOfLines) {
        
        [self _efUpdateCollectionViewHeight];
    }
}

- (void)_efAddLocalPhotos:(NSArray<LFPhoto *> *)localPhotos;{
    
    NSMutableArray *etInsertIndexPaths = [NSMutableArray array];
    
    for (LFPhoto *photo in localPhotos) {
        
        NSIndexPath *etInsertIndexPath = [NSIndexPath indexPathForRow:[[self evPhotos] count] inSection:0];
        
        [etInsertIndexPaths addObject:etInsertIndexPath];
        
        [[[self evNotice] images] addObject:photo];
        [[self evPhotos] addObject:photo];
    }
    
    [[self evclcImageContainer] insertItemsAtIndexPaths:etInsertIndexPaths];
    
    [self _efUpdateCollectionViewHeight];
}

- (void)_efAddRemotePhoto:(LFPhoto *)remotePhoto;{
    
    NSIndexPath *etInsertIndexPath = [NSIndexPath indexPathForRow:[[self evPhotos] count] inSection:0];
    
    [[[self evNotice] remoteImages] addObject:remotePhoto];
    [[self evPhotos] addObject:remotePhoto];
    
    [[self evclcImageContainer] insertItemsAtIndexPaths:@[etInsertIndexPath]];
    
    [self _efUpdateCollectionViewHeight];
}

- (void)_efUpdateCollectionViewHeight{
    
    NSInteger etNumberOfRows = (SCREEN_WIDTH - 8) / 90;
    NSInteger etNumberOfLines = [[self evPhotos] count] / etNumberOfRows + 1;
    CGFloat etWidth = etNumberOfRows * 85 + (etNumberOfRows - 1) * 5;
    CGFloat etContainerHeight = 85 * etNumberOfLines + 5 * (etNumberOfLines - 1);
    
    [[self evclcImageContainer] mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(etWidth));
        make.height.equalTo(@(etContainerHeight));
    }];
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, etContainerHeight + 8 * 3 + 191)];
    
    UITableView *etTableView = (UITableView *)[self superview];
    [etTableView setTableHeaderView:self];
}

- (void)_efWantSelectPhotos{
    
    UIAlertController *etSelectPhotosAC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *etaaOpenCommonImages = [UIAlertAction actionWithTitle:@"常用照片" style:UIAlertActionStyleDefault handler:[self _efOpenCommonImagesAction]];
    
    UIAlertAction *etaaOpenCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:[self _efOpenCameraAction]];
    
    UIAlertAction *etaaOpenPhotoLibrary = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:[self _efOpenPhotoLibraryAction]];
    
    UIAlertAction *etaaCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [etSelectPhotosAC addAction:etaaOpenCommonImages];
    [etSelectPhotosAC addAction:etaaOpenCamera];
    [etSelectPhotosAC addAction:etaaOpenPhotoLibrary];
    [etSelectPhotosAC addAction:etaaCancel];
    
    UIPopoverPresentationController *etPopover = [etSelectPhotosAC popoverPresentationController];
    if (etPopover){
        
        UIView *etvSender = [[self evclcImageContainer] cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[[self evPhotos] count]
                                                                                                  inSection:0]];
        
        [etPopover setSourceView:etvSender];
        [etPopover setSourceRect:[etvSender bounds]];;
        [etPopover setPermittedArrowDirections:UIPopoverArrowDirectionAny];
    }
    
    [[self evVisibleViewController] presentViewController:etSelectPhotosAC
                                                 animated:YES
                                               completion:nil];
}

- (void (^ __nullable)(UIAlertAction *action))_efOpenCommonImagesAction{
    
    Weakself(ws);
    return ^(UIAlertAction *action){
        
        LFCommonImagesSelectorVC *etCommonImagesSelectorVC = [[LFCommonImagesSelectorVC alloc] initWithImageSelectCallback:[ws _efCommonImagesSelectorCallback]];
        
        [[[ws evVisibleViewController] navigationController] pushViewController:etCommonImagesSelectorVC animated:YES];
    };
}

- (void (^ __nullable)(UIAlertAction *action))_efOpenCameraAction{
    
    Weakself(ws);
    return ^(UIAlertAction *action){
        
        [[ws evVisibleViewController] efShowCameraWithCaptureMode:UIImagePickerControllerCameraCaptureModePhoto
                                                      qualityType:UIImagePickerControllerQualityTypeHigh
                                                     cameraDevice:UIImagePickerControllerCameraDeviceRear
                                                  cameraFlashMode:UIImagePickerControllerCameraFlashModeAuto
                                                    allowsEditing:NO
                                                         delegate:ws];
    };
}

- (void (^ __nullable)(UIAlertAction *action))_efOpenPhotoLibraryAction{
    
    Weakself(ws)
    return ^(UIAlertAction *action){
        
        QBImagePickerController *etImagePickerController = [[QBImagePickerController alloc] init];
        [etImagePickerController setDelegate:ws];
        [etImagePickerController setFilterType:QBImagePickerFilterTypeAllPhotos];
        [etImagePickerController setShowCancelButton:YES];
        [etImagePickerController setShowToolbar:YES];
        [etImagePickerController setAllowsMultipleSelection:YES];
        [etImagePickerController setLimitsMaximumNumberOfSelection:YES];
        [etImagePickerController setMaximumNumberOfSelection:9 - [[ws evPhotos] count]];
        
        UINavigationController *etImagePickerNC = [[UINavigationController alloc] initWithRootViewController:etImagePickerController];
        
        [[ws evVisibleViewController] presentViewController:etImagePickerNC animated:YES completion:nil];
    };
}

#pragma mark - LFCommonImagesSelectorVC callback

- (void (^)(LFCommonImagesSelectorVC *commonImagesSelectorVC, LFPhoto *photo))_efCommonImagesSelectorCallback{
    
    Weakself(ws);
    return ^(LFCommonImagesSelectorVC *commonImagesSelectorVC, LFPhoto *photo){
        
        if (photo) {
            
            [ws _efAddRemotePhoto:photo];
        }
        else{
            
            [MBProgressHUD showWithStatus:@"图片无效"];
        }
        
        [[commonImagesSelectorVC navigationController] popViewControllerAnimated:YES];
    };
}

#pragma mark - actions

- (IBAction)didTitleInputTextViewChange:(NSNotification *)notification{
    
    [[self evNotice] setTitle:[[self evtxvTitleInput] text]];
}

@end
