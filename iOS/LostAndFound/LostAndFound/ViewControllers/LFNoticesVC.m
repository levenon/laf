//
//  LFNoticesVC.m
//  NoticeAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "LFNoticesVC.h"

#import "LFMenuController.h"

#import "LFNoticeCell.h"
#import "LFLocationManager.h"
#import "CBStoreHouseRefreshControl.h"

#import "UIScrollView+Pull.h"

@interface LFNoticesVC ()<XLFTableViewCellDelegate>

@property(nonatomic, strong) CBStoreHouseRefreshControl *evRefreshControl;

@property(nonatomic, strong) NSMutableArray<LFNotice *> *evMutableNotices;

@property(nonatomic, strong) LFCategory *evSelectedCategory;

@property(nonatomic, assign) LFNoticeType evNoticeType;

@property(nonatomic, copy  ) NSString *evRefreshControlFileName;

@end

@implementation LFNoticesVC

- (instancetype)initWithNoticeType:(LFNoticeType)noticeType refreshControlFileName:(NSString *)refreshControlFileName{
    self = [super init];
    if (self) {
        
        [self setEvNoticeType:noticeType];
        [self setEvRefreshControlFileName:refreshControlFileName];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [[self tableView] setRowHeight:SCREEN_WIDTH * 0.7 + 2];
    [[self tableView] setShowsVerticalScrollIndicator:NO];
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[self tableView] setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self tableView] registerClass:[LFNoticeCell class] forCellReuseIdentifier:NSStringFromClass([LFNoticeCell class])];
    [[self tableView] setTableFooterView:[UIView emptyFrameView]];
    
    Weakself(ws);
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ws evRefreshControl] beginLoading];
    });
}

#pragma mark - public

- (void)efRegisterNotification{
    [super efRegisterNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateUserInfoChanged:) name:kUserInfoChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateNoticeDidClose:) name:kNoticeDidCloseNotification object:nil];
    
}

- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice;{
    
    return nil;
}

- (void)efInsertNotice:(LFNotice *)notice atIndex:(NSInteger)index{
    
    Weakself(ws);
    
    [self _efCaculateDistanceWithNotices:@[notice] completion:^{
        
        [[ws tableView] beginUpdates];
        [[ws evMutableNotices] insertObject:notice atIndex:index];
        [[ws tableView] insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [[ws tableView] endUpdates];
    }];
}

- (void)efDeleteNotice:(LFNotice *)notice{
    
    if ([[self evMutableNotices] containsObject:notice]) {
        
        NSInteger etIndex = [[self evMutableNotices] indexOfObject:notice];
        
        [self efDeleteAtIndex:etIndex];
    }
}

- (void)efDeleteAtIndex:(NSInteger)index{
    
    [[self tableView] beginUpdates];
    [[self evMutableNotices] removeObjectAtIndex:index];
    [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] endUpdates];}

#pragma mark - accessory

- (CBStoreHouseRefreshControl *)evRefreshControl{
    
    if (!_evRefreshControl) {
        _evRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:[self tableView]
                                                                    target:self
                                                             refreshAction:@selector(didTriggerRefresh:)
                                                                     plist:[self evRefreshControlFileName]];
    }
    return _evRefreshControl;
}

- (NSMutableArray<LFNotice *> *)evMutableNotices{
    
    if (!_evMutableNotices) {
        _evMutableNotices = [NSMutableArray array];
    }
    return _evMutableNotices;
}

- (NSArray<LFNotice *> *)evNotices{
    
    return [NSArray arrayWithArray:[self evMutableNotices]];
}

#pragma mark - private

- (void)_efLoadNotices:(BOOL)loadMore{
    
    [self setEvLoadMore:loadMore];
    
    LFHttpRequest *etreqLoadNotices = [self efGetNoticesWithNoticeType:[self evNoticeType]
                                                          categoryId:[[self evSelectedCategory] id]
                                                                time:select(loadMore, [[[self evMutableNotices] lastObject] time], [[[self evMutableNotices] firstObject] time])
                                                                more:loadMore
                                                                size:5
                                                             success:[self _efLoadNoticesSuccess]
                                                             failure:[self _efLoadNoticesFailed]];
    
    [etreqLoadNotices startAsynchronous];
}

- (XLFOnlyArrayResponseSuccessedBlock)_efLoadNoticesSuccess{
    
    Weakself(ws);
    
    return ^(id request, id result, NSArray<LFNotice *> *notices){
        
        void (^completion)() = ^(){
            
            [ws _efTriggerEnd];
        };
        
        if (notices && [notices count]) {
            
            if (![ws evLoadMore]) {
                
                [ws _efRefreshNotices:notices completion:completion];
            }
            else{
                
                [ws _efLoadMoreNotices:notices completion:completion];
            }
        }
        else{
            completion();
        }
    };
}

- (XLFFailedBlock)_efLoadNoticesFailed{
    
    Weakself(ws);
    return ^(id request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
        
        [ws _efTriggerEnd];
    };
}

