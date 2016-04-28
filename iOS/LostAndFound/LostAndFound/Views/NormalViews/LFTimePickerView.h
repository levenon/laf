//
//  LFTimePickerView.h
//  LostAndFound
//
//  Created by Marike Jave on 15/10/13.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFTimePickerView;

@protocol LFTimePickerViewDelegate <NSObject>

- (void)epTimePickerView:(LFTimePickerView *)timePickerView didPickDateTime:(NSDate*)date;

@end

@interface LFTimePickerView : UIView

@property (assign , nonatomic, readonly) id<LFTimePickerViewDelegate> evDelegate;

- (id)initWithDelegate:(id<LFTimePickerViewDelegate>)delegate
                  date:(NSDate*)date
               minDate:(NSDate*)minDate
               maxDate:(NSDate*)maxDate
                  mode:(UIDatePickerMode)mode;

- (void)efShowInView:(UIView *)inView;

@end