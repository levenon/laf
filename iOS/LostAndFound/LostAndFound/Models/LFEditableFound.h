//
//  LFEditableFound.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/28.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFEditableNotice.h"

@interface LFEditableFound : LFEditableNotice

@property(nonatomic, strong, readonly) LFFound *found;

@end
