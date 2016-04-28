//
//  LFCommonImagesSelectorVC.h
//  LostAndFound
//
//  Created by Marike Jave on 16/2/21.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFBaseTableViewController.h"

@interface LFCommonImagesSelectorVC : LFBaseTableViewController

- (id)initWithImageSelectCallback:(void (^)(LFCommonImagesSelectorVC *commonImagesSelectorVC, LFPhoto *photo))imageSelectCallback;

@end
