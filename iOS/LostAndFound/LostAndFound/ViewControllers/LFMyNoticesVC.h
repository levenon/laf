//
//  LFMyNoticesVC.h
//  LostAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFBaseTableViewController.h"

#import "LFNoticeDetailVC.h"

@interface LFMyNoticesVC : LFBaseTableViewController

@property(nonatomic, strong) NSArray<LFNotice *> *evNotices;

- (instancetype)initWithTitle:(NSString *)title noticeType:(LFNoticeType)noticeType;

#pragma mark - protected
- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice; // needs override

#pragma mark - public
- (void)efReloadNotice:(LFNotice *)notice;

@end
