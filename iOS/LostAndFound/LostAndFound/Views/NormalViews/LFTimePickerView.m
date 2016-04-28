//
//  LFTimePickerView.m
//  LostAndFound
//
//  Created by Marike Jave on 15/10/13.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFTimePickerView.h"

@interface LFTimePickerView()<UIScrollViewDelegate>

@property(nonatomic, assign) id<LFTimePickerViewDelegate> evDelegate;

@property(nonatomic, strong) UIDatePicker *evDatePicker;
@property(nonatomic, strong) UIDatePicker *evTimePicker;

@property(nonatomic, strong) NSDate *evDate;
@property(nonatomic, strong) NSDate *evMinDate;
@property(nonatomic, strong) NSDate *evMaxDate;
@property(nonatomic, assign) UIDatePickerMode evDatePickerMode;

@property(nonatomic, strong) UIToolbar *evToolbar;
@property(nonatomic, strong) UIView *evvTouchBackground;
@property(nonatomic, strong) UIScrollView *evscvPickerContainer;
@property(nonatomic, strong) UIBarButtonItem *evbbiTitle;

@end

@implementation LFTimePickerView

- (id)initWithDelegate:(id<LFTimePickerViewDelegate>)delegate
                  date:(NSDate*)date
               minDate:(NSDate*)minDate
               maxDate:(NSDate*)maxDate
                  mode:(UIDatePickerMode)mode;{
    self = [super initWithFrame:CGRectMakePS(CGPointZero, CGRectGetSize([[UIScreen mainScreen] bounds]))];

    if (self) {
        
        [self setEvDate:date];
        [self setEvMinDate:minDate];
        [self setEvMaxDate:maxDate];
        [self setEvDelegate:delegate];
        [self setEvDatePickerMode:mode];
        
        [self epCreateSubViews];
        [self epConfigSubViewsDefault];
        [self epInstallConstraints];
        [self epConfigSubViews];
    }
    return self;
}

- (void)epCreateSubViews{
    
    [self setEvvTouchBackground:[UIView emptyFrameView]];
    [self setEvToolbar:[UIToolbar emptyFrameView]];
    [self setEvDatePicker:[UIDatePicker emptyFrameView]];
    [self setEvscvPickerContainer:[UIScrollView emptyFrameView]];
    [self setEvbbiTitle:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil]];
    
    [self addSubview:[self evvTouchBackground]];
    [self addSubview:[self evscvPickerContainer]];
    [self addSubview:[self evToolbar]];
    
    [[self evscvPickerContainer] addSubview:[self evDatePicker]];
    
    if ([self evDatePickerMode] == UIDatePickerModeDateAndTime) {
        [self setEvTimePicker:[UIDatePicker emptyFrameView]];
        [[self evscvPickerContainer] addSubview:[self evTimePicker]];
    }
}

- (void)epConfigSubViewsDefault{
    
    [[self evvTouchBackground] setAlpha:0];
    [[self evvTouchBackground] setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [[self evvTouchBackground] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickBackgroundView:)]];

    [[self evscvPickerContainer] setDelegate:self];
    [[self evscvPickerContainer] setPagingEnabled:YES];
    [[self evscvPickerContainer] setDecelerationRate:0];
    [[self evscvPickerContainer] setShowsVerticalScrollIndicator:NO];
    [[self evscvPickerContainer] setShowsHorizontalScrollIndicator:NO];
    
    [[self evDatePicker] setBackgroundColor:[UIColor whiteColor]];
    
    if ([self evDatePickerMode] == UIDatePickerModeDateAndTime) {
        [[self evTimePicker] setBackgroundColor:[UIColor whiteColor]];
    }
    
    UIBarButtonItem *leftFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightFlexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:8];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self action:@selector(didClickDone:)];
    [[self evbbiTitle] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName:[UIColor grayColor]}
                        forState:UIControlStateNormal];
    [done setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                   NSForegroundColorAttributeName:[UIColor colorWithHexRGB:0x5aca1d]}
                        forState:UIControlStateNormal];
    
    [[self evToolbar] setItems:@[leftFlexibleSpace, [self evbbiTitle], rightFlexibleSpace , done, fixedSpace]];
    
    if ([self evDatePickerMode] == UIDatePickerModeTime) {
        
        [[self evbbiTitle] setTitle:@"时间"];
    }
    else{
        
        [[self evbbiTitle] setTitle:@"日期"];
    }
}

