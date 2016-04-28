//
//  FindPasswordVC.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <SMS_SDK/SMSSDK.h>

#import "LFFindPasswordVC.h"

#import "LFHttpRequestManager.h"
#import "LFLoginManager.h"

#import "LFTextField.h"

#import "LFVerifyCode.h"

@interface LFFindPasswordVC ()<UITextFieldDelegate>

@property(nonatomic, copy) void(^evblcFindPasswordCallback)(LFFindPasswordVC *findPasswordVC, BOOL success, NSString *username, NSString *password);

@property(nonatomic, strong) LFTextField *evtxfTelephone;
@property(nonatomic, strong) LFTextField *evtxfVerifyCode;
@property(nonatomic, strong) LFTextField *evtxfNewPassword;
@property(nonatomic, strong) UIButton *evbtnSendVerifyCode;
@property(nonatomic, strong) UIButton *evbtnConfirm;

@property(nonatomic, strong) LFVerifyCode *evVerifyCode;

@property(nonatomic, strong) NSTimer *evCountdownTimer;

@property(nonatomic, assign) NSInteger evDownCount;

@end

@implementation LFFindPasswordVC

- (id)initWithFindPasswordCallback:(void (^)(LFFindPasswordVC *findPasswordVC, BOOL success, NSString *username, NSString *password))findPasswordCallback;{
    
    self = [super init];
    if (self) {
        [self setTitle:@"找回密码"];
        [self setEvblcFindPasswordCallback:findPasswordCallback];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor colorWithHexRGB:0x484e59]];
    [[self view] addSubview:[self evtxfTelephone]];
    [[self view] addSubview:[self evtxfVerifyCode]];
    [[self view] addSubview:[self evbtnSendVerifyCode]];
    [[self view] addSubview:[self evtxfNewPassword]];
    [[self view] addSubview:[self evbtnConfirm]];
    
    [self _efInstallConstraints];
}

#pragma mark - accessory

