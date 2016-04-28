//
//  LFMyFoundsVC.m
//  FoundAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFMyFoundsVC.h"

#import "LFFound.h"

#import "LFNoticeSummaryCell.h"

#import "LFFoundDetailVC.h"

#import "LFRefresh.h"

@interface LFMyFoundsVC ()

@property(nonatomic, strong) NSMutableArray *evFounds;

@end

@implementation LFMyFoundsVC

- (instancetype)init{
    self = [super initWithTitle:@"我得" noticeType:LFNoticeTypeFound];
    if (self) {
    }
    return self;
}

- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice{
    
    return [[LFFoundDetailVC alloc] initWithFound:(LFFound *)selectedNotice closeFoundCallback:[self _efCloseFoundCallback]];
}

#pragma mark - LFFoundDetailVC closeFoundCallback

- (void (^)(LFFoundDetailVC *foundDetailVC))_efCloseFoundCallback{
    
    Weakself(ws);
    return ^(LFFoundDetailVC *foundDetailVC){
        
        [ws efReloadNotice:[foundDetailVC evFound]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDidCloseNotification object:[foundDetailVC evFound]];
    };
}

@end
