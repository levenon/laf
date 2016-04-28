//
//  LFTextEditVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFTextEditVC.h"

@interface LFTextEditVC ()<UITextFieldDelegate>

@property(nonatomic, copy  ) NSString *evPlaceholderText;

@property(nonatomic, copy  ) void (^evblcTextEditCallback)(LFTextEditVC *textEditVC, NSString *inputText);

@property(nonatomic, strong) UIBarButtonItem *evbbiConfirm;

@property(nonatomic, strong) LFTextField *evtxfInput;

@end

@implementation LFTextEditVC

- (instancetype)initWithTitle:(NSString *)title
              placeholderText:(NSString *)placeholderText
                       textEditCallback:(void (^)(LFTextEditVC *textEditVC, NSString *inputText))textEditCallback;{
    self = [super init];
    
    if (self) {
        
        [self setTitle:title];
        [self setEvPlaceholderText:placeholderText];
        [self setEvblcTextEditCallback:textEditCallback];
        
        if ([placeholderText length]) {
            [[self evtxfInput] setText:placeholderText];
            [[self evtxfInput] setPlaceholder:placeholderText];
        }
        else{
            [[self evtxfInput] setPlaceholder:title];
        }
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiConfirm] type:XLFNavButtonTypeRight];
    
    [[self view] setBackgroundColor:[UIColor colorWithHexRGB:0x484e59]];
    [[self view] addSubview:[self evtxfInput]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _efInstallConstraints];
}

#pragma mark - accessory

- (UIBarButtonItem *)evbbiConfirm{
    
    if (!_evbbiConfirm) {
        
        _evbbiConfirm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                      target:self action:@selector(didClickConfirm:)];
    }
    return _evbbiConfirm;
}

- (LFTextField *)evtxfInput{
    
    if (!_evtxfInput) {
        
        _evtxfInput = [LFTextField emptyFrameView];
        [_evtxfInput setReturnKeyType:UIReturnKeyDone];
        [_evtxfInput setNeedsDefaultStyle];
        [_evtxfInput setNeedsBorder];
        [_evtxfInput setDelegate:self];
        [_evtxfInput setTextLimitType:XLFTextLimitTypeLength];
//        [_evtxfInput setTextLimitInputType:XLFTextLimitInputTypeTelephoneNumber];
    }
    return _evtxfInput;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtxfInput] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.view.mas_top).offset(50 + STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@40);
    }];
}

- (void)_efConfirm{
    
    if ([self evblcTextEditCallback]) {
        
        self.evblcTextEditCallback(self, [[self evtxfInput] text]);
    }
}

#pragma mark - actions

- (IBAction)didClickConfirm:(id)sender{
    
    [self _efConfirm];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    
    [self _efConfirm];

    return YES;
}

@end
