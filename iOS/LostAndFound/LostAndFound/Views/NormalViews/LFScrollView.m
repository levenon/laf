//
//  LFScrollView
//  LostAndFound
//
//  Created by Marike Jave on 14-12-17.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFScrollView.h"

@implementation LFScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(scrollView:touchesBegan:withEvent:)]) {

        [[self evDelegate] scrollView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];

    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(scrollView:touchesEnded:withEvent:)]) {

        [[self evDelegate] scrollView:self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];

    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(scrollView:touchesMoved:withEvent:)]) {

        [[self evDelegate] scrollView:self touchesMoved:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];

    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(scrollView:touchesCancelled:withEvent:)]) {

        [[self evDelegate] scrollView:self touchesCancelled:touches withEvent:event];
    }
}


@end