- (void)epInstallConstraints{
    
    Weakself(ws);
    
    [[self evvTouchBackground] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).insets(UIEdgeInsetsZero);
    }];
    
    [[self evToolbar] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(0);
        make.right.equalTo(ws.mas_right).offset(0);
        make.top.equalTo(ws.mas_bottom).offset(0);
    }];
    
    [[self evscvPickerContainer] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.mas_left).offset(0);
        make.right.equalTo(ws.mas_right).offset(0);
        make.top.equalTo(ws.evToolbar.mas_bottom).offset(0);
//        make.bottom.equalTo(ws.mas_bottom).offset(0);
    }];
    
    if ([self evDatePickerMode] == UIDatePickerModeDateAndTime) {
        
        [[self evDatePicker] mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ws.evscvPickerContainer.mas_left).offset(0);
            make.top.equalTo(ws.evscvPickerContainer.mas_top).offset(0);
            make.bottom.equalTo(ws.evscvPickerContainer.mas_bottom).offset(0);
            make.height.equalTo(ws.evscvPickerContainer.mas_height).offset(0);
            make.width.equalTo(ws.mas_width).offset(0);
        }];
        
        [[self evTimePicker] mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ws.evDatePicker.mas_right).offset(0);
            make.top.equalTo(ws.evscvPickerContainer.mas_top).offset(0);
            make.bottom.equalTo(ws.evscvPickerContainer.mas_bottom).offset(0);
            make.right.equalTo(ws.evscvPickerContainer.mas_right).offset(0);
            make.width.equalTo(ws.mas_width).offset(0);
        }];
    }
    else{
        
        [[self evDatePicker] mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ws.evscvPickerContainer.mas_left).offset(0);
            make.right.equalTo(ws.evscvPickerContainer.mas_right).offset(0);
            make.top.equalTo(ws.evscvPickerContainer.mas_top).offset(0);
            make.bottom.equalTo(ws.evscvPickerContainer.mas_bottom).offset(0);
            make.height.equalTo(ws.evscvPickerContainer.mas_height).offset(0);
        }];
    }
}

- (void)epConfigSubViews{
    
    [[self evDatePicker] setDate:[self evDate]];
    [[self evDatePicker] setMinimumDate:[self evMinDate]];
    [[self evDatePicker] setMaximumDate:[self evMaxDate]];
    
    if ([self evDatePickerMode] == UIDatePickerModeDateAndTime) {
        [[self evDatePicker] setDatePickerMode:UIDatePickerModeDate];
        [[self evTimePicker] setDatePickerMode:UIDatePickerModeTime];
    }
    else {
        [[self evDatePicker] setDatePickerMode:[self evDatePickerMode]];
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    if ([self superview]) {
        
        Weakself(ws);
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(ws.superview).insets(UIEdgeInsetsZero);
        }];
    }
}

- (void)dealloc{
    
    [self setEvDate:nil];
    [self setEvMaxDate:nil];
    [self setEvMinDate:nil];
    [self setEvToolbar:nil];
    [self setEvDelegate:nil];
    [self setEvDatePicker:nil];
    [self setEvTimePicker:nil];
    [self setEvvTouchBackground:nil];
    [self setEvscvPickerContainer:nil];
}

#pragma mark - actions

- (IBAction)didClickDone:(id)sender{
    
    [self _efFinishPickDate];
}

