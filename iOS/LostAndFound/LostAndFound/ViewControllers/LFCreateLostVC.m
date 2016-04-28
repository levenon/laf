//
//  LFCreateLostVC.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/23.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFCreateLostVC.h"

#import "LFTimePickerView.h"

#import "LFLocationSelectorVC.h"

#import "LFCategorySelectorVC.h"

@interface LFCreateLostVC ()

@property(nonatomic, strong) LFEditableLost *evLost;

@end

@implementation LFCreateLostVC

#pragma mark - accessory

- (LFEditableLost *)evLost{
    
    if (!_evLost) {
        
        _evLost = [LFEditableLost model];
    }
    return _evLost;
}

- (LFEditableNotice *)evNotice{
    
    return [self evLost];
}

#pragma mark - public

- (void)efReloadTableData{
    
    NSMutableArray *etSectionModels = [NSMutableArray array];
    
    NSMutableArray *etCellModels = [NSMutableArray array];
    
    XLFNormalCellModel *etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"类别" detailText:@"未选择"];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvblcModelCallBack:[self _efSelectCategory]];
    [etCellModels addObject:etCellModel];
    [self setEvCategoryCellModel:etCellModel];
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"丢失时间" detailText:@"刚刚"];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvblcModelCallBack:[self _efSelectLostDatetime]];
    [etCellModels addObject:etCellModel];
    [self setEvHappenTimeCellModel:etCellModel];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:nstodefault([[[self evLost] location] name], @"未选择")
                                                 detailText:ntoe([[[self evLost] location] address])];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvblcModelCallBack:[self _efClickSelectMainLocationCallback]];
    [etCellModels addObject:etCellModel];
    [self setEvMainLocationCellModel:etCellModel];
    
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModel setEvHeaderTitle:@"主要地点"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"添加..."
                                                 detailText:nil];
    [etCellModel setEvblcModelCallBack:[self _efClickSelectPossibleLocationCallback]];
    [etCellModel setEvTitleColor:[UIColor redColor]];
    [etCellModels addObject:etCellModel];
    
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModel setEvHeaderTitle:@"可能地点"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etSectionModels addObject:etSectionModel];
    
    [[self evtbvContainer] setEvCellSectionModels:etSectionModels];
    [[self evvHeader] setEvNotice:[self evLost]];
}

- (BOOL)efShouldCreateNotice{
    
    if (![[[self evLost] title] length]) {
        [MBProgressHUD showWithStatus:@"请描述一下您丢失的物品"];
        return NO;
    }
    
    if (![[self evLost] category]) {
        [MBProgressHUD showWithStatus:@"请选择类别"];
        return NO;
    }
    
    if (![[[self evLost] images] count] && ![[[self evLost] remoteImages] count]) {
        [MBProgressHUD showWithStatus:@"请至少添加一张图片"];
        return NO;
    }
    
    if (![[self evLost] happenTimeDate]) {
        [MBProgressHUD showWithStatus:@"请选择丢失时间"];
        return NO;
    }
    
    if (![[self evLost] location]) {
        [MBProgressHUD showWithStatus:@"请选择丢失地点"];
        return NO;
    }
    
    return YES;
}

- (void)efCreateNotice{
    
    LFHttpRequest *etreqCreateLost = [self efCreateLostWithLost:[[self evLost] lost]
                                                        success:[self _efCreateNoticeSuccess]
                                                        failure:[self _efCreateNoticeFailed]];
    
    [etreqCreateLost setHiddenLoadingView:NO];
    [etreqCreateLost setLoadingHintsText:@"正在创建寻物启事"];
    [etreqCreateLost startAsynchronous];
}

- (LFCreateNoticeSuccessedBlock)_efCreateNoticeSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request, id json, LFNoticeBase *noticeBase){
        
        [[ws evLost] setAttributes:[noticeBase dictionary]];
        
        [ws _efCreateLostEnd];
    };
}

- (XLFFailedBlock)_efCreateNoticeFailed{
    
    return ^(LFHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efCreateLostEnd{
    
    [self efNoticeDidCreated];
}

#pragma mark - XLFStaticTableView action callback

- (void (^)(XLFNormalCellModel* model))_efSelectCategory{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFCategorySelectorVC *etCategorySelectorVC = [[LFCategorySelectorVC alloc] initWithDelegate:ws];
        
        [[ws navigationController] pushViewController:etCategorySelectorVC animated:YES];
    };
}

- (void (^)(XLFNormalCellModel* model))_efSelectLostDatetime{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFTimePickerView *etTimePickerView = [[LFTimePickerView alloc] initWithDelegate:ws
                                                                                   date:[[ws evLost] happenTimeDate]
                                                                                minDate:[[NSDate date] dateByAddingTimeInterval:-5 * SECONDES_PER_NORMAL_YEAR]
                                                                                maxDate:[NSDate date]
                                                                                   mode:UIDatePickerModeDateAndTime];
        [etTimePickerView efShowInView:[self view]];
    };
}

- (void (^)(XLFNormalCellModel* model))_efClickSelectMainLocationCallback{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFLocationSelectorVC *etLocationSelectorVC = [[LFLocationSelectorVC alloc] initWithCompletionCallback:[ws _efMainLocationSelectorCallback]];
        
        [[ws navigationController] pushViewController:etLocationSelectorVC animated:YES];
    };
}

- (void (^)(XLFNormalCellModel* model))_efClickSelectPossibleLocationCallback{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFLocationSelectorVC *etLocationSelectorVC = [[LFLocationSelectorVC alloc] initWithCompletionCallback:[ws _efPossibleLocationSelectorCallback]];
        
        [[ws navigationController] pushViewController:etLocationSelectorVC animated:YES];
    };
}

#pragma mark - LFLocationSelectorVC callback

- (void (^)(LFLocationSelectorVC *locationSelector, LFLocation *location))_efMainLocationSelectorCallback{
    
    Weakself(ws);
    return ^(LFLocationSelectorVC *locationSelector, LFLocation *location){
        
        [[locationSelector navigationController] popViewControllerAnimated:YES];
        
        [[ws evLost] setLocation:location];
        
        [[ws evMainLocationCellModel] setEvTitle:[location name]];
        [[ws evMainLocationCellModel] setEvSubTitle:[location address]];
        
        [[ws evtbvContainer] efReloadCellAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]];
    };
}

- (void (^)(LFLocationSelectorVC *locationSelector, LFLocation *location))_efPossibleLocationSelectorCallback{
    
    Weakself(ws);
    return ^(LFLocationSelectorVC *locationSelector, LFLocation *location){
        
        [[locationSelector navigationController] popViewControllerAnimated:YES];
        
        XLFNormalCellModel *etNormalCellModel = [[XLFNormalCellModel alloc] initWithTitle:[location name]
                                                                               detailText:[location address]];
        [etNormalCellModel setEvEditable:YES];
        
        NSIndexPath *etIndexPath = [NSIndexPath indexPathForRow:[[[ws evLost] locations] count] inSection:2];
        
        [[[ws evLost] locations] addObject:location];
        [[ws evtbvContainer] efInsertCell:etNormalCellModel atIndexPath:etIndexPath];
    };
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;{
    
    [[[self evLost] locations] removeObjectAtIndex:[indexPath row]];
    [[self evtbvContainer] efDeleteCellAtIndexPath:indexPath];
}

@end