- (LFTextField *)evtxfTelephone{
    
    if (!_evtxfTelephone) {
        
        _evtxfTelephone = [LFTextField emptyFrameView];
        
        [_evtxfTelephone setPlaceholder:@"手机号"];
        [_evtxfTelephone setReturnKeyType:UIReturnKeyNext];
        [_evtxfTelephone setKeyboardType:UIKeyboardTypeNumberPad];
        [_evtxfTelephone setTextLimitInputType:XLFTextLimitInputTypeTelephoneNumber];
        [_evtxfTelephone setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_user"]];
        [_evtxfTelephone setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_user_ing"]];
        [_evtxfTelephone setNeedsDefaultStyle];
        [_evtxfTelephone setNeedsBorder];
    }
    return _evtxfTelephone;
}

- (LFTextField *)evtxfVerifyCode{
    
    if (!_evtxfVerifyCode) {
        
        _evtxfVerifyCode = [LFTextField emptyFrameView];
        
        [_evtxfVerifyCode setPlaceholder:@"验证码"];
        [_evtxfVerifyCode setReturnKeyType:UIReturnKeyNext];
        [_evtxfVerifyCode setKeyboardType:UIKeyboardTypeNumberPad];
        [_evtxfVerifyCode setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_lock"]];
        [_evtxfVerifyCode setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_lock_ing"]];
        [_evtxfVerifyCode setNeedsDefaultStyle];
        [_evtxfVerifyCode setNeedsBorder];
    }
    return _evtxfVerifyCode;
}

- (LFTextField *)evtxfNewPassword{
    
    if (!_evtxfNewPassword) {
        
        _evtxfNewPassword = [LFTextField emptyFrameView];
        
    //        [_evtxfNewPassword setHidden:YES];
        [_evtxfNewPassword setSecureTextEntry:YES];
        [_evtxfNewPassword setPlaceholder:@"请输入密码"];
        [_evtxfNewPassword setReturnKeyType:UIReturnKeyDone];
        [_evtxfNewPassword setRightViewMode:UITextFieldViewModeWhileEditing];
        [_evtxfNewPassword setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_lock"]];
        [_evtxfNewPassword setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_lock_ing"]];
        [_evtxfNewPassword setNeedsDefaultStyle];
        [_evtxfNewPassword setNeedsBorder];
        
        UIButton *etbtnExchangePasswordDisyplayState = [[UIButton alloc] initWithFrame:CGRectMakePWH(CGPointZero, 35, 35)];
        
        [etbtnExchangePasswordDisyplayState setImage:[UIImage imageNamed:@"btn_eye_normal"] forState:UIControlStateNormal];
        [etbtnExchangePasswordDisyplayState setImage:[UIImage imageNamed:@"btn_eye_selected"] forState:UIControlStateSelected];
        [etbtnExchangePasswordDisyplayState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [etbtnExchangePasswordDisyplayState setTitleColor:[UIColor colorWithHexRGB:0x111111] forState:UIControlStateSelected];
        [etbtnExchangePasswordDisyplayState addTarget:self action:@selector(didClickExchangePasswordDisyplayState:) forControlEvents:UIControlEventTouchUpInside];
        
        [_evtxfNewPassword  setRightView:etbtnExchangePasswordDisyplayState];
    }
    return _evtxfNewPassword;
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

- (UIButton *)evbtnConfirm{
    
    if (!_evbtnConfirm) {
        
        _evbtnConfirm = [UIButton emptyFrameView];
        
        [_evbtnConfirm setTitle:@"确认" forState:UIControlStateNormal];
        [_evbtnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_evbtnConfirm setBackgroundColor:[UIColor colorWithHexRGB:0x6a6f7b]];
        //        [_evbtnConfirm setHidden:YES];
        [[_evbtnConfirm layer] setCornerRadius:5];
        [[_evbtnConfirm layer] setBorderWidth:1];
        [[_evbtnConfirm layer] setBorderColor:[[UIColor lightTextColor] CGColor]];
        [_evbtnConfirm addTarget:self action:@selector(didClickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnConfirm;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtxfTelephone] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.view.mas_top).offset(50 + STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@40);
    }];
    
    [[self evtxfVerifyCode] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.top.equalTo(ws.evtxfTelephone.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [[self evbtnSendVerifyCode] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evtxfVerifyCode.mas_right).offset(8);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.centerY.equalTo(ws.evtxfVerifyCode.mas_centerY).offset(0);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    [[self evtxfNewPassword] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.evtxfVerifyCode.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [[self evbtnConfirm] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.evtxfNewPassword.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
}

- (BOOL)_efShouldSendVerifyCode;{
    
    NSString *input = [[self evtxfTelephone] text];
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

- (BOOL)_efShouldResetPassword{
    
    if (![[[self evtxfVerifyCode] text] length]) {
        
        [MBProgressHUD showWithStatus:@"验证码不可以为空"];
        return NO;
    }
    
    if (![[[self evtxfNewPassword] text] length]) {
        
        [MBProgressHUD showWithStatus:@"新密码不可以为空"];
        return NO;
    }
    
    return YES;
}

#pragma mark - actions

- (IBAction)didClickExchangePasswordDisyplayState:(UIButton *)sender{
    [sender setSelected:![sender isSelected]];
    
    [[self evtxfNewPassword] setSecureTextEntry:![sender isSelected]];
    [[self evtxfNewPassword] endFloatingCursor];
}

- (IBAction)didValueChangedSelector:(XLFSegmentControl*)sender {
    
    [[self evtxfTelephone] setPlaceholder:select([sender selectedSegmentIndex],@"手机号码", @"邮箱")];
    [[self evtxfTelephone] setText:nil];
}

- (IBAction)didClickSendVerifyCode:(id)sender {
    
    if ([self _efShouldSendVerifyCode]) {
        [self _efSendVerifyCode];
    }
}

- (IBAction)didClickConfirm:(id)sender{
    
    if ([self _efShouldResetPassword]) {
        [self _efResetPassword];
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

#pragma mark - Http Request Block

- (void)_efSendVerifyCode{
    
    //    LFHttpRequest *etRequest = [self efSendCodeWithTelephone:[[self evtxfTelephone] text]
    //                                                       email:[[self evtxfTelephone] text]
    //                                                        type:LFVerifyTypeTelephone
    //                                                     success:[self _efSendVerifyCodeSuccessBlock]
    //                                                     failure:[self _efSendVerifyCodeFailedBlock]];
    //    [etRequest startAsynchronous];
    
    [[self evbtnSendVerifyCode] startLoading];
    Weakself(ws);
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:[[self evtxfTelephone] text]
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


- (void)_efResetPassword;{
    
    LFHttpRequest *etRequest = [self efResetPasswordWithAccount:[[self evtxfTelephone] text]
                                                    newPassword:[[self evtxfNewPassword] text]
                                                   platformType:LFPlatformTypeTelephone
                                                           zone:@"86"
                                                           code:[[self evtxfVerifyCode] text]
                                                         secret:[[self evVerifyCode] secret]
                                                        success:[self _efResetPasswordSuccessBlock]
                                                        failure:[self _efResetPasswordFailedBlock]];
    
    [etRequest startAsynchronous];
}

- (XLFNoneResultSuccessedBlock)_efResetPasswordSuccessBlock{
    
    Weakself(ws);
    XLFNoneResultSuccessedBlock success = ^(LFHttpRequest *request){
                
        if ([ws evblcFindPasswordCallback]) {
            ws.evblcFindPasswordCallback(ws, YES, [[ws evtxfTelephone] text], [[ws evtxfNewPassword] text]);
        }
        
    };
    return success;
}

- (XLFFailedBlock)_efResetPasswordFailedBlock{
    
    Weakself(ws);
    XLFFailedBlock failure = ^(XLFBaseHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
        
        ws.evblcFindPasswordCallback(ws, NO, [[ws evtxfTelephone] text], [[ws evtxfNewPassword] text]);
    };
    return failure;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    
    if ([self _efShouldResetPassword]) {
        
        [self _efResetPassword];
    }
    
    return YES;
}

@end
