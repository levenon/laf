//
//  LFSettingVC.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-14.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFSettingVC.h"
#import "LFAppManager.h"

@interface LFSettingVC ()

@property(nonatomic, strong) XLFStaticTableView *evtbvContainer;

@end

@implementation LFSettingVC

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self setTitle:@"设置"];
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
    // Do any additional setup after loading the view.
    
    [[[self evtbvContainer] evtbvContent] setContentInset:UIEdgeInsetsMake(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, 0, 0, 0)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self efRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)efRefresh{
    
    [self _efReloadTableView];
}

#pragma mark - accessory

- (XLFStaticTableView *)evtbvContainer{
    
    if (!_evtbvContainer) {
        
        _evtbvContainer = [[XLFStaticTableView alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _evtbvContainer;
}

#pragma mark - private

- (void)_efReloadTableView{
    
    [[self evtbvContainer] efRemoveAll];
    
    UIUserNotificationSettings *etUserNotificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    NSMutableArray *etTableViewSectionModels = [NSMutableArray array];
    
//    LFSystemSetting *etSystemSetting = [[LFAppManager sharedInstance] evSetting];
    
    XLFNormalCellModel *etNotificationCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"通知"
                                                                                   subTitle:[LFConstants userNotificationTypeDescription:[etUserNotificationSettings types]]
                                                                                      style:UITableViewCellStyleValue1
                                                                                     target:self
                                                                                     action:@selector(didClickNotification:)];
    
//    XLFNormalCellModel *etVoiceCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"声音"
//                                                                            subTitle:nil
//                                                                               style:UITableViewCellStyleValue1
//                                                                              target:self
//                                                                              action:@selector(didVoiceAllowChanged:)];
//    [etVoiceCellModel setEvCellClass:[XLFSwitchCell class]];
//    [etVoiceCellModel setEvUserInfo:iton([etSystemSetting allowVoice])];
//    
//    XLFNormalCellModel *etShakeCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"震动"subTitle:nil
//                                                                               style:UITableViewCellStyleValue1
//                                                                              target:self
//                                                                              action:@selector(didShakeAllowChanged:)];
//    [etShakeCellModel setEvCellClass:[XLFSwitchCell class]];
//    [etShakeCellModel setEvUserInfo:iton([etSystemSetting allowShake])];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:@[etNotificationCellModel]];
    [etSectionModel setEvHeaderTitle:@"提示"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etTableViewSectionModels addObject:etSectionModel];
    
    XLFNormalCellModel *etVersion = [[XLFNormalCellModel alloc] initWithTitle:@"版本"
                                                                   detailText:[NSBundle appVersion]];
    
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:@[etVersion]];
    [etSectionModel setEvHeaderTitle:@"其他"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etTableViewSectionModels addObject:etSectionModel];
    
    [[self evtbvContainer] setEvCellSectionModels:etTableViewSectionModels];
}

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtbvContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - actions

- (IBAction)didClickNotification:(id)sender{
    
    UIUserNotificationSettings *etUserNotificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if (!([etUserNotificationSettings types] & 0x7)) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (IBAction)didVoiceAllowChanged:(XLFNormalCellModel *)sender{
    
    [[[LFAppManager sharedInstance] evSetting] setAllowVoice:[[sender evUserInfo] boolValue]];
}

- (IBAction)didShakeAllowChanged:(id)sender{
    
    [[[LFAppManager sharedInstance] evSetting] setAllowShake:[[sender evUserInfo] boolValue]];
}

@end
