//
//  LFModifyPasswordVC.m
//  LostAndFound
//
//  Created by Marike Jave on 14-11-3.
//  Copyright (c) 2014年 MarikeJave. All rights reserved.
//

#import "LFModifyPasswordVC.h"
#import "LFHttpRequestManager.h"
#import "LFUserManager.h"
#import "LFLoginManager.h"
#import "LFTextField.h"

@interface LFModifyPasswordVC ()<LFHttpRequestManagerProtocol, UITextFieldDelegate>

@property(nonatomic, copy  ) void(^evblcModifyPasswordCallback)(LFModifyPasswordVC *modifyPasswordVC, BOOL success);

@property(nonatomic, strong) UIBarButtonItem *evbbiConfirm;

@property(nonatomic, strong) LFTextField *evtxfOldPassword;
@property(nonatomic, strong) LFTextField *evtxfNewPassword;

@end

@implementation LFModifyPasswordVC

- (id)initWithModifyPasswordCallback:(void (^)(LFModifyPasswordVC *modifyPasswordVC, BOOL success))modifyPasswordCallback;{
    self = [super init];
    if (self) {
        
        [self setTitle:@"修改密码"];
        [self setEvblcModifyPasswordCallback:modifyPasswordCallback];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiConfirm] type:XLFNavButtonTypeRight];
    
    [[self view] setBackgroundColor:[UIColor colorWithHexRGB:0x484e59]];
    [[self view] addSubview:[self evtxfOldPassword]];
    [[self view] addSubview:[self evtxfNewPassword]];
    
    [self _efInstallConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (UIBarButtonItem *)evbbiConfirm{
    
    if (!_evbbiConfirm) {
        
        _evbbiConfirm = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didClickConfirm:)];
    }
    return _evbbiConfirm;
}

- (LFTextField *)evtxfOldPassword{
    
    if (!_evtxfOldPassword) {
        
        _evtxfOldPassword = [LFTextField emptyFrameView];
        [_evtxfOldPassword setReturnKeyType:UIReturnKeyNext];
        [_evtxfOldPassword setEvimgNormalLeft:[UIImage imageNamed:@"login_icon_locked"]];
        [_evtxfOldPassword setEvimgHightlightedLeft:[UIImage imageNamed:@"login_icon_locked_ing"]];
        [_evtxfOldPassword setPlaceholder:@"原密码"];
        [_evtxfOldPassword setSecureTextEntry:YES];
        [_evtxfOldPassword setNeedsDefaultStyle];
        [_evtxfOldPassword setNeedsBorder];
    }
    return _evtxfOldPassword;
}

- (LFTextField *)evtxfNewPassword{
    
    if (!_evtxfNewPassword) {
        
        _evtxfNewPassword = [LFTextField emptyFrameView];
        [_evtxfNewPassword setDelegate:self];
        [_evtxfNewPassword setSecureTextEntry:YES];
        [_evtxfNewPassword setPlaceholder:@"新密码"];
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

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evtxfOldPassword] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.view.mas_top).offset(50 + STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT);
        make.height.equalTo(@40);
    }];
    
    [[self evtxfNewPassword] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        
        make.top.equalTo(ws.evtxfOldPassword.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
}

- (void)_efModifyPassword;{
    
    LFHttpRequest *etRequest = [self efModifyPasswordWithOldPassword:[[self evtxfOldPassword] text]
                                                         newPassword:[[self evtxfNewPassword] text]
                                                             success:[self _efModifySuccessBlock]
                                                             failure:[self _efFailedBlock]];
    [etRequest startAsynchronous];
}

- (XLFNoneResultSuccessedBlock)_efModifySuccessBlock{
    
    XLFNoneResultSuccessedBlock success = ^(LFHttpRequest *request){
        
        [MBProgressHUD showSuccessWithStatus:@"密码修改成功"];
        
        if ([self evblcModifyPasswordCallback]) {
            
            self.evblcModifyPasswordCallback(self, YES);
        }
    };
    return success;
}

- (XLFFailedBlock)_efFailedBlock{
    
    XLFFailedBlock failure = ^(XLFBaseHttpRequest *request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain]];
        
        if ([self evblcModifyPasswordCallback]) {
            
            self.evblcModifyPasswordCallback(self, NO);
        }
    };
    return failure;
}

- (BOOL)_efShouldModifyPassword{
    
    if (![[[self evtxfOldPassword] text] length]) {
        
        [MBProgressHUD showWithStatus:@"旧密码不可以为空"];
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

- (IBAction)didClickConfirm:(id)sender{
    
    if ([self _efShouldModifyPassword]) {
        
        [self _efModifyPassword];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;{
    
    if ([self _efShouldModifyPassword]) {
        
        [self _efModifyPassword];
    }
    
    return YES;
}


@end