- (IBAction)didClickBackgroundView:(UITapGestureRecognizer*)recognizer{
    
    [self _efUpdateDisplay:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([self evDatePickerMode] == UIDatePickerModeTime) {
        
        [[self evbbiTitle] setTitle:@"时间"];
    }
    else if ([self evDatePickerMode] == UIDatePickerModeDate){
        
        [[self evbbiTitle] setTitle:@"日期"];
    }
    else if ([self evDatePickerMode] == UIDatePickerModeDateAndTime){
        
        [[self evbbiTitle] setTitle:[@[@"日期", @"时间"] objectAtIndex:[scrollView contentOffset].x / CGRectGetWidth([self bounds])]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;{
    
    NSDate *etNow = [NSDate date];
    NSDateComponents *etToday = [NSDateComponents components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:etNow];
    NSDateComponents *etSelectedDay = [NSDateComponents components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[self evDatePicker] date]];
    
    [[self evTimePicker] setMinimumDate:[NSDate dateFromString:@"00:00" format:@"HH:mm"]];
    
    if ([etSelectedDay year] == [etToday year] &&
        [etSelectedDay month] == [etToday month] &&
        [etSelectedDay day] == [etToday day]) {
        
        [[self evTimePicker] setDate:etNow];
        [[self evTimePicker] setMaximumDate:[NSDate dateFromString:fmts(@"%2d:%2d", [etToday hour], [etToday minute]) format:@"HH:mm"]];
    }
    else{
        [[self evTimePicker] setMaximumDate:[NSDate dateFromString:@"24:00" format:@"HH:mm"]];
    }
}

#pragma mark - operator
- (void)_efUpdateDisplay:(BOOL)dispaly{
    
    if (dispaly) {
        [[self evvTouchBackground] setAlpha:0];
    }
    
    [self layoutIfNeeded];
    
    Weakself(ws);
    [UIView animateWithDuration:0.3 animations:^{
        
        [[ws evvTouchBackground] setAlpha:dispaly];
        
        [[ws evToolbar] mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ws.mas_left).offset(0);
            make.right.equalTo(ws.mas_right).offset(0);
            
            if (!dispaly) {
                make.top.equalTo(ws.mas_bottom).offset(0);
            }
        }];
        
        [[ws evscvPickerContainer] mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(ws.mas_left).offset(0);
            make.right.equalTo(ws.mas_right).offset(0);
            make.top.equalTo(ws.evToolbar.mas_bottom).offset(0);
            
            if (dispaly) {
                make.bottom.equalTo(ws.mas_bottom).offset(0);
            }
        }];
        [ws layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (!dispaly) {
            [ws removeFromSuperview];
        }
    }];
}

- (void)_efFinishPickDate{
    
    [self _efUpdateDisplay:NO];
    
    if ([self evDelegate] && [[self evDelegate] respondsToSelector:@selector(epTimePickerView:didPickDateTime:)]) {
        
        NSDateComponents *etDate = [NSDateComponents components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[[self evDatePicker] date]];
        NSDateComponents *etTime = [NSDateComponents components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[[self evTimePicker] date]];
        
        NSDate *etSelectedDateTime = [NSDate dateFromString:fmts(@"%4d-%2d-%2d %2d:%2d", [etDate year], [etDate month], [etDate day], [etTime hour], [etTime minute]) format:@"yyyy-MM-dd HH:mm"];
        
        NIF_INFO(@"%@", [etSelectedDateTime dateStringWithFormat:@"yyyy-MM-dd HH:mm"]);
        
        [[self evDelegate] epTimePickerView:self didPickDateTime:etSelectedDateTime];
    }
}

#pragma mark - public

- (void)efShowInView:(UIView *)inView;{
    
    if ([inView isKindOfClass:[UIScrollView class]]) {
        inView = [[[UIApplication sharedApplication] delegate] window];
    }
    
    [inView addSubview:self];
    
    [self _efUpdateDisplay:YES];
}

@end
