//
//  LFNoticesVC.h
//  LostAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFBaseTableViewController.h"
#import "LFPullMenuViewController.h"
#import "LFCategoryMenuVC.h"
#import "LFCreateLostVC.h"

#import "LFNoticeDetailVC.h"

#import "LFCreateNoticeVC.h"

@interface LFNoticesVC : LFBaseTableViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting, LFCategoryMenuVCDelegate, LFCreateNoticeDelegate>

@property(nonatomic, assign) LFPullMenuViewController *menu;

@property(nonatomic, strong, readonly) NSArray<LFNotice *> *evNotices;

- (instancetype)initWithNoticeType:(LFNoticeType)noticeType refreshControlFileName:(NSString *)refreshControlFileName;

#pragma mark - protected
- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice; // needs override

#pragma mark - public
- (void)efInsertNotice:(LFNotice *)notice atIndex:(NSInteger)index;

- (void)efDeleteNotice:(LFNotice *)notice;

- (void)efDeleteAtIndex:(NSInteger)index;

@end
