//
//  LFFoundPullMenuVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/18.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFFoundPullMenuVC.h"

#import "LFMenuController.h"

#import "LFTelephoneEditVC.h"

#import "UIButton+WebCache.h"

@interface LFFoundPullMenuVC ()

@property(nonatomic, strong) UIButton *evbtnShowMenu;

@property(nonatomic, strong) UIBarButtonItem *evbbiShowMenu;

@property(nonatomic, strong) UIBarButtonItem *evbbiCreateFound;

@end

@implementation LFFoundPullMenuVC

- (id)initWithRightViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting> *)rightViewController
             centerViewController:(UIViewController<LFPullMenuViewControllerChild, LFPullMenuViewControllerPresenting, LFCreateNoticeDelegate> *)centerViewController{
    
    self = [super initWithRightViewController:rightViewController centerViewController:centerViewController];
    if (self ) {
        
        [self setTitle:@"得"];
        
        [[self tabBarItem] setTitle:@""];
        [[self tabBarItem] setImage:[UIImage imageNamed:@"img_home_reminder"]];
        [[self tabBarItem] setImageInsets:UIEdgeInsetsMake(7, 0, -7, 0)];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self efSetBarButtonItem:[self evbbiShowMenu] type:XLFNavButtonTypeLeft];
    [self efSetBarButtonItem:[self evbbiCreateFound] type:XLFNavButtonTypeRight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self efRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - accessory

- (UIBarButtonItem *)evbbiDefaultBack{
    
    return nil;
}

- (UIButton *)evbtnShowMenu{
    
    if (!_evbtnShowMenu) {
        
        _evbtnShowMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        [_evbtnShowMenu addTarget:self action:@selector(didClickShowMenu:) forControlEvents:UIControlEventTouchUpInside];
        [[_evbtnShowMenu layer] setCornerRadius:15];
        [[_evbtnShowMenu layer] setMasksToBounds:YES];
    }
    return _evbtnShowMenu;
}

- (UIBarButtonItem *)evbbiShowMenu{
    
    if (!_evbbiShowMenu) {
        
        _evbbiShowMenu = [[UIBarButtonItem alloc] initWithCustomView:[self evbtnShowMenu]];
    }
    return _evbbiShowMenu;
}

- (UIBarButtonItem *)evbbiCreateFound{
    
    if (!_evbbiCreateFound) {
        
        _evbbiCreateFound = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickCreateFound:)];
    }
    return _evbbiCreateFound;
}

#pragma mark - public

- (void)efRegisterNotification{
    [super efRegisterNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateRefresh:) name:kUserLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateRefresh:) name:kUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didNotificateRefresh:) name:kUserInfoChangedNotification object:nil];
}

- (void)efRefresh{
    [super efRefresh];
    
    [[self evbtnShowMenu] sd_setBackgroundImageWithURL:[NSURL URLWithString:[[LFUserManagerRef evLocalUser] headImageUrl]]
                                              forState:UIControlStateNormal
                                      placeholderImage:[UIImage imageNamed:@"img_user_portrait_default"]];
}

#pragma mark - actions

- (IBAction)didClickShowMenu:(id)sender{
    
    [[self menuController] open];
}

- (IBAction)didClickCreateFound:(id)sender{
    
    if ([LFUserManagerRef evIsLogin]) {
        
        if ([[[LFUserManagerRef evLocalUser] telephone] length]) {
            
            [self _efCreateFound];
        }
        else{
            
            [self _efBindingTelephone];
        }
    }
    else{
        
        [LFUserManager efLogin];
    }
}

- (IBAction)didNotificateRefresh:(id)sender{
    
    [self efRefresh];
}

#pragma mark - private

- (void (^)(LFTextEditVC *textEditVC, NSString *inputText))_efTelephoneEditCallback{
    
    return ^(LFTextEditVC *textEditVC, NSString *inputText){
        
        Weakself(ws);
        [[textEditVC evBaseNavigationController] popViewControllerAnimated:YES
                                                             completeBlock:^(XLFBaseNavigationController *navgationController){
             [ws _efCreateFound];
         }];
    };
}

- (void)_efBindingTelephone{
    
    LFTelephoneEditVC *etTelephoneEditVC = [[LFTelephoneEditVC alloc] initWithTitle:@"绑定手机号"
                                                                    placeholderText:nil
                                                                   textEditCallback:[self _efTelephoneEditCallback]];
    
    [[self navigationController] pushViewController:etTelephoneEditVC animated:YES];
}

- (void)_efCreateFound{
    
    LFCreateFoundVC *etCreateFoundVC = [[LFCreateFoundVC alloc] initWithDelegate:(id)[self centerViewController]];
    
    [[self navigationController] pushViewController:etCreateFoundVC animated:YES];
}

@end
