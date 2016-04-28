//
//  LFFoundsVC.m
//  FoundAndFound
//
//  Created by Marike Jave on 15/12/15.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFFoundsVC.h"

#import "LFFoundDetailVC.h"

#import "LFFound.h"

@interface LFFoundsVC ()

@end

@implementation LFFoundsVC

- (instancetype)init{
    self = [super initWithNoticeType:LFNoticeTypeFound refreshControlFileName:@"FOUND"];
    if (self) {
        
    }
    return self;
}

#pragma mark - public

- (LFNoticeDetailVC *)efNoticeDetailFromSelectedNotice:(LFNotice *)selectedNotice{
    
    return [[LFFoundDetailVC alloc] initWithFound:(LFFound *)selectedNotice closeFoundCallback:[self _efCloseFoundCallback]];
}

#pragma mark - LFCreateNoticeDelegate

- (void)epCreateNoticeVC:(LFCreateNoticeVC *)createNoticeVC didSuccessCreateNotice:(LFNotice *)notice;{
    
    [LFUserManager efAppendFoundsCount:1];
    
    [self efInsertNotice:notice atIndex:0];
}

#pragma mark - LFFoundDetailVC closeFoundCallback

- (void (^)(LFFoundDetailVC *foundDetailVC))_efCloseFoundCallback{
    
    Weakself(ws);
    return ^(LFFoundDetailVC *foundDetailVC){
        
        [ws efDeleteNotice:[foundDetailVC evFound]];
    };
}

@end