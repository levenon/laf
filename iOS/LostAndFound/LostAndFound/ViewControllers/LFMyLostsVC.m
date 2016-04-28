//
//  LFMyLostsVC.m
//  LostAndLost
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFMyLostsVC.h"

#import "LFLostDetailVC.h"

@interface LFMyLostsVC ()

@end

@implementation LFMyLostsVC

- (instancetype)init{
    self = [super initWithTitle:@"我失" noticeType:LFNoticeTypeLost];
    if (self) {
    }
    return self;
}

- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice{
    
    return [[LFLostDetailVC alloc] initWithLost:(LFLost *)selectedNotice closeLostCallback:[self _efCloseLostCallback]];
}

#pragma mark - LFLostDetailVC closeLostCallback

- (void (^)(LFLostDetailVC *lostDetailVC))_efCloseLostCallback{
    
    Weakself(ws);
    return ^(LFLostDetailVC *lostDetailVC){
        
        [ws efReloadNotice:[lostDetailVC evLost]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeDidCloseNotification object:[lostDetailVC evLost]];
    };
}

@end
