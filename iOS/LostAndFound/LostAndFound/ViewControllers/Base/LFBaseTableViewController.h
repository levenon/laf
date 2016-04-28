//
//  LFBaseTableViewController.h
//  LostAndFound
//
//  Created by Marike Jave on 14-12-10.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>
#import <XLFBaseViewControllerKit/XLFBaseViewControllerKit.h>
#import "LFRefreshProtocol.h"

@interface LFBaseTableViewController : XLFBaseTableViewController<LFRefreshProtocol>

@property(nonatomic, assign) NSInteger evCurrentPage;

@property(nonatomic, assign) BOOL evLoadMore;

@end

