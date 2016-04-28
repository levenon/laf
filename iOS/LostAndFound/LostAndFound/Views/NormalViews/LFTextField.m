//
//  LFTextField.m
//  LostAndFound
//
//  Created by Marike Jave on 14-12-19.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFTextField.h"

@interface LFTextField ()

@property(nonatomic, strong) UIImageView *evimgvLeft;
@property(nonatomic, strong) UIImageView *evimgvRight;

@property(nonatomic,getter=evIsHighlighted) BOOL evHighlighted;

@end

@implementation LFTextField

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _efConfigurate];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];

    [self _efConfigurate];
}

- (void)_efConfigurate{
    
    [self addTarget:self action:@selector(didTextFieldBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(didTextFieldEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    
    [[self layer] setMasksToBounds:YES];
    [self setText:nil];
    [self setBorderStyle:UITextBorderStyleNone];
    [self setEvNormalTextColor:[self textColor]];
    [self setEvNormalPlaceholderColor:[UIColor grayColor]];
    
    [self efUpdateTextFieldColor];
}

- (CGRect)textRectForBounds:(CGRect)bounds;{
    return CGRectMake(select(_evimgvLeft, [_evimgvLeft width], 0) + 10, 0, CGRectGetWidth(bounds) - select(_evimgvLeft, [_evimgvLeft width], 0) - select(_evimgvRight, [_evimgvRight width], 0) - 10, CGRectGetHeight(bounds));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds;{
    return CGRectMake(select(_evimgvLeft, [_evimgvLeft width], 0) + 10, 0, CGRectGetWidth(bounds) - select(_evimgvLeft, [_evimgvLeft width], 0) - select(_evimgvRight, [_evimgvRight width], 0) - 10, CGRectGetHeight(bounds));
}

- (CGRect)editingRectForBounds:(CGRect)bounds;{
    return CGRectMake(select(_evimgvLeft, [_evimgvLeft width], 0) + 10, 0, CGRectGetWidth(bounds) - select(_evimgvLeft, [_evimgvLeft width], 0) - select(_evimgvRight, [_evimgvRight width], 0) - 10, CGRectGetHeight(bounds));
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self efUpdateTextFieldColor];
}

- (void)setEvHighlighted:(BOOL)evHighlighted{
    _evHighlighted = evHighlighted;

    if (_evimgvLeft) {
        [[self evimgvLeft] setHighlighted:evHighlighted];
    }
    if (_evimgvRight) {
        [[self evimgvRight] setHighlighted:evHighlighted];
    }
    [self efUpdateTextFieldColor];
}

- (void)setEvNormalBorderColor:(UIColor *)evNormalBorderColor{
    _evNormalBorderColor = evNormalBorderColor;

    [[self layer] setBorderWidth:evNormalBorderColor!=nil];

    [self efUpdateTextFieldColor];
}

- (void)setEvHighlightedBorderColor:(UIColor *)evHighlightedBorderColor{
    _evHighlightedBorderColor = evHighlightedBorderColor;

    [self efUpdateTextFieldColor];
}

- (void)setEvDisableBorderColor:(UIColor *)evDisableBorderColor{
    _evDisableBorderColor = evDisableBorderColor;

    [self efUpdateTextFieldColor];
}

- (void)setEvNormalTextColor:(UIColor *)evNormalTextColor{
    _evNormalTextColor = evNormalTextColor;

    [self efUpdateTextFieldColor];
}

- (void)setEvHighlightedTextColor:(UIColor *)evHighlightedTextColor{
    _evHighlightedTextColor = evHighlightedTextColor;

    [self efUpdateTextFieldColor];
}

- (void)setEvNormalPlaceholderColor:(UIColor *)evNormalPlaceholderColor{
    _evNormalPlaceholderColor = evNormalPlaceholderColor;

    [self efUpdateTextFieldColor];
}

- (void)setEvHighlightedPlaceholderColor:(UIColor *)evHighlightedPlaceholderColor{
    _evHighlightedPlaceholderColor = evHighlightedPlaceholderColor;

    [self efUpdateTextFieldColor];
}

- (void)setEvimgNormalLeft:(UIImage *)evimgNormalLeft{

    if (evimgNormalLeft != _evimgNormalLeft) {

        if (!evimgNormalLeft && ![self evimgHightlightedLeft]) {
            [self efRemoveLeftView];
        }
        else{
            [[self evimgvLeft] setImage:evimgNormalLeft];
        }
        _evimgNormalLeft = evimgNormalLeft;
    }
}

- (void)setEvimgHightlightedLeft:(UIImage *)evimgHightlightedLeft{

    if (evimgHightlightedLeft != _evimgHightlightedLeft) {

        if (!evimgHightlightedLeft && ![self evimgNormalLeft]) {
            [self efRemoveLeftView];
        }
        else{
            [[self evimgvLeft] setHighlightedImage:evimgHightlightedLeft];
        }
        _evimgHightlightedLeft = evimgHightlightedLeft;
    }
}

- (void)setEvimgNormalRight:(UIImage *)evimgNormalRight{

    if (evimgNormalRight != _evimgNormalRight) {

        if (!evimgNormalRight && ![self evimgHightlightedRight]) {
            [self efRemoveRightView];
        }
        else{
            [[self evimgvRight] setImage:evimgNormalRight];
        }
        _evimgNormalRight = evimgNormalRight;
    }
}

- (void)setEvimgHightlightedRight:(UIImage *)evimgHightlightedRight{

    if (evimgHightlightedRight != _evimgHightlightedRight) {

        if (!evimgHightlightedRight && ![self evimgNormalRight]) {

            [self efRemoveRightView];
        }
        else{
            [[self evimgvRight] setHighlightedImage:evimgHightlightedRight];
        }
        _evimgHightlightedRight = evimgHightlightedRight;
    }
}

- (UIImageView*)evimgvLeft{
    if (!_evimgvLeft) {

        _evimgvLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, [self height])];
        [_evimgvLeft setContentMode:UIViewContentModeCenter];
        [self setLeftView:_evimgvLeft];
        [self setLeftViewMode:UITextFieldViewModeAlways];
    }
    return _evimgvLeft;
}

- (UIImageView*)evimgvRight{
    if (!_evimgvRight) {

        _evimgvRight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, [self height])];
        [_evimgvLeft setContentMode:UIViewContentModeCenter];
        [self setRightView:_evimgvRight];
        [self setRightViewMode:UITextFieldViewModeAlways];
    }
    return _evimgvRight;
}

