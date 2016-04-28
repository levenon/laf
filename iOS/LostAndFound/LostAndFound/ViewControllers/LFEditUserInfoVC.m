//
//  EditUserInfoVC.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import "LFEditUserInfoVC.h"

#import "LFWebImageCell.h"

#import "LFTextEditVC.h"

#import "LFModifyPasswordVC.h"

#import "LFWebImageView.h"

#import "LFTelephoneEditVC.h"

@class LFPortraitWebImageCellModel;


@interface LFWebImageCell (Private)<XLFViewConstructor>

@property(nonatomic, strong, readonly) LFWebImageView *evimgvWebImageContent;

@end


@interface LFPortraitWebImageCell : LFWebImageCell

@property(nonatomic, strong) LFPortraitWebImageCellModel *evModel;

@end

@implementation LFPortraitWebImageCell

- (void)epConfigSubViewsDefault{
    [super epConfigSubViewsDefault];
    
    [[[self evimgvWebImageContent] layer] setCornerRadius:30];
    [[[self evimgvWebImageContent] layer] setMasksToBounds:YES];
}

@end


@interface LFPortraitWebImageCellModel : LFWebImageCellModel
@end

@implementation LFPortraitWebImageCellModel

- (Class<XLFTableViewCellInterface>)evCellClass{
    
    if (!_evCellClass) {
        
        _evCellClass = [LFPortraitWebImageCell class];
    }
    
    return _evCellClass;
}

@end

@interface LFEditUserInfoVC ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, copy  ) void (^evblcEditCallback)(LFEditUserInfoVC *editUserInfoVC, BOOL success);

@property(nonatomic, copy  ) LFUser *evUser;

@property(nonatomic, assign) LFModitfyUserInfoType evModifyType;

@property(nonatomic, strong) XLFStaticTableView *evtbvContainer;

@property(nonatomic, strong) UIImage *evUserPortrait;

@property(nonatomic, strong) UIBarButtonItem *evbbiSubmit;

@end

@implementation LFEditUserInfoVC

- (instancetype)initWithUser:(LFUser *)user editCallback:(void (^)(LFEditUserInfoVC *editUserInfoVC, BOOL success))editCallback;{
    self = [super init];
    if (self) {
        
        [self setTitle:@"个人信息"];
        [self setEvUser:user];
        [self setEvblcEditCallback:editCallback];
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] addSubview:[self evtbvContainer]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[self evtbvContainer] evtbvContent] setContentInset:UIEdgeInsetsMake(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, 0, 0, 0)];
    
    [self _efReloadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (XLFStaticTableView *)evtbvContainer{
    
    if (!_evtbvContainer) {
        
        _evtbvContainer = [[XLFStaticTableView alloc] initWithStyle:UITableViewStylePlain];
    }
    return _evtbvContainer;
}

- (UIBarButtonItem *)evbbiSubmit{
    
    if (!_evbbiSubmit) {
        
        _evbbiSubmit = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(didClickSubmit:)];
    }
    return _evbbiSubmit;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtbvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)_efReloadTableView{
    
    NSMutableArray *etCellModels = [NSMutableArray array];
    
    XLFNormalCellModel *etCellModel = [[LFPortraitWebImageCellModel alloc] initWithImageUrl:[[self evUser] headImageUrl]
                                                                             temporaryImage:[self evUserPortrait]
                                                                           placeholderImage:[UIImage imageNamed:@"img_user_portrait_default"]
                                                                                  limitSize:CGSizeMake(60, 60)
                                                                                      title:@"头像"];
    [etCellModel setEvblcModelCallBack:[self didClickEditUserPortrait]];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"昵称" detailText:[[self evUser] nickname]];
    
    [etCellModel setEvblcModelCallBack:[self didClickEditNickname]];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"真实姓名" detailText:nstodefault([[self evUser] realname], @"未填写")];
    
    [etCellModel setEvblcModelCallBack:[self didClickEditRealname]];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"手机" detailText:nstodefault([[self evUser] telephone], @"未绑定")];
    
    [etCellModel setEvblcModelCallBack:[self didClickEditTelephone]];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"修改密码" detailText:nil];
    
    [etCellModel setEvblcModelCallBack:[self didClickEditPassword]];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModels addObject:etCellModel];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [[self evtbvContainer] setEvCellSectionModels:@[etSectionModel]];
    
    if ([self evModifyType]) {
        [self efSetBarButtonItem:[self evbbiSubmit] type:XLFNavButtonTypeRight];
    }
    else{
        [self efRemoveBarButtonItems:[self evRightBarItems] type:XLFNavButtonTypeRight];
    }
}

