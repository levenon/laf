//
//  CategoryStoryboardSegue.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-28.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import "LFCategoryStoryboardSegue.h"

@implementation LFCategoryStoryboardSegue

- (void)perform;{
    
    UIViewController *src = (UIViewController *)[self sourceViewController];
    UIViewController *dst = (UIViewController *)[self destinationViewController];
//
//    CATransition *animation=[CATransition animation];
//    [animation setDuration:0.5];
//    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromTop];
    [[src navigationController] pushViewController:dst animated:YES];
//    [[[src view] layer] addAnimation:animation forKey:nil];


}



@end
