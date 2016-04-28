//
//  LFVerifyCode.h
//  LostAndFound
//
//  Created by Marike Jave on 16/1/12.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFVerifyCode : LFBaseModel

@property(nonatomic, copy) NSString *code;

@property(nonatomic, copy) NSString *secret;

@end
