//
//  LoginVC.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

//#import <AdSupport/AdSupport.h>
//#import <iAd/iAd.h>

#import "LFLoginVC.h"
#import "LFFindPasswordVC.h"
#import "LFRegisterVC.h"

#import "LFLoginManager.h"

#import "LFTextField.h"
#import "LFScrollView.h"

#import "WXApi.h"

@interface LFLoginVC ()<LFLoginManagerDelegate, UITextFieldDelegate>

@property(nonatomic, copy) void(^evblcLoginCallback)(LFLoginVC *registerVC, BOOL success);

@property(nonatomic, strong) LFTextField *evtxfUsername;
@property(nonatomic, strong) LFTextField *evtxfPassword;

@property(nonatomic, strong) UIButton *evbtnLogin;
@property(nonatomic, strong) UIButton *evbtnRegister;
@property(nonatomic, strong) UIButton *evbtnForgetPassword;

@property(nonatomic, strong) UIView *evvThirdPartLoginContent;

@property(nonatomic, strong) UIButton *evbtnWechat;
@property(nonatomic, strong) UIButton *evbtnSina;
@property(nonatomic, strong) UIButton *evbtnQQ;

//@property(nonatomic, strong) ADBannerView *evbvBanner;

@end

@implementation LFLoginVC

- (id)initWithLoginCallback:(void (^)(LFLoginVC *registerVC, BOOL success))loginCallback;{
    self = [super init];
    if (self) {
        
        [self setTitle:@"登录"];
        [self setEvblcLoginCallback:loginCallback];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor colorWithHexRGB:0x484e59]];
    
    [[self view] addSubview:[self evtxfUsername]];
    [[self view] addSubview:[self evtxfPassword]];
    [[self view] addSubview:[self evbtnLogin]];
    [[self view] addSubview:[self evbtnRegister]];
    [[self view] addSubview:[self evbtnForgetPassword]];
    [[self view] addSubview:[self evvThirdPartLoginContent]];
    
    [[self evvThirdPartLoginContent] addSubview:[self evbtnQQ]];
    [[self evvThirdPartLoginContent] addSubview:[self evbtnSina]];
    [[self evvThirdPartLoginContent] addSubview:[self evbtnWechat]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - accessory

- (LFTextField *)evtxfUsername{
    
    if (!_evtxfUsername) {
        
        _evtxfUsername = [LFTextField emptyFrameView];
        
        [_evtxfUsername setPlaceholder:@"请输入手机号"];
        [_evtxfUsername setReturnKeyType:UIReturnKeyNext];
        [_evtxfUsername setKeyboardType:UIKeyboardTypeNumberPad];
        [_evtxfUsername setTextLimitInputType:XLFTextLimitInputTypeTelephoneNumber];
        [_evtxfUsername setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_user"]];
        [_evtxfUsername setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_user_ing"]];
        [_evtxfUsername setNeedsDefaultStyle];
        [_evtxfUsername setNeedsBorder];
    }
    return _evtxfUsername;
}

- (LFTextField *)evtxfPassword{
    
    if (!_evtxfPassword) {
        
        _evtxfPassword = [LFTextField emptyFrameView];
        
        [_evtxfPassword setDelegate:self];
        [_evtxfPassword setSecureTextEntry:YES];
        [_evtxfPassword setPlaceholder:@"请输入密码"];
        [_evtxfPassword setReturnKeyType:UIReturnKeyDone];
        [_evtxfPassword setRightViewMode:UITextFieldViewModeWhileEditing];
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

- (UIButton *)evbtnLogin{
    
    if (!_evbtnLogin) {
        
        _evbtnLogin = [UIButton emptyFrameView];
        [_evbtnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [_evbtnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_evbtnLogin setBackgroundColor:[UIColor colorWithHexRGB:0x6a6f7b]];
        [[_evbtnLogin layer] setCornerRadius:5];
        [[_evbtnLogin layer] setBorderWidth:1];
        [[_evbtnLogin layer] setBorderColor:[[UIColor lightTextColor] CGColor]];
        [_evbtnLogin addTarget:self action:@selector(didClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnLogin;
}

- (UIButton *)evbtnRegister{
    
    if (!_evbtnRegister) {
        
        _evbtnRegister = [UIButton emptyFrameView];
        [_evbtnRegister setTitle:@"现在注册" forState:UIControlStateNormal];
        [_evbtnRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_evbtnRegister addTarget:self action:@selector(didClickRegister:) forControlEvents:UIControlEventTouchUpInside];
        
        [[_evbtnRegister titleLabel] setFont:[UIFont systemFontOfSize:13]];
    }
    return _evbtnRegister;
}

- (UIButton *)evbtnForgetPassword{
    
    if (!_evbtnForgetPassword) {
        
        _evbtnForgetPassword = [UIButton emptyFrameView];
        [_evbtnForgetPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_evbtnForgetPassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_evbtnForgetPassword addTarget:self action:@selector(didClickForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
        
        [[_evbtnForgetPassword titleLabel] setFont:[UIFont systemFontOfSize:13]];
    }
    return _evbtnForgetPassword;
}

- (UIView *)evvThirdPartLoginContent{
    
    if (!_evvThirdPartLoginContent) {
        
        _evvThirdPartLoginContent = [UIView emptyFrameView];
    }
    return _evvThirdPartLoginContent;
}

- (UIButton *)evbtnQQ{
    
    if (!_evbtnQQ) {
        
        _evbtnQQ = [UIButton emptyFrameView];
        [_evbtnQQ setImage:[UIImage imageNamed:@"login_btn_qq"] forState:UIControlStateNormal];
        [_evbtnQQ addTarget:self action:@selector(didClickQQ:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnQQ;
}

- (UIButton *)evbtnSina{
    
    if (!_evbtnSina) {
        
        _evbtnSina = [UIButton emptyFrameView];
        [_evbtnSina setImage:[UIImage imageNamed:@"login_btn_sina"] forState:UIControlStateNormal];
        [_evbtnSina addTarget:self action:@selector(didClickSina:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnSina;
}

- (UIButton *)evbtnWechat{
    
    if (!_evbtnWechat) {
        
        _evbtnWechat = [UIButton emptyFrameView];
        [_evbtnWechat setImage:[UIImage imageNamed:@"login_btn_wechat"] forState:UIControlStateNormal];
        [_evbtnWechat addTarget:self action:@selector(didClickWechat:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evbtnWechat;
}

//- (ADBannerView *)evbvBanner{
//    
//    if (!_evbvBanner) {
//        
//        _evbvBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//        [_evbvBanner setDelegate:self];
//    }
//    
//    return _evbvBanner;
//}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtxfUsername] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.view.mas_top).offset(50 + STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@40);
    }];
    
    [[self evtxfPassword] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.evtxfUsername.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [[self evbtnLogin] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.evtxfPassword.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    
    [[self evbtnRegister] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evbtnLogin.mas_left).offset(0);
        make.top.equalTo(ws.evbtnLogin.mas_bottom).offset(30);
        make.height.equalTo(@30);
    }];
    
    [[self evbtnForgetPassword] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(ws.evbtnLogin.mas_right).offset(0);
        make.top.equalTo(ws.evbtnLogin.mas_bottom).offset(30);
        make.height.equalTo(@30);
    }];
    
    [[self evvThirdPartLoginContent] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(ws.view.mas_centerX).offset(0);
        make.bottom.equalTo(ws.view.mas_bottom).offset(-50);
    }];
    
    [[self evbtnWechat] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evvThirdPartLoginContent.mas_left).offset(0);
        make.top.equalTo(ws.evvThirdPartLoginContent.mas_top).offset(0);
        make.bottom.equalTo(ws.evvThirdPartLoginContent.mas_bottom).offset(0);
        
        make.height.equalTo(@80);
        make.width.equalTo((select([WXApi isWXAppInstalled], @80, @0)));
    }];
    
    [[self evbtnQQ] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evbtnWechat.mas_right).offset(0);
        make.top.equalTo(ws.evvThirdPartLoginContent.mas_top).offset(0);
        make.bottom.equalTo(ws.evvThirdPartLoginContent.mas_bottom).offset(0);
        
        make.height.equalTo(@80);
        make.width.equalTo(@80);
    }];
    
    [[self evbtnSina] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.evbtnQQ.mas_right).offset(0);
        make.right.equalTo(ws.evvThirdPartLoginContent.mas_right).offset(0);
        make.top.equalTo(ws.evvThirdPartLoginContent.mas_top).offset(0);
        make.bottom.equalTo(ws.evvThirdPartLoginContent.mas_bottom).offset(0);
        
        make.height.equalTo(@80);
        make.width.equalTo(@80);
    }];
    
//    [[self evbvBanner] mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.equalTo(ws.view.mas_left).offset(0);
//        make.right.equalTo(ws.view.mas_right).offset(0);
//        make.bottom.equalTo(ws.view.mas_bottom).offset(0);
//        make.height.equalTo(@40);
//    }];
}

- (BOOL)_efShouldLogin{
    
    NSString *account = [[self evtxfUsername] text];
    NSString *password = [[self evtxfPassword] text];
    
    if (![account length]) {
        [MBProgressHUD showWithStatus:@"用户名/邮箱不可以为空"];
        return NO;
    }
    
    if (![password length]) {
        [MBProgressHUD showWithStatus:@"密码不可以为空"];
        return NO;
    }
    
    if (![account isEmail]) {
        if (![account isNumberAndEnglishCharacter]) {
            [MBProgressHUD showWithStatus:@"用户名/邮箱输入格式有误"];
            return NO;
        }
    }
    return YES;
}

- (void)_efNormalLogin{
    
    [LFLoginManager efNormalLoginWithUserName:[[self evtxfUsername] text]
                                     password:[[self evtxfPassword] text]
                              showLoadingView:YES
                                     delegate:self];
}

- (void)_efFinishLogin:(BOOL)success{
    
    [[self view] endEditing:YES];
    
    if ([self evblcLoginCallback]) {
        
        self.evblcLoginCallback(self, success);
    }
    else if(success){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification
                                                            object:nil];
        
        [self efBack];
    }
}

- (void)_efWantAutoLoginAfterRegisterSuccess{
    
    UIAlertController *etAutoLoginAC = [UIAlertController alertControllerWithTitle:@"注册成功"
                                                                           message:@"是否现在登录？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *etaaConfirm = [UIAlertAction actionWithTitle:@"立即"
                                                          style:UIAlertActionStyleDefault
                                                        handler:[self _efConfirmAutoLoginAction]];
    
    UIAlertAction *etaaCancel = [UIAlertAction actionWithTitle:@"稍后"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
    
    [etAutoLoginAC addAction:etaaConfirm];
    [etAutoLoginAC addAction:etaaCancel];
    
    UIPopoverPresentationController *etPopover = [etAutoLoginAC popoverPresentationController];
    if (etPopover){
        [etPopover setSourceView:[self view]];
        [etPopover setSourceRect:[[self view] bounds]];;
        [etPopover setPermittedArrowDirections:UIPopoverArrowDirectionAny];
    }
    
    [[self evVisibleViewController] presentViewController:etAutoLoginAC
                                                 animated:YES
                                               completion:nil];
}

- (void (^)(UIAlertAction *action))_efConfirmAutoLoginAction{
    
    return ^(UIAlertAction *action){
        
        [LFLoginManager efNormalLoginWithUserName:[[self evtxfUsername] text]
                                         password:[[self evtxfPassword] text]
                                  showLoadingView:YES
                                         delegate:self];
    };
}

#pragma mark - actions

- (IBAction)didClickExchangePasswordDisyplayState:(UIButton *)sender{
    [sender setSelected:![sender isSelected]];
    
    [[self evtxfPassword] setSecureTextEntry:![sender isSelected]];
    [[self evtxfPassword] endFloatingCursor];
}

- (IBAction)didClickLogin:(id)sender {
    
    [self _efNormalLogin];
}

- (IBAction)didClickRegister:(id)sender{
    
    LFRegisterVC *etRegisterVC = [[LFRegisterVC alloc] initWithRegisterCallback:[self _efRegisterCallback]];
    
    [[self navigationController] pushViewController:etRegisterVC animated:YES];
}

- (IBAction)didClickForgetPassword:(id)sender{
    
    LFFindPasswordVC *etRegisterVC = [[LFFindPasswordVC alloc] initWithFindPasswordCallback:[self _efFindPasswordCallback]];
    
    [[self navigationController] pushViewController:etRegisterVC animated:YES];
}

- (IBAction)didClickWechat:(id)sender{
    
    [LFLoginManager efThirdPlatformLoginWithType:UMSocialSnsTypeWechatSession delegate:self];
}

- (IBAction)didClickSina:(id)sender {
    
    [LFLoginManager efThirdPlatformLoginWithType:UMSocialSnsTypeSina delegate:self];
}

- (IBAction)didClickQQ:(id)sender {
    
    [LFLoginManager efThirdPlatformLoginWithType:UMSocialSnsTypeMobileQQ delegate:self];
}

#pragma mark - LFLoginManagerDelegate

- (void)epLoginManager:(LFLoginManager *)manager success:(BOOL)success error:(NSError*)error{
    
    if (!success) {
        
        [MBProgressHUD showWithStatus:[error domain]];
    }
    
    [self _efFinishLogin:success];
}

#pragma mark - LFRegisterVC callback

- (void (^)(LFRegisterVC *registerVC, BOOL success, NSString *username, NSString *password))_efRegisterCallback{
    
    Weakself(ws);
    return ^(LFRegisterVC *registerVC, BOOL success, NSString *username, NSString *password){
        
        if (success) {
            
            [[registerVC navigationController] popViewControllerAnimated:YES];
            
            [[ws evtxfUsername] setText:username];
            [[ws evtxfPassword] setText:password];
            
            [LFLoginManager efNormalLoginWithUserName:username
                                             password:password
                                      showLoadingView:YES
                                             delegate:ws];
        }
    };
}

- (void (^)(LFFindPasswordVC *findPasswordVC, BOOL success, NSString *username, NSString *password))_efFindPasswordCallback{
    
    Weakself(ws);
    return ^(LFFindPasswordVC *findPasswordVC, BOOL success, NSString *username, NSString *password){
        
        if (success) {
            
            [[findPasswordVC navigationController] popViewControllerAnimated:YES];
            
            [[ws evtxfUsername] setText:username];
            [[ws evtxfPassword] setText:password];
            
            [LFLoginManager efNormalLoginWithUserName:username
                                             password:password
                                      showLoadingView:YES
                                             delegate:ws];
        }
    };
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    
    if ([self _efShouldLogin]) {
        
        [self _efNormalLogin];
    }
    return YES;
}

#pragma mark - ADBannerViewDelegate

//- (void)bannerViewWillLoadAd:(ADBannerView *)banner{
//    
//}
//
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner;{
//    
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;{
//    
//    NIF_ERROR(@"%@", error);
//}
//
//-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
//    
//    return YES;
//}
//
//- (void)bannerViewActionDidFinish:(ADBannerView *)banner;{
//    
//}

@end
