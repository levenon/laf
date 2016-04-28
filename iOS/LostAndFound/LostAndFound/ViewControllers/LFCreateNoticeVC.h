//
//  LFCreateNoticeVC.h
//  NoticeAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

#import "LFCreateNoticeHeaderView.h"

#import "LFTimePickerView.h"

#import "LFLocationSelectorVC.h"

#import "LFCategorySelectorVC.h"

@class LFCreateNoticeVC;

@protocol LFCreateNoticeDelegate <NSObject>

- (void)epCreateNoticeVC:(LFCreateNoticeVC *)createNoticeVC didSuccessCreateNotice:(LFNotice *)notice;

@end

@interface LFCreateNoticeVC : LFBaseViewController<LFTimePickerViewDelegate, LFCategorySelectorVCDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, assign, readonly) id<LFCreateNoticeDelegate> evDelegate;

- (instancetype)initWithCallback:(void (^)(LFCreateNoticeVC *createNoticeVC, LFNotice *notice))creatNoticeCallback;

- (instancetype)initWithDelegate:(id<LFCreateNoticeDelegate>)delegate;

@end

@interface LFCreateNoticeVC (Protected)

@property(nonatomic, strong, readonly) XLFStaticTableView *evtbvContainer;

@property(nonatomic, strong, readonly) LFCreateNoticeHeaderView *evvHeader;

@property(nonatomic, strong, readonly) LFEditableNotice *evNotice; // needs override

@property(nonatomic, strong) XLFNormalCellModel *evCategoryCellModel;
@property(nonatomic, strong) XLFNormalCellModel *evHappenTimeCellModel;
@property(nonatomic, strong) XLFNormalCellModel *evMainLocationCellModel;

- (void)efReloadTableData; // needs override

- (BOOL)efShouldCreateNotice;

- (void)efCreateNotice;

- (void)efNoticeDidCreated;

@end