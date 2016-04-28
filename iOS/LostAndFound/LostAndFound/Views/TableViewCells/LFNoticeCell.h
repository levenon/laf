//
//  LFNoticeCell.h
//  LostAndFound
//
//  Created by Marke Jave on 16/3/23.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LFNotice.h"

@interface LFNoticeCell : UITableViewCell<XLFTableViewCellDelegate>

@property(nonatomic, strong) LFNotice *evNotice;

@end
