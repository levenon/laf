//
//  LFUserCenterVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/13.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFUserCenterVC.h"
#import "LFLoginVC.h"

#import "LFEditUserInfoVC.h"
#import "LFMyLostsVC.h"
#import "LFMyFoundsVC.h"
#import "LFSettingVC.h"
#import "LFAboutVC.h"

#import "LFUserInfoHeaderView.h"

#import "LFUserManager.h"
#import "LFShareManager.h"
#import "LFAppManager.h"

@interface LFUserCenterVC ()<LFHttpRequestManagerProtocol>

@property(nonatomic, strong) XLFStaticTableView *evtbvContainer;

@property(nonatomic, strong) LFUserInfoHeaderView *evvUserInfo;

@property(nonatomic, strong) UIButton *evbtnExchangeLoginState;

@end

@implementation LFUserCenterVC

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
        [self setTitle:@"用户中心"];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:[self evtbvContainer]];
    
    [[[self evtbvContainer] evtbvContent] setTableHeaderView:[self evvUserInfo]];
    [[[self evtbvContainer] evtbvContent] setTableFooterView:[self evbtnExchangeLoginState]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [[[self evtbvContainer] evtbvContent] setContentInset:UIEdgeInsetsMake(NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT, 0, 0, 0)];
    
    [self efRefresh];
}

#pragma mark - accessory

- (XLFStaticTableView *)evtbvContainer{
    
    if (!_evtbvContainer) {
        
        _evtbvContainer = [[XLFStaticTableView alloc] initWithStyle:UITableViewStyleGrouped];
        [_evtbvContainer setBackgroundColor:[UIColor clearColor]];
        [[_evtbvContainer evtbvContent] setBackgroundColor:[UIColor clearColor]];
        [[_evtbvContainer evtbvContent] setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10)];
        [[_evtbvContainer evtbvContent] setSeparatorColor:[UIColor colorWithHexRGB:0x999999 alpha:0.3]];
    }
    return _evtbvContainer;
}

- (LFUserInfoHeaderView *)evvUserInfo{
    
    if (!_evvUserInfo) {
        
        _evvUserInfo = [LFUserInfoHeaderView emptyFrameView];
        [_evvUserInfo addTarget:self action:@selector(didClickEditUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evvUserInfo;
}

- (UIButton *)evbtnExchangeLoginState{
    
    if (!_evbtnExchangeLoginState) {
        
        _evbtnExchangeLoginState = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [_evbtnExchangeLoginState setTitleColor:[UIColor colorWithRed:1.0 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
        [_evbtnExchangeLoginState addTarget:self action:@selector(didClickExchangeLoginState:) forControlEvents:UIControlEventTouchUpInside];
        [[_evbtnExchangeLoginState titleLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    }
    return _evbtnExchangeLoginState;
}

#pragma mark - private

- (void)_efReloadData{
    
    LFUser *etLocalUser = [[LFUserManager shareManager] evLocalUser];
    NSMutableArray *etCellModels = [NSMutableArray array];
    
    XLFNormalCellModel *etCellModel = nil;
    
    if ([LFUserManagerRef evIsLogin]) {
        
        etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"失" detailText:itos([etLocalUser lostsCount])];
        [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [etCellModel setEvBackgroundColor:[UIColor clearColor]];
        [etCellModel setEvContentColor:[UIColor clearColor]];
        [etCellModel setEvTitleColor:[UIColor whiteColor]];
        [etCellModel setEvblcModelCallBack:[self _efDidClickMyLosts]];
        [etCellModels addObject:etCellModel];
        
        etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"得" detailText:itos([etLocalUser foundsCount])];
        [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [etCellModel setEvBackgroundColor:[UIColor clearColor]];
        [etCellModel setEvContentColor:[UIColor clearColor]];
        [etCellModel setEvTitleColor:[UIColor whiteColor]];
        [etCellModel setEvblcModelCallBack:[self _efDidClickMyFounds]];
        [etCellModels addObject:etCellModel];
    }
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"设置" detailText:nil];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvBackgroundColor:[UIColor clearColor]];
    [etCellModel setEvContentColor:[UIColor clearColor]];
    [etCellModel setEvTitleColor:[UIColor whiteColor]];
    [etCellModel setEvblcModelCallBack:[self _efDidClickSetting]];
    [etCellModels addObject:etCellModel];
    
    //    if ([WXApi isWXAppInstalled] || [TencentOAuth iphoneQQInstalled] ||
    //        [TencentOAuth iphoneQZoneInstalled] || [WeiboSDK isWeiboAppInstalled]) {
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"分享" detailText:nil];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvBackgroundColor:[UIColor clearColor]];
    [etCellModel setEvContentColor:[UIColor clearColor]];
    [etCellModel setEvTitleColor:[UIColor whiteColor]];
    [etCellModel setEvblcModelCallBack:[self _efDidClickShare]];
    [etCellModels addObject:etCellModel];
    //    }
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"关于" detailText:nil];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvBackgroundColor:[UIColor clearColor]];
    [etCellModel setEvContentColor:[UIColor clearColor]];
    [etCellModel setEvTitleColor:[UIColor whiteColor]];
    [etCellModel setEvblcModelCallBack:[self _efDidClickAbout]];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"赞一个" detailText:nil];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvBackgroundColor:[UIColor clearColor]];
    [etCellModel setEvContentColor:[UIColor clearColor]];
    [etCellModel setEvTitleColor:[UIColor whiteColor]];
    [etCellModel setEvblcModelCallBack:[self _efDidClickPraise]];
    [etCellModels addObject:etCellModel];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [[self evtbvContainer] setEvCellSectionModels:@[etSectionModel]];
    
    [[self evvUserInfo] setEvUser:[[LFUserManager shareManager] evLocalUser]];
    [[self evbtnExchangeLoginState] setTitle:select([[LFUserManager shareManager] evIsLogin], @"退出当前账号", @"登录")
                                    forState:UIControlStateNormal];
}

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtbvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - notifications

