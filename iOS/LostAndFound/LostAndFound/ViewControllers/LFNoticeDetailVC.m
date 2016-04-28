//
//  LFNoticeDetailVC.m
//  NoticeAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFNoticeDetailVC.h"

#import "LFImageView.h"

#import "LFLocationDistributeVC.h"

#import "LFUserInfoCell.h"

#import "LFPhotoBrowserVC.h"

#import "LFContactInfoVC.h"

#import "LFShareManager.h"

#import "LFLocationManager.h"

@interface LFNoticeDetailVC ()<iCarouselDelegate, iCarouselDataSource, LFPhotoBrowserDelegate>

@property(nonatomic, strong) LFNotice *evNotice;

@property(nonatomic, strong) LFUser *evContactInfo;

@property(nonatomic, strong) XLFStaticTableView *evtbvContainer;

@property(nonatomic, strong) iCarousel *evvImageContainer;

@property(nonatomic, strong) UIToolbar *evtlbBottomBar;

@property(nonatomic, strong) UIBarButtonItem *evbbiShare;

@property(nonatomic, strong) UIBarButtonItem *evbbiConfrim;

@end

@implementation LFNoticeDetailVC

- (instancetype)initWithNotice:(LFNotice *)notice;{
    self = [super init];
    if (self) {
        
        [notice setImages:@[[[notice image] copy]]];
        
        [self setEvNotice:notice];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiShare] type:XLFNavButtonTypeRight];
    [[self view] addSubview:[self evtbvContainer]];
    [[self view] addSubview:[self evtlbBottomBar]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[self evtbvContainer] evtbvContent] setTableHeaderView:[self evvImageContainer]];
    [[[self evtbvContainer] evtbvContent] setContentInset:UIEdgeInsetsMake(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, 0, 44, 0)];
    
    [self efReloadTableData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (LFNotice *)evNotice{
    
    if (!_evNotice) {
        
        _evNotice = [LFNotice model];
    }
    return _evNotice;
}

- (iCarousel *)evvImageContainer{
    
    if (!_evvImageContainer) {
        
        _evvImageContainer = [[iCarousel alloc] initWithFrame:CGRectMakePS(CGPointZero, CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH * 0.6))];
        
        [_evvImageContainer setDelegate:self];
        [_evvImageContainer setDataSource:self];
        [_evvImageContainer setType:iCarouselTypeLinear];
    }
    return _evvImageContainer;
}

- (XLFStaticTableView *)evtbvContainer{
    
    if (!_evtbvContainer) {
        
        _evtbvContainer = [[XLFStaticTableView alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _evtbvContainer;
}

- (UIBarButtonItem *)evbbiShare{
    
    if (!_evbbiShare) {
        
        _evbbiShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didCLickShare:)];
    }
    return _evbbiShare;
}

- (UIToolbar *)evtlbBottomBar{
    
    if (!_evtlbBottomBar) {
        
        _evtlbBottomBar = [UIToolbar emptyFrameView];
        [_evtlbBottomBar setHidden:YES];
        [_evtlbBottomBar setTranslucent:YES];
        [_evtlbBottomBar setTintColor:[UIColor whiteColor]];
        [_evtlbBottomBar setBarTintColor:[UIColor colorWithWhite:0.1 alpha:0.9]];
        
        UIBarButtonItem *etFirstFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *etLastFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [_evtlbBottomBar setItems:@[etFirstFlexibleSpace, [self evbbiConfrim], etLastFlexibleSpace]];
    }
    return _evtlbBottomBar;
}

- (UIBarButtonItem *)evbbiConfrim{
    
    if (!_evbbiConfrim) {
        
        _evbbiConfrim = [[UIBarButtonItem alloc] initWithTitle:@"我来帮你"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(didClickConfirm:)];
    }
    return _evbbiConfrim;
}

#pragma mark - public

- (void)efRegisterNotification{
    [super efRegisterNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateUserLogin:) name:kUserLoginNotification object:nil];
}


#pragma mark - protected

- (void)efReloadTableData{
    
}

- (void)efReloadCarouseData;{
    
    [[self evvImageContainer] reloadData];
}

- (void)efReloadAllData;{
    
    Weakself(ws);
    [self _efCaculateDistanceWithNotice:[self evNotice] completion:^{
        
        [ws efReloadTableData];
    }];
    
    [self efReloadCarouseData];
}

- (void)efNoticeDidClose{
    
}

- (LFContactInfoVC *)efContactInfoViewControllerFromContactInfo:(LFUser *)contactInfo;{
 
    return nil;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtbvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
    
    [[self evtlbBottomBar] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evtbvContainer.mas_left).offset(0);
        make.right.equalTo(ws.evtbvContainer.mas_right).offset(0);
        make.bottom.equalTo(ws.evtbvContainer.mas_bottom).offset(0);
    }];
}

- (void)_efCaculateDistanceWithNotice:(LFNotice *)notice completion:(void (^)())completion{
    
    [[LFLocationManager shareLocationManager] efAddLocationWithTag:NSStringFromClass([self class])
                                                          callback:^(BMKUserLocation * userLocation, NSError * error)
     {
         CLLocationCoordinate2D etUserCoordinate = [[userLocation location] coordinate];
         
         CLLocationDistance etDistance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate([[notice location] coordinate]),
                                                                   BMKMapPointForCoordinate(etUserCoordinate));
         
         [notice setDistance:etDistance];
         if (completion) {
             completion();
         }
     }];
}

