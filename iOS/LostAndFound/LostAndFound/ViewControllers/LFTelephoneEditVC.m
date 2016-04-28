//
//  LFTelephoneEditVC.m
//  LostAndFound
//
//  Created by Marike Jave on 16/3/17.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import <SMS_SDK/SMSSDK.h>

#import "LFTelephoneEditVC.h"

@interface LFTextEditVC ()

@property(nonatomic, strong) LFTextField *evtxfInput;

- (void)_efInstallConstraints;

- (void)_efConfirm;

@end

@interface LFTelephoneEditVC ()<UITextFieldDelegate>

@property(nonatomic, strong) LFTextField *evtxfVerifyCode;

@property(nonatomic, strong) UIButton *evbtnSendVerifyCode;

@property(nonatomic, copy  ) LFVerifyCode *evVerifyCode;

@property(nonatomic, strong) NSTimer *evCountdownTimer;

@property(nonatomic, assign) NSInteger evDownCount;

@end

@implementation LFTelephoneEditVC

- (void)loadView{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor colorWithHexRGB:0x484e59]];
    
    [[self view] addSubview:[self evtxfVerifyCode]];
    [[self view] addSubview:[self evbtnSendVerifyCode]];

    [[self evtxfInput] setDelegate:nil];
    [[self evtxfInput] setReturnKeyType:UIReturnKeyNext];
    [[self evtxfInput] setKeyboardType:UIKeyboardTypeNumberPad];
    [[self evtxfInput] setTextLimitInputType:XLFTextLimitInputTypeTelephoneNumber];
}

#pragma mark - accessory

