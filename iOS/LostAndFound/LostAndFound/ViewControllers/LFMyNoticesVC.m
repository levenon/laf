//
//  LFMyNoticesVC.m
//  NoticeAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFMyNoticesVC.h"

#import "LFNotice.h"

#import "LFNoticeSummaryCell.h"

#import "LFNoticeDetailVC.h"

#import "LFRefresh.h"

@interface LFMyNoticesVC ()

@property(nonatomic, strong) NSMutableArray<LFNotice *> *evMutableNotices;

@property(nonatomic, assign) LFNoticeType evNoticeType;

@end

@implementation LFMyNoticesVC

- (instancetype)initWithTitle:(NSString *)title noticeType:(LFNoticeType)noticeType{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        [self setTitle:title];
        [self setEvNoticeType:noticeType];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self tableView] setRowHeight:96];
    [[self tableView] setShowsVerticalScrollIndicator:NO];
    [[self tableView] addHeaderWithTarget:self action:@selector(didTriggerRefresh:)];
    [[self tableView] addFooterWithTarget:self action:@selector(didTriggerLoadMore:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self tableView] registerClass:[LFNoticeSummaryCell class] forCellReuseIdentifier:NSStringFromClass([LFNoticeSummaryCell class])];
    [[self tableView] setTableFooterView:[UIView emptyFrameView]];
    
    [[self tableView] beginRefresh];
}

#pragma mark protected

- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice;{
    
    return nil;
}

- (void)efReloadNotice:(LFNotice *)notice{
    
    NSInteger etDeleteIndex = [[self evMutableNotices] indexOfObject:notice];
    [[self tableView] beginUpdates];
    [[self tableView] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:etDeleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [[self tableView] endUpdates];
}

#pragma mark - accessory

- (NSMutableArray *)evMutableNotices{
    
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
    
    LFHttpRequest *etreqLoadNotices = [self efGetUserNoticesWithNoticeType:[self evNoticeType]
                                                              categoryId:nil
                                                                    page:select(loadMore, [self evCurrentPage] + 1, 0)
                                                                    size:5
                                                                 success:[self _efLoadNoticesSuccess]
                                                                 failure:[self _efLoadNoticesFailed]];
    
    [etreqLoadNotices startAsynchronous];
}

- (XLFOnlyArrayResponseSuccessedBlock)_efLoadNoticesSuccess{
    
    Weakself(ws);
    
    return ^(id request, id result, NSArray *notices){
        
        if (notices && [notices count]) {
            
            NSMutableSet<LFNotice *> *etNoticeSets = [NSMutableSet<LFNotice *> setWithArray:notices];
            NSSet<LFNotice *> *etLocalNoticeSets = [NSSet<LFNotice *> setWithArray:[ws evMutableNotices]];
            [etNoticeSets minusSet:etLocalNoticeSets];
            
            notices = [etNoticeSets allObjects];
            notices = [notices sortedArrayUsingComparator:^NSComparisonResult(LFNotice *  _Nonnull noticePrevious, LFNotice *  _Nonnull noticeNext) {
                return [[noticeNext time] compare:[noticePrevious time]];
            }];
            
            if (![ws evLoadMore]) {
                
                [ws _efRefreshNotices:notices];
            }
            else{
                
                [ws _efLoadMoreNotices:notices];
            }
        }
        [self _efTriggerEnd];
    };
}

- (XLFFailedBlock)_efLoadNoticesFailed{
    
    Weakself(ws);
    return ^(id request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
        
        [ws _efTriggerEnd];
    };
}

- (void)_efRefreshNotices:(NSArray <LFNotice *>*)notices{
    
    [[self tableView] beginUpdates];
    
    [[self evMutableNotices] insertObjects:notices atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [notices count])]];
    [[self tableView] insertRowsAtIndexPaths:[NSIndexPath indexPathsFromIndex:0 count:[notices count]]
                            withRowAnimation:UITableViewRowAnimationFade];
    
    [[self tableView] endUpdates];
}

- (void)_efLoadMoreNotices:(NSArray <LFNotice *>*)notices{
    
    NSArray *etIndexPaths = [NSIndexPath indexPathsFromIndex:[[self evMutableNotices] count] count:[notices count]];
    
    [[self tableView] beginUpdates];
    
    [[self evMutableNotices] addObjectsFromArray:notices];
    [[self tableView] insertRowsAtIndexPaths:etIndexPaths
                            withRowAnimation:UITableViewRowAnimationFade];
    
    [[self tableView] endUpdates];
}

- (void)_efTriggerEnd{
    
    if ([self evLoadMore]) {
        self.evCurrentPage++;
    }
    else{
        [self setEvCurrentPage:0];
    }
    
    [self setEvLoadMore:NO];
    [[self tableView] endRefresh];
    [[self tableView] endLoadMore];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self evMutableNotices] count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(LFNoticeSummaryCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFNotice *etNotice = [[self evMutableNotices] objectAtIndex:[indexPath row]];
    
    [cell setEvNotice:etNotice];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LFNoticeSummaryCell *etNoticeSummaryCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LFNoticeSummaryCell class])];
    
    return etNoticeSummaryCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LFNotice *etNotice = [[self evMutableNotices] objectAtIndex:[indexPath row]];
    
    LFNoticeDetailVC *etNoticeDetailVC = [self efNoticeDetailFromSelectedNotice:etNotice];
    
    [[self navigationController] pushViewController:etNoticeDetailVC animated:YES];
}

#pragma mark - action

- (IBAction)didTriggerRefresh:(id)sender{
    
    [[self tableView] endLoadMore];
    
    [self _efLoadNotices:NO];
}

- (IBAction)didTriggerLoadMore:(id)sender{
    
    [[self tableView] endRefresh];
    
    if (![self evLoadMore]) {
        
        [self _efLoadNotices:YES];
    }
}

@end