- (void)_efCloseNotice{
    
    LFHttpRequest *etreqCloseNotice = [self efCloseNoticeWithNoiticeId:[[self evNotice] id]
                                                             success:[self _efCloseNoticeSuccess]
                                                             failure:[self _efCloseNoticeFailed]];
    
    [etreqCloseNotice setHiddenLoadingView:NO];
    [etreqCloseNotice setLoadingHintsText:@"正在关闭告示..."];
    [etreqCloseNotice startAsynchronous];
}

- (XLFSuccessedBlock)_efCloseNoticeSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request, id result){
        
        [[ws evNotice] setState:LFNoticeStateClose];
        [ws _efCloseNoticeEnd];
    };
}

- (XLFFailedBlock)_efCloseNoticeFailed{
    
    return ^(LFHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efCloseNoticeEnd{
    
    [self efNoticeDidClose];
}

- (void)_efContactNoticePublisher{
    
    LFHttpRequest *etreqHelpNoticeer = [self efContactNoticePublisherWithNoticeId:[[self evNotice] id]
                                                                          success:[self _efContactNoticePublisherSuccess]
                                                                          failure:[self _efContactNoticePublisherFailed]];
    
    [etreqHelpNoticeer setHiddenLoadingView:NO];
    [etreqHelpNoticeer setLoadingHintsText:@"正在和帖主取得联系..."];
    [etreqHelpNoticeer startAsynchronous];
}

- (LFUserSuccessedBlock)_efContactNoticePublisherSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request, id json, LFUser *user/* LFUser */){
        
        [[[ws evNotice] user] setAttributes:[user dictionary]];
        
        [ws setEvContactInfo:user];
        [ws _efContactNoticePublisherWithContactInfo:user];
    };
}

- (XLFFailedBlock)_efContactNoticePublisherFailed{
    
    return ^(LFHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efContactNoticePublisherWithContactInfo:(LFUser *)contactInfo{
    
    LFContactInfoVC *etContactInfoVC = [self efContactInfoViewControllerFromContactInfo:contactInfo];
    
    if (etContactInfoVC) {
        
        [[self navigationController] pushViewController:etContactInfoVC animated:YES];
    }
}

#pragma mark - public

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context)
     {
         [[self evvImageContainer] reloadData];
         [[self evvImageContainer] scrollToItemAtIndex:[[self evvImageContainer] currentItemIndex] animated:NO];
         
     }                            completion:nil];
}

#pragma mark - iCarouselDataSource and iCarouselDelegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel;{
    
    return [[[self evNotice] images] count];
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel;{
    
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel;{
    
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(LFImageView *)imageView;{
    
    LFImage *etImage = [[[self evNotice] images] objectAtIndex:index];
    
    if (!imageView || ![imageView isKindOfClass:[LFImageView class]]) {
        imageView = [[LFImageView alloc] initWithFrame:[carousel bounds]];
    }
    
    [imageView setFrame:[carousel bounds]];
    [imageView setEvImage:etImage];
    
    return imageView;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel;{
    
    return CGRectGetWidth([carousel bounds]);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;{
    
    LFPhotoBrowserVC *etPhotoBrowserVC = [[LFPhotoBrowserVC alloc] initWithDelegate:self photos:[[self evNotice] images] defaultIndex:index];
    
    [[self navigationController] pushViewController:etPhotoBrowserVC animated:YES];
}

- (void)epPhotoBrowserVC:(LFPhotoBrowserVC *)photoBrowserVC didSelectedIndex:(NSInteger)selectedIndex;{
    
    [[self evvImageContainer] scrollToItemAtIndex:selectedIndex animated:NO];
}

#pragma mark - actions

- (IBAction)didCLickShare:(id)sender{
    
    LFShareInfo *etShareInfo = [[LFShareInfo alloc] initWithTitle:[self title]
                                                          content:ntoe([[self evNotice] title])
                                                         imageUrl:ntoe(egfImageUrl([[[self evNotice] image] remoteId], @"!120x120r", nil, @"120x120", 100, 0, nil))
                                                            image:[UIImage imageNamed:@"img_appicon"]
                                                              url:ntoe([[self evNotice] url])];
    [LFShareManager efShareInfo:etShareInfo];
}

- (IBAction)didClickConfirm:(id)sender{
    
    if ([LFUserManagerRef evIsLogin]) {
        
        if ([[[self evNotice] user] isLocalUser]) {
            
            [self _efCloseNotice];
        }
        else{
            
            if ([self evContactInfo]) {
                
                [self _efContactNoticePublisherWithContactInfo:[self evContactInfo]];
            }
            else{
                
                [self _efContactNoticePublisher];
            }
        }
    }
    else{
        
        [LFUserManager efLogin];
    }
}

- (IBAction)didNotificateUserLogin:(id)sender{
    
    [self efReloadTableData];
}

@end
