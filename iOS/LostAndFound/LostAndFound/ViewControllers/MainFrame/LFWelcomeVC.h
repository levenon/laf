//
//  LFWelcomeVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/10/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

@interface LFWelcomeVC : LFBaseViewController

- (id)initWithTransformCallback:(void (^)(LFWelcomeVC *welcomeVC, UIViewController *viewController))blcTransformCallback
                       callback:(void (^)(LFWelcomeVC *welcomeVC, UIViewController *viewController, void (^afterCallback)()))blcOverCallback;

@end
