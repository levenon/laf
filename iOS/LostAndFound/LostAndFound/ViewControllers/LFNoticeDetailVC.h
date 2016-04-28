//
//  LFNoticeDetailVC.h
//  LostAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

#import "LFNotice.h"

#import "LFContactInfoVC.h"

@interface LFNoticeDetailVC : LFBaseViewController

@property(nonatomic, strong, readonly) LFNotice *evNotice;

- (instancetype)initWithNotice:(LFNotice *)notice;

#pragma mark - protectd

- (void)efReloadTableData;  // needs override

- (void)efNoticeDidClose;   // needs override

- (LFContactInfoVC *)efContactInfoViewControllerFromContactInfo:(LFUser *)contactInfo;

#pragma mark - public

- (void)efReloadCarouseData;// reload TableView and iCarouse

- (void)efReloadAllData;    // reload TableView and iCarouse

@end

@interface LFNoticeDetailVC (Control)

@property(nonatomic, strong, readonly) XLFStaticTableView *evtbvContainer;

@property(nonatomic, strong, readonly) iCarousel *evvImageContainer;

@property(nonatomic, strong, readonly) UIToolbar *evtlbBottomBar;

@property(nonatomic, strong, readonly) UIBarButtonItem *evbbiShare;

@property(nonatomic, strong, readonly) UIBarButtonItem *evbbiConfrim;

@end
