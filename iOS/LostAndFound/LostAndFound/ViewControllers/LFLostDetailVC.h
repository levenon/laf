//
//  LFLostDetailVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFNoticeDetailVC.h"

#import "LFLost.h"

@interface LFLostDetailVC : LFNoticeDetailVC

@property(nonatomic, strong, readonly) LFLost *evLost;

- (instancetype)initWithLost:(LFLost *)lost closeLostCallback:(void (^)(LFLostDetailVC *lostDetailVC))closeLostCallback;

@end
