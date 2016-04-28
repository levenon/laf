//
//  LFContactInfoVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/30.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

#import "LFUser.h"

@interface LFContactInfoVC : LFBaseViewController

@property(nonatomic, strong, readonly) LFUser *evUser;

- (instancetype)initWithTitle:(NSString *)title contactInfo:(LFUser *)contactInfo;

@end
