//
//  LFMapView.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/21.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFMapView.h"

@implementation LFMapView

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    UIImageView *etimgvLogo = [XLFRunTime ivarValue:self ivarName:@"_logoView"];
    
    [etimgvLogo removeFromSuperview];
}

@end
