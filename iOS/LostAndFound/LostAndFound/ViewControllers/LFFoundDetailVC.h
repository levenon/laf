//
//  LFFoundDetailVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNoticeDetailVC.h"

#import "LFFound.h"

@interface LFFoundDetailVC : LFNoticeDetailVC

@property(nonatomic, strong, readonly) LFFound *evFound;

- (instancetype)initWithFound:(LFFound *)lost closeFoundCallback:(void (^)(LFFoundDetailVC *lostDetailVC))closeFoundCallback;

@end