- (void)_efUploadHeadImage;{
    
    NSString *etContentType = @"image/jpeg";
    NSData *etImageData = UIImageJPEGRepresentation([self evUserPortrait], 0.1);
    if (!etImageData) {
        etContentType = @"image/png";
        etImageData = UIImagePNGRepresentation([self evUserPortrait]);
    }
    LFHttpRequest *etRequest = [self efUploadFileWithFileData:etImageData
                                                  contentType:etContentType
                                                         type:XLFFileTypeImage
                                                      success:[self _efUploadUserPortraitSuccessBlock]
                                                      failure:[self _efUploadUserPortraitFailedBlock]];
    
    [etRequest setHiddenLoadingView:NO];
    [etRequest setLoadingHintsText:@"正在上传图片，请稍后..."];
    [etRequest startAsynchronous];
}

- (XLFOnlyArrayResponseSuccessedBlock)_efUploadUserPortraitSuccessBlock{
    
    Weakself(ws);
    
    return ^(LFHttpRequest *request, id json, NSArray<NSDictionary *> *fileIds){
        
        NSString *etImageId = [[fileIds firstObject] objectForKey:@"imageId"];
        
        [[self evUser] setHeadImageUrl:egfImageUrl(etImageId, @"120x120", nil, nil, 100, 0, nil)];
        
        [ws _efUploadUserInfo];
    };
}

- (XLFFailedBlock)_efUploadUserPortraitFailedBlock{
    
    XLFFailedBlock failure = ^(XLFBaseHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain] afterDelay:1 inView:[self view]];
    };
    return failure;
}

- (BOOL)_efShouldUpload{
    
    return YES;
}

- (void)_efUploadUserInfo{
    
    LFHttpRequest* etRequest = [LFHttpRequestManager efModifyUserInfoWithUserId:[[self evUser] id]
                                                                     headImgUrl:[[self evUser] headImageUrl]
                                                                          email:[[self evUser] email]
                                                                       nickname:[[self evUser] nickname]
                                                                       realname:[[self evUser] realname]
                                                                      telephone:[[self evUser] telephone]
                                                                     modifyType:[self evModifyType]
                                                                        success:[self _efUploadSuccessBlock]
                                                                        failure:[self _efFailedBlock]];
    
    [etRequest setHiddenLoadingView:NO];
    [etRequest setLoadingHintsText:@"正在提交资料"];
    
    [etRequest startAsynchronous];
}

- (XLFNoneResultSuccessedBlock)_efUploadSuccessBlock{
    
    Weakself(ws);
    
    XLFNoneResultSuccessedBlock success = ^(LFHttpRequest *request){
        
        if ([ws evblcEditCallback]) {
            
            ws.evblcEditCallback(self, YES);
        }
    };
    
    return success;
}

- (XLFFailedBlock)_efFailedBlock{
    
    Weakself(ws);
    
    XLFFailedBlock failure = ^(XLFBaseHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain] afterDelay:1 inView:[self view]];
        
        ws.evblcEditCallback(self, NO);
    };
    return failure;
}

