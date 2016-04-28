//
//  LFLostDetailVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFLostDetailVC.h"

#import "LFUserInfoCell.h"

#import "LFLocationDistributeVC.h"

@interface LFLostDetailVC ()

@property(nonatomic, copy  ) void (^evCloseLostCallback)(LFLostDetailVC *lostDetailVC);

@end

@implementation LFLostDetailVC

- (instancetype)initWithLost:(LFLost *)lost closeLostCallback:(void (^)(LFLostDetailVC *lostDetailVC))closeLostCallback;{
    self = [super initWithNotice:lost];
    if (self) {
        
        [self setTitle:@"寻物启事"];
        
        [self setEvCloseLostCallback:closeLostCallback];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _efLoadLostDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (LFLost *)evLost{
    
    return (LFLost *)[self evNotice];
}

#pragma mark - public

- (void)efNoticeDidClose{
    
    if ([self evCloseLostCallback]) {
        self.evCloseLostCallback(self);
    }
    
    [self efBack];
}

- (void)efReloadTableData{
    
    NSMutableArray *etSectionModels = [NSMutableArray array];
    
    NSMutableArray *etCellModels = [NSMutableArray array];
    
    XLFNormalCellModel *etCellModel = [[LFWebImageCellModel alloc] initWithImageUrl:[[[self evLost] user] headImageUrl]
                                                                     temporaryImage:nil
                                                                   placeholderImage:[UIImage imageNamed:@"img_user_portrait_default"]
                                                                          limitSize:CGSizeMake(50, 50)
                                                                              title:[[[self evLost] user] nickname]];
    
    [etCellModel setEvHeight:60];
    [etCellModel setEvCellClass:[LFUserInfoCell class]];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFTextCellModel alloc] initWithTitle:[[self evLost] title]];
    [etCellModel setEvTitleNumberOfLines:NSIntegerMax];
    [etCellModel setEvTitleColor:[UIColor darkGrayColor]];
    [etCellModel setEvTitleFont:[UIFont systemFontOfSize:13]];
    [etCellModel setEvTitleLineBreakMode:NSLineBreakByCharWrapping];
    [etCellModels addObject:etCellModel];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"丢失"
                                                 detailText:[[[self evLost] happenTimeDate] normalizeDateTimeString]];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"发布"
                                                 detailText:[[[self evLost] timeDate] normalizeDateTimeString]];
    [etCellModels addObject:etCellModel];
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModel setEvHeaderTitle:@"时间"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"主要地点"
                                                 detailText:fmts(@"%@(%@)", [[[self evLost] location] address], [[[self evLost] location] name])];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvblcModelCallBack:[self _efClickLocationCallback]];
    [etCellModels addObject:etCellModel];
    
    if ([[[self evLost] locations] count]) {
        
        etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"可能地点"
                                                     detailText:fmts(@"%d 个", [[[self evLost] locations] count])];
        [etCellModels addObject:etCellModel];
    }
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"距离"
                                                 detailText:[LFConstants distanceDescription:[[self evLost] distance]]];
    [etCellModels addObject:etCellModel];
    
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModel setEvHeaderTitle:@"地点"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etSectionModels addObject:etSectionModel];
    
    [[self evtbvContainer] setEvCellSectionModels:etSectionModels];
    
    [[self evtlbBottomBar] setHidden:[[self evLost] state] != LFNoticeStateNew];
    [[self evbbiConfrim] setTitle:select([[[self evLost] user] isLocalUser], @"我已找回", @"我来帮你")];
}

- (LFContactInfoVC *)efContactInfoViewControllerFromContactInfo:(LFUser *)contactInfo;{
    
    return [[LFContactInfoVC alloc] initWithTitle:@"失主信息" contactInfo:contactInfo];
}

#pragma mark - private

- (void)_efLoadLostDetail{
    
    LFHttpRequest *etreqLoadLostDetail = [self efGetLostDetailWithLostId:[[self evLost] id]
                                                                 success:[self _efLoadLostDetailSuccess]
                                                                 failure:[self _efLoadLostDetailFailed]];
    
    [etreqLoadLostDetail startAsynchronous];
}

- (LFGetLostDetailSuccessedBlock)_efLoadLostDetailSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request, id json, LFLost *lost){
        
        [[ws evLost] setAttributes:[json firstObject]];
        
        [ws _efLoadLostDetailEnd];
    };
}

- (XLFFailedBlock)_efLoadLostDetailFailed{
    
    return ^(LFHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efLoadLostDetailEnd{
    
    [self efReloadAllData];
}

#pragma mark - XLFStaticTableView action callback

- (void (^)(XLFNormalCellModel* model))_efClickLocationCallback{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFLocationDistributeVC *etLocationDistributeVC = [[LFLocationDistributeVC alloc] initWithTitle:@"主要地点"
                                                                                              location:[[ws evLost] location]
                                                                                             locations:[[ws evLost] locations]];
        
        [[ws navigationController] pushViewController:etLocationDistributeVC animated:YES];
    };
}

@end
