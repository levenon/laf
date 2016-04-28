//
//  LFLostsVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/15.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFLostsVC.h"

#import "LFLostDetailVC.h"

#import "LFLost.h"

@interface LFLostsVC ()

@end

@implementation LFLostsVC

- (instancetype)init{
    self = [super initWithNoticeType:LFNoticeTypeLost refreshControlFileName:@"LOST"];
    if (self) {
        
    }
    return self;
}

#pragma mark - public 

- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice{
    
    return [[LFLostDetailVC alloc] initWithLost:(LFLost *)selectedNotice closeLostCallback:[self _efCloseLostCallback]];
}

#pragma mark - LFCreateNoticeDelegate

- (void)epCreateNoticeVC:(LFCreateNoticeVC *)createNoticeVC didSuccessCreateNotice:(LFNotice *)notice;{
    
    [LFUserManager efAppendLostsCount:1];
    
    [self efInsertNotice:notice atIndex:0];
}

#pragma mark - LFLostDetailVC closeLostCallback

- (void (^)(LFLostDetailVC *lostDetailVC))_efCloseLostCallback{
    
    Weakself(ws);
    return ^(LFLostDetailVC *lostDetailVC){
        
        [ws efDeleteNotice:[lostDetailVC evLost]];
    };
}

@end
