//
//  LFCreateNoticeVC.m
//  NoticeAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFCreateNoticeVC.h"

#import "LFEditableNotice.h"

#import "LFImageView.h"

#import "LFLocationDistributeVC.h"

#import "LFPhotoBrowserVC.h"

@interface LFCreateNoticeVC ()

@property(nonatomic, copy) void (^evCreatNoticeCallback)(LFCreateNoticeVC *createNoticeVC, LFNotice *notice);

@property(nonatomic, assign) id<LFCreateNoticeDelegate> evDelegate;

@property(nonatomic, strong) XLFStaticTableView *evtbvContainer;

@property(nonatomic, strong) LFCreateNoticeHeaderView *evvHeader;

@property(nonatomic, strong) UIBarButtonItem *evbbiDistribute;

@property(nonatomic, assign) BOOL evImageHasUplaod;

@property(nonatomic, strong) XLFNormalCellModel *evCategoryCellModel;
@property(nonatomic, strong) XLFNormalCellModel *evHappenTimeCellModel;
@property(nonatomic, strong) XLFNormalCellModel *evMainLocationCellModel;

@end

@implementation LFCreateNoticeVC

- (instancetype)initWithCallback:(void (^)(LFCreateNoticeVC *createNoticeVC, LFNotice *notice))creatNoticeCallback;{
    self = [self init];
    
    if (self) {
        [self setEvCreatNoticeCallback:creatNoticeCallback];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<LFCreateNoticeDelegate>)delegate;{
    self = [self init];
    
    if (self) {
        [self setEvDelegate:delegate];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
        [self setTitle:@"发布"];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiDistribute] type:XLFNavButtonTypeRight];
    
    [[self view] addSubview:[self evtbvContainer]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[self evtbvContainer] evtbvContent] setTableHeaderView:[self evvHeader]];
    [[[self evtbvContainer] evtbvContent] setContentInset:UIEdgeInsetsMake(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, 0, 80, 0)];
    
    [self efReloadTableData];
}

#pragma mark - accessory

- (UIBarButtonItem *)evbbiDistribute{
    
    if (!_evbbiDistribute) {
        
        _evbbiDistribute = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(didClickDistribute:)];
    }
    return _evbbiDistribute;
}

- (XLFStaticTableView *)evtbvContainer{
    
    if (!_evtbvContainer) {
        
        _evtbvContainer = [[XLFStaticTableView alloc] initWithStyle:UITableViewStyleGrouped];
        [_evtbvContainer setEvDelegate:self];
    }
    return _evtbvContainer;
}

- (LFCreateNoticeHeaderView *)evvHeader{
    
    if (!_evvHeader) {
        
        _evvHeader = [LFCreateNoticeHeaderView emptyFrameView];
    }
    return _evvHeader;
}

#pragma mark - public

- (void)efReloadTableData{
    
}


- (BOOL)efShouldCreateNotice{
    
    return YES;
}

- (void)efCreateNotice;{
    
}

- (void)efNoticeDidCreated{
    
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epCreateNoticeVC:didSuccessCreateNotice:)]) {
        
        [[self evDelegate] epCreateNoticeVC:self didSuccessCreateNotice:[[self evNotice] notice]];
    }
    else if ([self evCreatNoticeCallback]) {
        
        self.evCreatNoticeCallback(self, [[self evNotice] notice]);
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtbvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (BOOL)_efShouldUploadImages{
    
    return [[[self evNotice] images] count] > 0;
}

- (void)_efUploadImages{
    
    NSMutableArray *etFileDatas = [NSMutableArray array];
    
    for (LFPhoto *photo in [[self evNotice] images]) {
        
        NSString *etContentType = @"image/jpeg";
        NSData *etImageData = UIImageJPEGRepresentation([photo image], 0.1);
        
        if (!etImageData) {
            etContentType = @"image/png";
            etImageData = UIImagePNGRepresentation([photo image]);
        }
        
        if (!etImageData) {
            return;
        }
        
        [etFileDatas addObject:[XLFUploadFile uploadFileWithFileData:etImageData fileName:nil contentType:etContentType type:XLFFileTypeImage]];
    }
    
    LFHttpRequest *etreqUploadImages = [self efUploadFilesWithFileDatas:etFileDatas
                                                                success:[self _efUploadImagesSuccess]
                                                                failure:[self _efUploadImagesFailed]];
    
    [etreqUploadImages setHiddenLoadingView:NO];
    [etreqUploadImages setLoadingHintsText:@"正在上传图片"];
    [etreqUploadImages startAsynchronous];
}

- (XLFOnlyArrayResponseSuccessedBlock)_efUploadImagesSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request, id result, NSArray<NSDictionary *> *fileIds){
        
        if (fileIds && [fileIds isKindOfClass:[NSArray class]] && [fileIds count]) {
            
            [[[ws evNotice] images] enumerateObjectsUsingBlock:^(LFPhoto * _Nonnull photo, NSUInteger nIndex, BOOL * _Nonnull stop) {
                
                NSDictionary *fileIdSet = [fileIds objectAtIndex:nIndex];
                
                if ([fileIdSet isKindOfClass:[NSDictionary class]]) {
                    [photo setRemoteId:[[fileIdSet objectForKey:@"imageId"] stringValue]];
                }
            }];
            
            [ws setEvImageHasUplaod:YES];
            
            [[[ws evNotice] images] addObjectsFromArray:[[ws evNotice] remoteImages]];
        }
        
        [ws efCreateNotice];
    };
}

- (XLFFailedBlock)_efUploadImagesFailed{
    
    return ^(LFHttpRequest *request, NSError *error) {
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efUploadImagesEnd{
    
    [self efCreateNotice];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    return @"删除";
}

#pragma mark - LFCategorySelectorVCDelegate

- (void)epCategorySelectorVC:(LFCategorySelectorVC *)categorySelectorVC didSelectedCategory:(LFCategory *)category;{
    
    [[self evNotice] setCategory:category];
    [[self evCategoryCellModel] setEvSubTitle:[category name]];
    [[self evtbvContainer] efReloadCellAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    
    [[categorySelectorVC navigationController] popViewControllerAnimated:YES];
}

#pragma mark - XLFDatePickerViewDelegate

- (void)epTimePickerView:(LFTimePickerView *)timePickerView didPickDateTime:(NSDate*)date;{
    
    [[self evNotice] setHappenTimeDate:date];
    [[self evHappenTimeCellModel] setEvSubTitle:[[[self evNotice] happenTimeDate] normalizeDateTimeString]];
    [[self evtbvContainer] efReloadCellAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
}

#pragma mark - actions

- (IBAction)didClickDistribute:(id)sender{
    
    if ([self efShouldCreateNotice]) {
        
        if ([self _efShouldUploadImages] && ![self evImageHasUplaod]) {
            
            [self _efUploadImages];
        }
        else{
            
            [self efCreateNotice];
        }
    }
}

@end
