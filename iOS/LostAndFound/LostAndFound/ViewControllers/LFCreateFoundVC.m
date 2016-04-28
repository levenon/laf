
//
//  LFCreateFoundVC.m
//  LostAndFound
//
//  Created by Marke Jave on 15/12/23.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFCreateFoundVC.h"

#import "LFTimePickerView.h"

#import "LFLocationSelectorVC.h"

#import "LFCategorySelectorVC.h"

@interface LFCreateFoundVC ()<LFTimePickerViewDelegate, LFCategorySelectorVCDelegate>

@property(nonatomic, strong) LFEditableFound *evFound;

@end

@implementation LFCreateFoundVC

#pragma mark - accessory

- (LFEditableFound *)evFound{
    
    if (!_evFound) {
        
        _evFound = [LFEditableFound model];
    }
    return _evFound;
}

- (LFEditableNotice *)evNotice{
    
    return [self evFound];
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
    
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:@"发现时间" detailText:@"刚刚"];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvblcModelCallBack:[self _efSelectFoundDatetime]];
    [etCellModels addObject:etCellModel];
    [self setEvHappenTimeCellModel:etCellModel];
    
    XLFNormalSectionModel *etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModels addObject:etSectionModel];
    
    etCellModels = [NSMutableArray array];
    etCellModel = [[XLFNormalCellModel alloc] initWithTitle:nstodefault([[[self evFound] location] name], @"未选择")
                                                 detailText:ntoe([[[self evFound] location] address])];
    [etCellModel setEvAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [etCellModel setEvblcModelCallBack:[self _efClickSelectLocationCallback]];
    [etCellModels addObject:etCellModel];
    [self setEvMainLocationCellModel:etCellModel];
    
    etSectionModel = [[XLFNormalSectionModel alloc] initWithCellModels:etCellModels];
    
    [etSectionModel setEvHeaderTitle:@"地点"];
    [etSectionModel setEvHeaderViewHeight:40];
    [etSectionModels addObject:etSectionModel];
    
    [[self evtbvContainer] setEvCellSectionModels:etSectionModels];
    [[self evvHeader] setEvNotice:[self evFound]];
}

- (BOOL)efShouldCreateNotice{
    
    if (![[[self evFound] title] length]) {
        [MBProgressHUD showWithStatus:@"请描述一下您丢失的物品"];
        return NO;
    }
    
    if (![[self evFound] category]) {
        [MBProgressHUD showWithStatus:@"请选择类别"];
        return NO;
    }
    
    if (![[[self evFound] images] count] && ![[[self evFound] remoteImages] count]) {
        [MBProgressHUD showWithStatus:@"请至少添加一张图片"];
        return NO;
    }
    
    if (![[self evFound] happenTimeDate]) {
        [MBProgressHUD showWithStatus:@"请选择丢失时间"];
        return NO;
    }
    
    if (![[self evFound] location]) {
        [MBProgressHUD showWithStatus:@"请选择丢失地点"];
        return NO;
    }
    
    return YES;
}

- (void)efCreateNotice{
    
    LFHttpRequest *etreqCreateFound = [self efCreateFoundWithFound:[[self evFound] found]
                                                           success:[self _efCreateNoticeSuccess]
                                                           failure:[self _efCreateNoticeFailed]];
    
    [etreqCreateFound setHiddenLoadingView:NO];
    [etreqCreateFound setLoadingHintsText:@"正在创建失物招领"];
    [etreqCreateFound startAsynchronous];
}

#pragma mark - private

- (LFCreateNoticeSuccessedBlock)_efCreateNoticeSuccess{
    
    Weakself(ws);
    return ^(LFHttpRequest *request, id json, LFNoticeBase *noticeBase){
        
        [[ws evFound] setAttributes:[noticeBase dictionary]];
        
        [ws _efCreateFoundEnd];
    };
}

- (XLFFailedBlock)_efCreateNoticeFailed{
    
    return ^(LFHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efCreateFoundEnd{
    
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

- (void (^)(XLFNormalCellModel* model))_efSelectFoundDatetime{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFTimePickerView *etTimePickerView = [[LFTimePickerView alloc] initWithDelegate:ws
                                                                                   date:[[ws evFound] happenTimeDate]
                                                                                minDate:[[NSDate date] dateByAddingTimeInterval:-5 * SECONDES_PER_NORMAL_YEAR]
                                                                                maxDate:[NSDate date]
                                                                                   mode:UIDatePickerModeDateAndTime];
        [etTimePickerView efShowInView:[ws view]];
    };
}

- (void (^)(XLFNormalCellModel* model))_efClickSelectLocationCallback{
    
    Weakself(ws);
    return ^(XLFNormalCellModel* model){
        
        LFLocationSelectorVC *etLocationSelectorVC = [[LFLocationSelectorVC alloc] initWithCompletionCallback:[ws _efLocationSelectorCallback]];
        
        [[ws navigationController] pushViewController:etLocationSelectorVC animated:YES];
    };
}

#pragma mark - LFLocationSelectorVC callback

- (void (^)(LFLocationSelectorVC *locationSelector, LFLocation *location))_efLocationSelectorCallback{
    
    Weakself(ws);
    return ^(LFLocationSelectorVC *locationSelector, LFLocation *location){
        
        [[locationSelector navigationController] popViewControllerAnimated:YES];
        
        [[ws evFound] setLocation:location];
        
        [[ws evMainLocationCellModel] setEvTitle:[location name]];
        [[ws evMainLocationCellModel] setEvSubTitle:[location address]];
        
        [[ws evtbvContainer] efReloadCellAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]];
    };
}

@end
