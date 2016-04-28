//
//  LFEditablePhotoBrowserVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/26.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFPhotoBrowserVC.h"

@class LFEditablePhotoBrowserVC;

@protocol LFEditablePhotoBrowserDelegate <LFPhotoBrowserDelegate>

@optional
- (void)epEditablePhotoBrowserVC:(LFEditablePhotoBrowserVC *)editablePhotoBrowserVC didDeleteAtIndex:(NSInteger)nIndex;

@end

@interface LFEditablePhotoBrowserVC : LFPhotoBrowserVC

@end
