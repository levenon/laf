//
//  LFAddressSelectorCell.m
//  LFrivingCustomer
//
//  Created by Marike Jave on 15/8/19.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "LFAddressSelectorCell.h"

const NSInteger LFAddressSelectorCellContentEdge = 21;

@interface LFAddressSelectorCell ()<XLFTableViewCellInterface>

@end

@implementation LFAddressSelectorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self epConfigSubViewsDefault];
    }
    return self;
}

#pragma mark - XLFTableViewCellInterface

- (void)epConfigSubViewsDefault{
    
    [[self textLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    [[self detailTextLabel] setFont:[UIFont systemFontOfSize:44/3.]];
    
    [[self textLabel] setTextColor:[UIColor colorWithHexRGB:0x020202]];
    [[self detailTextLabel] setTextColor:[UIColor colorWithHexRGB:0xB7B8B9]];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [[self contentView] setBackgroundColor:[UIColor whiteColor]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)epConfigSubViews{
    
    [[self textLabel] setText:[[self evAddress] name]];
    [[self detailTextLabel] setText:[[self evAddress] address]];
}

- (void)setEvAddress:(LFLocation *)evAddress{
    
    if (_evAddress != evAddress) {
        
        _evAddress = evAddress;
    }
    
    [self epConfigSubViews];
}

@end