- (void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:placeholder];

    [self efUpdateTextFieldColor];
}

- (void)efRemoveLeftView{

    [self setLeftView:nil];
    [self setEvimgvLeft:nil];
}

- (void)efRemoveRightView{

    [self setRightView:nil];
    [self setEvimgvRight:nil];
}

- (void)efUpdateTextFieldColor{

    [self setTextColor:[self evNormalTextColor]];

    [self setValue:select([self evNormalPlaceholderColor], [self evNormalPlaceholderColor], [UIColor grayColor]) forKeyPath:@"_placeholderLabel.textColor"];

    [[self layer] setBorderColor:[[self evNormalBorderColor] CGColor]];

    if ([self evIsHighlighted]) {

        if ([self evHighlightedTextColor]) {
            [self setTextColor:[self evHighlightedTextColor]];
        }
        if ([self evHighlightedBorderColor]) {
            [[self layer] setBorderColor:[[self evHighlightedBorderColor] CGColor]];
        }
        if ([self evHighlightedPlaceholderColor]) {
            [self setValue:[self evHighlightedPlaceholderColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
    }
    if (![self isEnabled]) {
        if ([self evDisableBorderColor]) {
            [[self layer] setBorderColor:[[self evDisableBorderColor] CGColor]];
        }
    }
}

#pragma mark - actions 

- (IBAction)didTextFieldBeginEditing:(LFTextField*)sender{

    [sender setEvHighlighted:YES];
}

- (IBAction)didTextFieldEndEditing:(LFTextField*)sender{

    [sender setEvHighlighted:NO];
}

#pragma mark - default

- (void)setNeedsDefaultStyle;{

    [self setEvNormalTextColor:[UIColor colorWithHexRGB:0x888b96]];
    [self setEvHighlightedTextColor:[UIColor colorWithHexRGB:0xc7cad3]];

    [self setEvNormalPlaceholderColor:[UIColor colorWithHexRGB:0x666974]];
    [self setEvHighlightedPlaceholderColor:[UIColor colorWithHexRGB:0x777a85]];
}

- (void)setNeedsBorder;{

    [self setEvNormalBorderColor:[UIColor colorWithHexRGB:0x888b96]];
    [self setEvHighlightedBorderColor:[UIColor colorWithHexRGB:0xc7cad3]];
}


@end