- (LFTextField *)evtxfVerifyCode{
    
    if (!_evtxfVerifyCode) {
        
        _evtxfVerifyCode = [LFTextField emptyFrameView];
        
        [_evtxfVerifyCode setPlaceholder:@"验证码"];
        [_evtxfVerifyCode setReturnKeyType:UIReturnKeyDone];
        [_evtxfVerifyCode setTextLimitType:XLFTextLimitTypeLength];
        [_evtxfVerifyCode setTextLimitSize:4];
        [_evtxfVerifyCode setKeyboardType:UIKeyboardTypeNumberPad];
        [_evtxfVerifyCode setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_lock"]];
        [_evtxfVerifyCode setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_lock_ing"]];
        [_evtxfVerifyCode setNeedsDefaultStyle];
        [_evtxfVerifyCode setNeedsBorder];
        [_evtxfVerifyCode setDelegate:self];
    }
    return _evtxfVerifyCode;
}

- (UIButton *)evbtnSendVerifyCode{
    
    if (!_evbtnSendVerifyCode) {
        
        _evbtnSendVerifyCode = [UIButton emptyFrameView];
        
        [_evbtnSendVerifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_evbtnSendVerifyCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_evbtnSendVerifyCode setBackgroundColor:[UIColor colorWithHexRGB:0x6a6f7b]];
        [[_evbtnSendVerifyCode layer] setBorderWidth:1];
        [[_evbtnSendVerifyCode layer] setBorderColor:[[UIColor lightTextColor] CGColor]];
        [_evbtnSendVerifyCode addTarget:self action:@selector(didClickSendVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnSendVerifyCode;
}

#pragma mark - private

- (void)_efInstallConstraints{
    [super _efInstallConstraints];
    
    Weakself(ws);
    [[self evtxfVerifyCode] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.top.equalTo(ws.evtxfInput.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [[self evbtnSendVerifyCode] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evtxfVerifyCode.mas_right).offset(8);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.centerY.equalTo(ws.evtxfVerifyCode.mas_centerY).offset(0);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
}

- (BOOL)_efShouldSendVerifyCode;{
    
    NSString *input = [[self evtxfInput] text];
    if (![input length]) {
        
        [MBProgressHUD showWithStatus:@"手机号不可为空"];
        return NO;
    }
    if (![input isTelephoneFullNumber]) {
        
        [MBProgressHUD showWithStatus:@"手机号输入有误"];
        return NO;
    }
    return YES;
}

- (void)_efSendVerifyCode{
    
    [[self evbtnSendVerifyCode] startLoading];
    Weakself(ws);
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:[[self evtxfInput] text]
                                   zone:@"86"
                       customIdentifier:egShareSDKSmsTemplate
                                 result:^(NSError *error)
     {
         NIF_DEBUG(@"验证码发送%@, error : %@", select(error, @"失败",@"成功"), error);
         [MBProgressHUD showWithStatus:fmts(@"验证码发送%@", select(error, @"失败",@"成功"))];
         
         [[ws evbtnSendVerifyCode] stopLoading];
         if (!error) {
             [ws _efSendVerifyCodeEnd];
         }
     }];
}

- (LFVerifyCodeSuccessedBlock)_efSendVerifyCodeSuccessBlock{
    
    Weakself(ws);
    
    LFVerifyCodeSuccessedBlock success = ^(LFHttpRequest *request ,id result ,LFVerifyCode *verifyCode){
        
        [MBProgressHUD showSuccessWithStatus:@"验证码已发送至您的手机"];
        
        [ws setEvVerifyCode:verifyCode];
        
        [ws _efSendVerifyCodeEnd];
    };
    return success;
}

- (XLFFailedBlock)_efSendVerifyCodeFailedBlock{
    
    XLFFailedBlock failure = ^(XLFBaseHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
    return failure;
}

- (void)_efSendVerifyCodeEnd{
    
    [[self evbtnSendVerifyCode] stopLoading];
    [[self evbtnSendVerifyCode] setEnabled:NO];
    [self setEvDownCount:60];
    
    [self _efScheduleCountdownTimer];
}

- (BOOL)_efShouldModifyTelephone{
    
    if (![[[self evtxfInput] text] length]) {
        
        [MBProgressHUD showWithStatus:@"手机号不可以为空"];
        return NO;
    }
    
    if (![[[self evtxfInput] text] isTelephoneFullNumber]) {
        
        [MBProgressHUD showWithStatus:@"手机号不正确"];
        return NO;
    }
    
    if (![[[self evtxfVerifyCode] text] length]) {
        
        [MBProgressHUD showWithStatus:@"验证码不可为空"];
        return NO;
    }
    
    return YES;
}

- (void)_efModifyTelephone{
    
    LFHttpRequest *etreqVerifyAuthCode = [self efModifyTelephone:[[self evtxfInput] text]
                                                            code:[[self evtxfVerifyCode] text]
                                                            zone:@"86"
                                                         success:[self _efModifyTelephoneSuccess]
                                                         failure:[self _efModifyTelephoneFailed]];
    
    [etreqVerifyAuthCode setHiddenLoadingView:NO];
    [etreqVerifyAuthCode startAsynchronous];
}

- (XLFNoneResultSuccessedBlock)_efModifyTelephoneSuccess{
    
    return ^(id request){
        
        [self _efConfirm];
    };
}

- (XLFFailedBlock)_efModifyTelephoneFailed{
    
    return ^(id request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
    };
}

- (void)_efScheduleCountdownTimer{
    
    [self _efDestroyCountdownTimer];
    
    [self setEvCountdownTimer:[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(didTimerTriggerCountdown:) userInfo:nil repeats:YES]];
}

- (void)_efDestroyCountdownTimer{
    
    if ([self evCountdownTimer]) {
        
        [[self evCountdownTimer] invalidate];
        [self setEvCountdownTimer:nil];
    }
}

#pragma mark - actions

- (IBAction)didClickSendVerifyCode:(id)sender{
    
    [[self evtxfVerifyCode] setText:nil];
    
    if ([self _efShouldSendVerifyCode]) {
        
        [self _efSendVerifyCode];
    }
}

- (IBAction)didClickConfirm:(id)sender{
    
    if ([self _efShouldModifyTelephone]) {
        
        [self _efModifyTelephone];
    }
}

- (IBAction)didTimerTriggerCountdown:(id)sender{
    
    self.evDownCount--;
    
    [[self evbtnSendVerifyCode] setTitle:itos([self evDownCount]) forState:UIControlStateDisabled];
    
    if ([self evDownCount] <= 0) {
        
        [self _efDestroyCountdownTimer];
        
        [[self evbtnSendVerifyCode] setEnabled:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    
    if ([self _efShouldModifyTelephone]) {
        
        [self _efModifyTelephone];
    }
    
    return YES;
}

@end