- (void)efRegisterNotification{
    [super efRegisterNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateRefresh:) name:kUserInfoLoadSuccessNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateRefresh:) name:kUserLogoutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateRefresh:) name:kUserLoginNotification object:nil];
}

- (void)efRefresh{
    [super efRefresh];
    
    [self _efReloadData];
}

#pragma mark - tableview actions

- (void(^)(XLFNormalCellModel* model))_efDidClickMyLosts{
    
    Weakself(ws);
    
    return ^(XLFNormalCellModel* model){
        
        LFMyLostsVC *etMyLostsVC = [[LFMyLostsVC alloc] init];
        
        [[[[ws menu] evVisibleViewController] navigationController] pushViewController:etMyLostsVC animated:YES];
    };
}

- (void(^)(XLFNormalCellModel* model))_efDidClickMyFounds{
    
    Weakself(ws);
    
    return ^(XLFNormalCellModel* model){
        
        LFMyFoundsVC *etMyFoundsVC = [[LFMyFoundsVC alloc] init];
        
        [[[[ws menu] evVisibleViewController] navigationController] pushViewController:etMyFoundsVC animated:YES];
    };
}

- (void(^)(XLFNormalCellModel* model))_efDidClickSetting{
    
    Weakself(ws);
    
    return ^(XLFNormalCellModel* model){
        
        LFSettingVC *etSettingVC = [LFSettingVC viewController];
        
        [[[[ws menu] evVisibleViewController] navigationController] pushViewController:etSettingVC animated:YES];
    };
}

- (void(^)(XLFNormalCellModel* model))_efDidClickShare{
    
    return ^(XLFNormalCellModel* model){
        
        LFShareInfo *etShareInfo = [[LFShareInfo alloc] initWithTitle:egAppShareTitle
                                                              content:egAppShareText
                                                             imageUrl:egAppIconUrl
                                                                image:[UIImage imageNamed:@"AppIcon"]
                                                                  url:egRedirectUrl];
        
        [LFShareManager efShareInfo:etShareInfo];
    };
}

- (void(^)(XLFNormalCellModel* model))_efDidClickAbout{
    
    Weakself(ws);
    
    return ^(XLFNormalCellModel* model){
        
        LFAboutVC *etAboutVC = [LFAboutVC viewController];
        
        [[[[ws menu] evVisibleViewController] navigationController] pushViewController:etAboutVC animated:YES];
    };
}

- (void(^)(XLFNormalCellModel* model))_efDidClickPraise{
    
    return ^(XLFNormalCellModel* model){
        
        [LFAppManager efCommentApplication];
    };
}

#pragma mark - actions

- (IBAction)didNotificateRefresh:(NSNotification*)sender{
    
    [self efRefresh];
}

- (IBAction)didClickEditUserInfo:(id)sender{
    
    if ([LFUserManagerRef evIsLogin]) {
        
        LFEditUserInfoVC *etEditUserInfoVC = [[LFEditUserInfoVC alloc] initWithUser:[LFUserManagerRef evLocalUser]
                                                                       editCallback:[self _efEditUserInfoCallback]];
        
        [[[[self menu] evVisibleViewController] navigationController] pushViewController:etEditUserInfoVC animated:YES];
    }
    else{
        
        [LFUserManager efLogin];
    }
}

- (IBAction)didClickExchangeLoginState:(id)sender{
    
    if ([[LFUserManager shareManager] evIsLogin]) {
        
        [LFUserManager efLogoutOnServer];
    }
    else {
        
        [LFUserManager efLogin];
    }
    
    [[self menu] close];
}

#pragma mark - LFEditUserInfoVC callback

- (void (^)(LFEditUserInfoVC *editUserInfoVC, BOOL success))_efEditUserInfoCallback{
    
    Weakself(ws);
    return ^(LFEditUserInfoVC *editUserInfoVC, BOOL success){
        
        if (success) {
            
            [LFUserManager efUpdateUser:[[editUserInfoVC evUser] mutableCopy]];
            [[ws evvUserInfo] setEvUser:[[editUserInfoVC evUser] mutableCopy]];
            
            [editUserInfoVC efBack];
        }
    };
}

@end