- (void)_efWantSelectPortrait{

    LFPortraitWebImageCell *etPortraitWebImageCell = [[[self evtbvContainer] evtbvContent] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIAlertController *etacSelectPortrait = [UIAlertController alertControllerWithTitle:@"请选择"
                                                                                message:nil
                                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *etaaSelectCamera = [UIAlertAction actionWithTitle:@"拍照"
                                                               style:UIAlertActionStyleDefault
                                                             handler:[self _efSelectCameraAction]];
    
    UIAlertAction *etaaSelectPhotoLibrary = [UIAlertAction actionWithTitle:@"相册"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:[self _efSelectPhotoLibraryAction]];
    
    UIAlertAction *etaaCancel = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
    
    [etacSelectPortrait addAction:etaaSelectCamera];
    [etacSelectPortrait addAction:etaaSelectPhotoLibrary];
    [etacSelectPortrait addAction:etaaCancel];
    
    UIPopoverPresentationController *etPopover = [etacSelectPortrait popoverPresentationController];
    if (etPopover){
        [etPopover setSourceView:[etPortraitWebImageCell evimgvWebImageContent]];
        [etPopover setSourceRect:[[etPortraitWebImageCell evimgvWebImageContent] bounds]];;
        [etPopover setPermittedArrowDirections:UIPopoverArrowDirectionAny];
    }
    
    [[self evVisibleViewController] presentViewController:etacSelectPortrait
                                                 animated:YES
                                               completion:nil];
}

- (void (^)(UIAlertAction *action))_efSelectCameraAction{
    
    Weakself(ws);
    return ^(UIAlertAction *action){
        
        [ws efShowCameraWithCaptureMode:UIImagePickerControllerCameraCaptureModePhoto
                            qualityType:UIImagePickerControllerQualityTypeHigh
                           cameraDevice:UIImagePickerControllerCameraDeviceRear
                        cameraFlashMode:UIImagePickerControllerCameraFlashModeOff
                          allowsEditing:YES
                               delegate:ws];
    };
}

- (void (^)(UIAlertAction *action))_efSelectPhotoLibraryAction{
    
    Weakself(ws);
    return ^(UIAlertAction *action){
        
        [ws efShowImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary
                              allowsEditing:YES
                                   delegate:ws];
    };
}

#pragma mark - actions

- (IBAction)didClickSubmit:(id)sender {
    
    if ([self _efShouldUpload]) {
        
        if ([self evUserPortrait]) {
            [self _efUploadHeadImage];
        }
        else{
            [self _efUploadUserInfo];
        }
    }
}

#pragma mark - tableview actions

- (void (^)(XLFNormalCellModel *model))didClickEditUserPortrait{
    
    Weakself(ws);
    return ^(XLFNormalCellModel *model){
        
        [ws _efWantSelectPortrait];
    };
}

- (void (^)(XLFNormalCellModel *model))didClickEditNickname{
    
    Weakself(ws);
    return ^(XLFNormalCellModel *model){
        
        LFTextEditVC *etTextEditVC = [[LFTextEditVC alloc] initWithTitle:@"昵称"
                                                         placeholderText:[[self evUser] nickname]
                                                        textEditCallback:[self _efNicknameEditCallback]];
        
        [[etTextEditVC evtxfInput] setTextLimitSize:15];
        [[ws navigationController] pushViewController:etTextEditVC animated:YES];
    };
}

- (void (^)(XLFNormalCellModel *model))didClickEditRealname{
    
    Weakself(ws);
    return ^(XLFNormalCellModel *model){
        
        LFTextEditVC *etTextEditVC = [[LFTextEditVC alloc] initWithTitle:@"真实姓名"
                                                         placeholderText:[[self evUser] realname]
                                                        textEditCallback:[self _efRealnameEditCallback]];
        
        [[etTextEditVC evtxfInput] setTextLimitSize:10];
        [[ws navigationController] pushViewController:etTextEditVC animated:YES];
    };
}

- (void (^)(XLFNormalCellModel *model))didClickEditTelephone{
    
    Weakself(ws);
    return ^(XLFNormalCellModel *model){
        
        if ([[[ws evUser] telephone] length]) {
            
            [ws _efWantUnbundingTelephone];
        }
        else{
            [ws _efUnbundingTelephone];
        }
    };
}

- (void (^)(XLFNormalCellModel *model))didClickEditPassword{
    
    Weakself(ws);
    
    return ^(XLFNormalCellModel *model){
        
        LFModifyPasswordVC *etModifyPasswordVC = [[LFModifyPasswordVC alloc] initWithModifyPasswordCallback:[self _efModifyPasswordCallback]];
        
        [[ws navigationController] pushViewController:etModifyPasswordVC animated:YES];
    };
}

- (void)_efWantUnbundingTelephone{
    
    UITableViewCell *etTelephoneCell = [[[self evtbvContainer] evtbvContent] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    UIAlertController *etacUnbundingTelephone = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要更换手机号码吗" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *etaaUnbunding = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:[self _efUnbundingTelephoneAction]];
    
    UIAlertAction *etaaCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [etacUnbundingTelephone addAction:etaaUnbunding];
    [etacUnbundingTelephone addAction:etaaCancel];
    
    UIPopoverPresentationController *etPopover = [etacUnbundingTelephone popoverPresentationController];
    if (etPopover){
        [etPopover setSourceView:etTelephoneCell];
        [etPopover setSourceRect:[etTelephoneCell bounds]];;
        [etPopover setPermittedArrowDirections:UIPopoverArrowDirectionAny];
    }
    
    [[self evVisibleViewController] presentViewController:etacUnbundingTelephone
                                                 animated:YES
                                               completion:nil];
}

- (void (^)(UIAlertAction * _Nonnull action))_efUnbundingTelephoneAction{
    
    Weakself(ws);
    return ^(UIAlertAction * _Nonnull action){
        
        [ws _efUnbundingTelephone];
    };
}

- (void)_efUnbundingTelephone{
    
    LFTelephoneEditVC *etTelephoneEditVC = [[LFTelephoneEditVC alloc] initWithTitle:@"手机号码"
                                                                    placeholderText:nil
                                                                   textEditCallback:[self _efTelephoneEditCallback]];
    
    [[self navigationController] pushViewController:etTelephoneEditVC animated:YES];
}

#pragma mark - LFTextEditVC

- (void (^)(LFTextEditVC *textEditVC, NSString *inputText))_efNicknameEditCallback{
    
    Weakself(ws);
    return ^(LFTextEditVC *textEditVC, NSString *inputText){
        
        if ([inputText length]) {
            
            [ws setEvModifyType:[self evModifyType] | LFModitfyUserInfoTypeNickname];
            
            [[ws evUser] setNickname:inputText];
            
            [ws _efReloadTableView];
            
            [textEditVC efBack];
        }
        else{
            [MBProgressHUD showWithStatus:@"昵称不可以为空"];
        }
    };
}

- (void (^)(LFTextEditVC *textEditVC, NSString *inputText))_efRealnameEditCallback{
    
    Weakself(ws);
    return ^(LFTextEditVC *textEditVC, NSString *inputText){
        
        if ([inputText length]) {
            
            [ws setEvModifyType:[self evModifyType] | LFModitfyUserInfoTypeRealname];
            
            [[ws evUser] setRealname:inputText];
            
            [ws _efReloadTableView];
            
            [textEditVC efBack];
        }
        else{
            
            [MBProgressHUD showWithStatus:@"真实不可以为空"];
        }
    };
}

- (void (^)(LFTextEditVC *textEditVC, NSString *inputText))_efTelephoneEditCallback{
    
    Weakself(ws);
    return ^(LFTextEditVC *textEditVC, NSString *inputText){
        
        [ws setEvModifyType:[self evModifyType] | LFModitfyUserInfoTypeTelephone];
        
        [[ws evUser] setTelephone:inputText];
        
        [ws _efReloadTableView];
        
        [textEditVC efBack];
    };
}

- (void (^)(LFModifyPasswordVC *modifyPasswordVC, BOOL success))_efModifyPasswordCallback{
    
    return ^(LFModifyPasswordVC *modifyPasswordVC, BOOL success){
        
        if (success) {
            
            [modifyPasswordVC  efBack];
        }
    };
}

#pragma mark - UIImagePickerControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;{
    
    [navigationController copyNavigationBarStyle:[self navigationController]];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;{
    
    [navigationController copyNavigationBarStyle:[self navigationController]];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;{
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self setEvUserPortrait:[selectedImage scaleToSize:CGSizeMake(300, 300) stretch:NO]];
    
    [self setEvModifyType:[self evModifyType] | LFModitfyUserInfoTypeHeadImage];
    
    [self _efReloadTableView];
    
    Weakself(ws);
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [ws _efReloadTableView];
    }];
}

@end
