//
//  LFFoundDetailVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFFoundDetailVC.h"

#import "LFImageView.h"

#import "LFLocationDistributeVC.h"

#import "LFUserInfoCell.h"

#import "LFPhotoBrowserVC.h"

#import "LFContactInfoVC.h"

#import "LFShareManager.h"

#import "LFLocationManager.h"

@interface LFFoundDetailVC ()

@property(nonatomic, copy  ) void (^evCloseFoundCallback)(LFFoundDetailVC *lostDetailVC);

@end

@implementation LFFoundDetailVC

- (instancetype)initWithFound:(LFFound *)lost closeFoundCallback:(void (^)(LFFoundDetailVC *lostDetailVC))closeFoundCallback;{
    self = [super initWithNotice:lost];
    if (self) {
        
        [self setTitle:@"失物认领"];
        
        [self setEvCloseFoundCallback:closeFoundCallback];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _efLoadFoundDetail];
}

#pragma mark - accessory

- (LFFound *)evFound{
    
    return (LFFound *)[self evNotice];
}

#pragma mark - public

- (void)efNoticeDidClose{
    
    if ([self evCloseFoundCallback]) {
        self.evCloseFoundCallback(self);
    }
    
    [self efBack];
}

- (void)efReloadTableData{
    
    NSMutableArray *etSectionModels = [NSMutableArray array];
    
    NSMutableArray *etCellModels = [NSMutableArray array];
    
    XLFNormalCellModel *etCellModel = [[LFWebImageCellModel alloc] initWithImageUrl:[[[self evFound] user] headImageUrl]
                                                                     temporaryImage:nil
                                                                   placeholderImage:[UIImage imageNamed:@"img_user_portrait_default"]
                                                                          limitSize:CGSizeMake(50, 50)
                                                                              title:[[[self evFound] user] nickname]];
    
    [etCellModel setEvHeight:60];
    [etCellModel setEvCellClass:[LFUserInfoCell class]];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFTextCellModel alloc] initWithTitle:[[self evFound] title]];
    [etCellModel setEvTitleNumberOfLines:NSIntegerMax];
    [etCellModel setEvTitleColor:[UIColor darkGrayColor]];
    [etCellModel setEvTitleFont:[UIFont systemFontOfSize:13]];
    [etCellModel setEvTitleLineBreakMode:NSLineBreakByCharWrapping];
    [etCellModels addObject:etCellModel];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"发现"
                                                 detailText:[[[self evFound] happenTimeDate] normalizeDateTimeString]];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"发布"
                                                 detailText:[[[self evFound] timeDate] normalizeDateTimeString]];
    [etCellModels addObject:etCellModel];
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModel setEvHeaderTitle:@"时间"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"地点"
                                                 detailText:fmts(@"%@(%@)", [[[self evFound] location] address], [[[self evFound] location] name])];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvblcModelCallBack:[self _efClickLocationCallback]];
    [etCellModels addObject:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"距离"
                                                 detailText:[LFConstants distanceDescription:[[self evFound] distance]]];
    [etCellModels addObject:etCellModel];
    
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModel setEvHeaderTitle:@"地点"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etSectionModels addObject:etSectionModel];
    
    [[self evtbvContainer] setEvCellSectionModels:etSectionModels];
    
    [[self evtlbBottomBar] setHidden:[[self evFound] state] != LFNoticeStateNew];
    [[self evbbiConfrim] setTitle:select([[[self evFound] user] isLocalUser], @"已被认领", @"是我丢失")];
}

- (LFContactInfoVC *)efContactInfoViewControllerFromContactInfo:(LFUser *)contactInfo;{
    
    return [[LFContactInfoVC alloc] initWithTitle:@"得主信息" contactInfo:contactInfo];
}

#pragma mark - private

- (void)_efLoadFoundDetail{
    
    LFHttpRequest *etreqLoadFoundDetail = [self efGetFoundDetailWithFoundId:[[self evFound] id]
                                                                    success:[self _efLoadFoundDetailSuccess]
                                                                    failure:[self _efLoadFoundDetailFailed]];
    
    [etreqLoadFoundDetail startAsynchronous];
}

- (LFGetFoundDetailSuccessedBlock)_efLoadFoundDetailSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request, id json, LFFound *lost){
        
        [[ws evFound] setAttributes:[json firstObject]];
        
        [ws _efLoadFoundDetailEnd];
    };
}

- (XLFFailedBlock)_efLoadFoundDetailFailed{
    
    return ^(LFHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efLoadFoundDetailEnd{
    
    [self efReloadAllData];
}

#pragma mark - XLFStaticTableView action callback

- (void (^)(XLFNormalCellModel* model))_efClickLocationCallback{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFLocationDistributeVC *etLocationDistributeVC = [[LFLocationDistributeVC alloc] initWithTitle:@"主要地点"
                                                                                              location:[[ws evFound] location]
                                                                                             locations:nil];
        
        [[ws navigationController] pushViewController:etLocationDistributeVC animated:YES];
    };
}

@end
