//
//  LFScrollView
//  LostAndFound
//
//  Created by Marike Jave on 14-12-17.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFScrollView;

@protocol LFScrollViewTouchDelegate <NSObject>
@optional
- (void)scrollView:(LFScrollView *)scrollView
      touchesBegan:(NSSet *)touches
         withEvent:(UIEvent *)event;
- (void)scrollView:(LFScrollView *)scrollView
  touchesCancelled:(NSSet *)touches
         withEvent:(UIEvent *)event;
- (void)scrollView:(LFScrollView *)scrollView
      touchesEnded:(NSSet *)touches
         withEvent:(UIEvent *)event;
- (void)scrollView:(LFScrollView *)scrollView
      touchesMoved:(NSSet *)touches
         withEvent:(UIEvent *)event;
@end


@interface LFScrollView : UIScrollView

@property(nonatomic, assign) IBOutlet id<LFScrollViewTouchDelegate> evDelegate;

@end
