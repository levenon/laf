//
//  RegisterVC.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <SMS_SDK/SMSSDK.h>

#import "LFRegisterVC.h"

#import "LFUserManager.h"
#import "LFLoginManager.h"
#import "LFAppManager.h"
#import "LFTextField.h"

@interface LFRegisterVC ()<UITextFieldDelegate, LFHttpRequestManagerProtocol>

@property(nonatomic, copy) void (^evblcRegisterCallback)(LFRegisterVC *registerVC, BOOL success, NSString *username, NSString *password);

@property(nonatomic, strong) LFTextField *evtxfTelephone;
@property(nonatomic, strong) LFTextField *evtxfPassword;
@property(nonatomic, strong) LFTextField *evtxfVerifyCode;
@property(nonatomic, strong) UIButton *evbtnSendVerifyCode;

@property(nonatomic, strong) UIButton *evbtnRegister;

@property(nonatomic, copy  ) LFVerifyCode *evVerifyCode;

@property(nonatomic, strong) NSTimer *evCountdownTimer;

@property(nonatomic, assign) NSInteger evDownCount;

@end

@implementation LFRegisterVC

- (instancetype)initWithRegisterCallback:(void (^)(LFRegisterVC *registerVC, BOOL success, NSString *username, NSString *password))registerCallback;{
    self = [super init];
    
    if (self) {
        
        [self setTitle:@"注册"];
        [self setEvblcRegisterCallback:registerCallback];
    }
    
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor colorWithHexRGB:0x484e59]];
    
    [[self view] addSubview:[self evtxfTelephone]];
    [[self view] addSubview:[self evtxfVerifyCode]];
    [[self view] addSubview:[self evtxfPassword]];
    [[self view] addSubview:[self evbtnSendVerifyCode]];
    [[self view] addSubview:[self evbtnRegister]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - accessory

- (LFTextField *)evtxfTelephone{
    
    if (!_evtxfTelephone) {
        
        _evtxfTelephone = [LFTextField emptyFrameView];
        
        [_evtxfTelephone setPlaceholder:@"请输入手机号"];
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
        [_evtxfVerifyCode setTextLimitType:XLFTextLimitTypeLength];
        [_evtxfVerifyCode setTextLimitSize:4];
        [_evtxfVerifyCode setKeyboardType:UIKeyboardTypeNumberPad];
        [_evtxfVerifyCode setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_lock"]];
        [_evtxfVerifyCode setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_lock_ing"]];
        [_evtxfVerifyCode setNeedsDefaultStyle];
        [_evtxfVerifyCode setNeedsBorder];
    }
    return _evtxfVerifyCode;
}

- (LFTextField *)evtxfPassword{
    
    if (!_evtxfPassword) {
        
        _evtxfPassword = [LFTextField emptyFrameView];
        
        [_evtxfPassword setDelegate:self];
        [_evtxfPassword setSecureTextEntry:YES];
        [_evtxfPassword setPlaceholder:@"请输入密码"];
        [_evtxfPassword setReturnKeyType:UIReturnKeyDone];
        [_evtxfPassword setRightViewMode:UITextFieldViewModeAlways];
        [_evtxfPassword setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_lock"]];
        [_evtxfPassword setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_lock_ing"]];
        [_evtxfPassword setNeedsDefaultStyle];
        [_evtxfPassword setNeedsBorder];
        
        UIButton *etbtnExchangePasswordDisyplayState = [[UIButton alloc] initWithFrame:CGRectMakePWH(CGPointZero, 35, 35)];
        
        [etbtnExchangePasswordDisyplayState setImage:[UIImage imageNamed:@"btn_eye_normal"] forState:UIControlStateNormal];
        [etbtnExchangePasswordDisyplayState setImage:[UIImage imageNamed:@"btn_eye_selected"] forState:UIControlStateSelected];
        [etbtnExchangePasswordDisyplayState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [etbtnExchangePasswordDisyplayState setTitleColor:[UIColor colorWithHexRGB:0x111111] forState:UIControlStateSelected];
        [etbtnExchangePasswordDisyplayState addTarget:self action:@selector(didClickExchangePasswordDisyplayState:) forControlEvents:UIControlEventTouchUpInside];
        
        [_evtxfPassword  setRightView:etbtnExchangePasswordDisyplayState];
    }
    return _evtxfPassword;
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

- (UIButton *)evbtnRegister{
    
    if (!_evbtnRegister) {
        
        _evbtnRegister = [UIButton emptyFrameView];
        
        [_evbtnRegister setTitle:@"注册" forState:UIControlStateNormal];
        [_evbtnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_evbtnRegister setBackgroundColor:[UIColor colorWithHexRGB:0x6a6f7b]];
        [[_evbtnRegister layer] setCornerRadius:5];
        [[_evbtnRegister layer] setBorderWidth:1];
        [[_evbtnRegister layer] setBorderColor:[[UIColor lightTextColor] CGColor]];
        [_evbtnRegister addTarget:self action:@selector(didClickRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnRegister;
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
    
    [[self evtxfPassword] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.evtxfVerifyCode.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [[self evbtnRegister] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.evtxfPassword.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
}

- (BOOL)_efShouldRegister{
    
    if (![[[self evtxfTelephone] text] length]) {
        
        [MBProgressHUD showWithStatus:@"用户名不可以为空"];
        return NO;
    }
    
    if (![[[self evtxfVerifyCode] text] length]) {
        
        [MBProgressHUD showWithStatus:@"验证码不可以为空"];
        return NO;
    }
    
    if (![[[self evtxfPassword] text] length]) {
        
        [MBProgressHUD showWithStatus:@"密码不可以为空"];
        return NO;
    }
    
    if ([[[self evtxfPassword] text] length] < 6) {
        
        [MBProgressHUD showWithStatus:@"密码必须大于六个英文或数字"];
        return NO;
    }
    
    if (![[[self evtxfTelephone] text] isTelephoneFullNumber]) {
        
        [MBProgressHUD showWithStatus:@"请填写正确的手机号"];
        return NO;
    }
    return YES;
}

- (void)_efRegister{
    
    LFHttpRequest *etRequest = [self efRegisterWithAccount:[[self evtxfTelephone] text]
                                                  password:[[self evtxfPassword] text]
                                              platformType:LFPlatformTypeTelephone
                                                      code:[[self evtxfVerifyCode] text]
                                                      zone:@"86"
                                                    secret:[[self evVerifyCode] secret]
                                                   success:[self efRegisterSuccessBlock]
                                                   failure:[self efFailedBlock]];
    [etRequest setHiddenLoadingView:NO];
    [etRequest setLoadingHintsText:@"正在注册"];
    [etRequest startAsynchronous];
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

- (void)_efSendVerifyCode{

//    LFHttpRequest *etRequest = [self efSendCodeWithTelephone:[[self evtxfTelephone] text]
//                                                       email:[[self evtxfTelephone] text]
//                                                        type:LFVerifyTypeTelephone
//                                                     success:[self _efSendVerifyCodeSuccessBlock]
//                                                     failure:[self _efSendVerifyCodeFailedBlock]];
//    [etRequest startAsynchronous];
//    [[self evbtnSendVerifyCode] startLoading];
    
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

#pragma mark - actions

- (IBAction)didClickRegister:(id)sender {
    
    if ([self _efShouldRegister]) {
        
        [self _efRegister];
    }
}

- (IBAction)didClickExchangePasswordDisyplayState:(UIButton *)sender{
    [sender setSelected:![sender isSelected]];
    
    [[self evtxfPassword] setSecureTextEntry:![sender isSelected]];
    [[self evtxfPassword] endFloatingCursor];
}

- (IBAction)didClickSendVerifyCode:(id)sender {
    
    if ([self _efShouldSendVerifyCode]) {
        
        [self _efSendVerifyCode];
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

- (XLFNoneResultSuccessedBlock)efRegisterSuccessBlock{
    
    Weakself(ws);
    XLFNoneResultSuccessedBlock success = ^(LFHttpRequest *request){
        
        if ([ws evblcRegisterCallback]) {
            ws.evblcRegisterCallback(ws, YES, [[ws evtxfTelephone] text], [[ws evtxfPassword] text]);
        }
    };
    return success;
}

- (XLFFailedBlock)efFailedBlock{
    
    Weakself(ws);
    XLFFailedBlock failure = ^(XLFBaseHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
        
        if ([ws evblcRegisterCallback]) {
            
            ws.evblcRegisterCallback(ws, NO, nil, nil);
        }
    };
    return failure;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    
    if ([self _efShouldRegister]) {
        
        [self _efRegister];
    }
    return YES;
}

@end
