//
//  LFBaseModel.h
//  LostAndFound
//
//  Created by Marike Jave on 14-12-5.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <XLFBaseModelKit/XLFBaseModelKit.h>
#import <XLFCommonKit/XLFCommonKit.h>
#import "LFConstants.h"

@interface LFBaseModel : XLFBaseModel

@property( nonatomic,  copy  ) NSString  *id; 

@end

@interface NSArray (MultipleId)

@property(nonatomic, strong, readonly) NSSet *ids;

@end