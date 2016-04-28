//
//  LFCategory.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseModel.h"

@interface LFCategory : LFBaseModel

@property(nonatomic, copy) NSString *parentId;

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSArray<LFCategory *> *subitems;

@end
