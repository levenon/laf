//
//  LFUserCenterVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/13.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"
#import "LFMenuController.h"

@interface LFUserCenterVC : LFBaseViewController<LFMenuControllerChild, LFMenuControllerPresenting>

@property(nonatomic, assign) LFMenuController *menu;

@end