- (void)_efRefreshNotices:(NSArray <LFNotice *>*)notices completion:(void (^)())completion{
    
    Weakself(ws);
    [self _efCaculateDistanceWithNotices:notices completion:^{
        
        [[ws tableView] beginUpdates];
        
        [[ws evMutableNotices] insertObjects:notices atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [notices count])]];
        [[ws tableView] insertRowsAtIndexPaths:[NSIndexPath indexPathsFromIndex:0 count:[notices count]]
                              withRowAnimation:UITableViewRowAnimationFade];
        
        [[ws tableView] endUpdates];
        
        if (completion) {
            completion();
        }
    }];
}

- (void)_efLoadMoreNotices:(NSArray <LFNotice *>*)notices completion:(void (^)())completion{
    
    Weakself(ws);
    [self _efCaculateDistanceWithNotices:notices completion:^{
        
        NSArray *etIndexPaths = [NSIndexPath indexPathsFromIndex:[[ws evMutableNotices] count] count:[notices count]];
        
        [[ws tableView] beginUpdates];
        
        [[ws evMutableNotices] addObjectsFromArray:notices];
        [[ws tableView] insertRowsAtIndexPaths:etIndexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
        
        [[ws tableView] endUpdates];
        
        if (completion) {
            completion();
        }
    }];
}

- (void)_efTriggerEnd{
    
    [self setEvLoadMore:NO];
    [[self evRefreshControl] finishLoading];
}

- (void)_efCaculateDistanceWithNotices:(NSArray <LFNotice *> *)notices completion:(void (^)())completion{
    
    [[LFLocationManager shareLocationManager] efAddLocationWithTag:NSStringFromClass([self class])
                                                          callback:^(BMKUserLocation * userLocation, NSError * error)
     {
         CLLocationCoordinate2D etUserCoordinate = [[userLocation location] coordinate];
         
         [notices enumerateObjectsUsingBlock:^(LFNotice * _Nonnull notice, NSUInteger idx, BOOL * _Nonnull stop) {
             
             CLLocationDistance etDistance = BMKMetersBetweenMapPoints(BMKMapPointForCoordinate([[notice location] coordinate]),
                                                                       BMKMapPointForCoordinate(etUserCoordinate));
             
             [notice setDistance:etDistance];
         }];
         
         if (completion) {
             completion();
         }
     }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[self evRefreshControl] scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [[self evRefreshControl] scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self evMutableNotices] count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(LFNoticeCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFNotice *etNotice = [[self evMutableNotices] objectAtIndex:[indexPath row]];
    
    [cell setEvNotice:etNotice];
    
    if ([indexPath row] && [indexPath row] == [[self evMutableNotices] count] - 1) {
        
        [self _efLoadNotices:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFNoticeCell *etNoticeCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LFNoticeCell class])];
    return etNoticeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LFNotice *etNotice = [[self evMutableNotices] objectAtIndex:[indexPath row]];
    
    LFNoticeDetailVC *etNoticeDetailVC = [self efNoticeDetailFromSelectedNotice:etNotice];
    
    if (etNoticeDetailVC) {
        
        [[self navigationController] pushViewController:etNoticeDetailVC animated:YES];
    }
}

#pragma mark - LFCategoryMenuVCDelegate

- (void)epMenuVC:(LFCategoryMenuVC *)menuVC didSelectedCategory:(LFCategory *)category;{

    if ((([[[self evSelectedCategory] id] length]  && ![[self evSelectedCategory] isEqual:category]) ||
         (![[[self evSelectedCategory] id] length] && [[category id] length]))) {
        
        [self setEvSelectedCategory:category];
        
        if ([[self evMutableNotices] count] && [[category id] length]) {
         
            NSArray *etFilterNotices = [[self evMutableNotices] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category.id == %@", [category id]]];
            
            [[self evMutableNotices] setArray:etFilterNotices];
            [[self tableView] reloadData];
            
            if ([[self evMutableNotices] count] < 5) {
                [[self evRefreshControl] beginLoading];
            }
        }
        else{
            
            [[self evMutableNotices] removeAllObjects];
            [[self tableView] reloadData];
            
            [[self evRefreshControl] beginLoading];
        }
    }
}

#pragma mark - LFCreateLostDelegate

- (void)epCreateNoticeVC:(LFCreateNoticeVC *)createNoticeVC didSuccessCreateNotice:(LFNotice *)notice;{
    
    [self efInsertNotice:notice atIndex:0];
}

#pragma mark - action

- (IBAction)didTriggerRefresh:(id)sender{
    
    [self _efLoadNotices:NO];
}

#pragma mark - actions

- (IBAction)didNotificateNoticeDidClose:(NSNotification *)sender{
    
    if ([[self evMutableNotices] containsObject:[sender object]]) {
        
        NSInteger etIndex = [[self evMutableNotices] indexOfObject:[sender object]];
        
        [self efDeleteAtIndex:etIndex];
    }
}

- (IBAction)didNotificateUserInfoChanged:(NSNotification *)notification{
    
    LFUser *etUser = [notification object];
    for (LFNotice *notice in [self evMutableNotices]) {
        if ([[etUser id] isEqualToString:[notice uid]]) {
            [notice setUser:[etUser mutableCopy]];
        }
    }
}

@end
