//
//  LFWelcomeVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/10/17.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFWelcomeVC.h"

@interface LFWelcomeVC ()<UIScrollViewDelegate>

@property(nonatomic, copy  ) void (^evblcTransformCallback)(LFWelcomeVC *welcomeVC, UIViewController *viewController);
@property(nonatomic, copy  ) void (^evblcCallback)(LFWelcomeVC *welcomeVC, UIViewController *viewController, void (^afterCallback)());

@property(nonatomic, strong) UIScrollView *evsrvWelcomePage;

@end

@implementation LFWelcomeVC

- (id)initWithTransformCallback:(void (^)(LFWelcomeVC *welcomeVC, UIViewController *viewController))blcTransformCallback
                       callback:(void (^)(LFWelcomeVC *welcomeVC, UIViewController *viewController, void (^afterCallback)()))blcOverCallback;{
    self = [super init];
    if (self) {
        
        [self setEvblcCallback:blcOverCallback];
        [self setEvblcTransformCallback:blcTransformCallback];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] addSubview:[self evsrvWelcomePage]];
    
    [self _efInstallConstraints];
    
    [self _efLoadScrollView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self evsrvWelcomePage] setContentInset:UIEdgeInsetsZero];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES];
    [[self evsrvWelcomePage] setContentOffset:CGPointMake(SCREEN_WIDTH * 3, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{

    return YES;
}

#pragma mark - accessory

- (UIScrollView *)evsrvWelcomePage{
    
    if (!_evsrvWelcomePage) {
        
        _evsrvWelcomePage = [UIScrollView emptyFrameView];
        [_evsrvWelcomePage setShowsHorizontalScrollIndicator:NO];
        [_evsrvWelcomePage setShowsVerticalScrollIndicator:NO];
        [_evsrvWelcomePage setPagingEnabled:YES];
        [_evsrvWelcomePage setBounces:NO];
    }
    return _evsrvWelcomePage;
}

#pragma mark - private

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evsrvWelcomePage] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)_efLoadScrollView{
    
    UIImageView *etimgvWelcomeFirstPage = [UIImageView emptyFrameView];
    [etimgvWelcomeFirstPage setImage:[UIImage imageNamed:@"welcome_first"]];
    [[self  evsrvWelcomePage] addSubview:etimgvWelcomeFirstPage];
    
    Weakself(ws);
    [etimgvWelcomeFirstPage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(CGRectGetHeight([[ws view] bounds])));
        make.left.equalTo(ws.evsrvWelcomePage.mas_left).offset(0);
        make.top.equalTo(ws.evsrvWelcomePage.mas_top).offset(0);
        make.bottom.equalTo(ws.evsrvWelcomePage.mas_bottom).offset(0);
    }];
    
    UIImageView *etimgvWelcomeSecondPage = [UIImageView emptyFrameView];
    [etimgvWelcomeSecondPage setImage:[UIImage imageNamed:@"welcome_second"]];
    [[self  evsrvWelcomePage] addSubview:etimgvWelcomeSecondPage];
    
    [etimgvWelcomeSecondPage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(CGRectGetHeight([[ws view] bounds])));
        make.left.equalTo(etimgvWelcomeFirstPage.mas_right).offset(0);
        make.top.equalTo(ws.evsrvWelcomePage.mas_top).offset(0);
        make.bottom.equalTo(ws.evsrvWelcomePage.mas_bottom).offset(0);
    }];
    
    UIImageView *etimgvWelcomeThirdPage = [UIImageView emptyFrameView];
    [etimgvWelcomeThirdPage setImage:[UIImage imageNamed:@"welcome_third"]];
    [[self  evsrvWelcomePage] addSubview:etimgvWelcomeThirdPage];
    
    [etimgvWelcomeThirdPage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(CGRectGetHeight([[ws view] bounds])));
        make.left.equalTo(etimgvWelcomeSecondPage.mas_right).offset(0);
        make.top.equalTo(ws.evsrvWelcomePage.mas_top).offset(0);
        make.bottom.equalTo(ws.evsrvWelcomePage.mas_bottom).offset(0);
    }];
    
    UIImageView *etimgvWelcomeFourthPage = [UIImageView emptyFrameView];
    [etimgvWelcomeFourthPage setImage:[UIImage imageNamed:@"welcome_fourth"]];
    [[self  evsrvWelcomePage] addSubview:etimgvWelcomeFourthPage];
    
    [etimgvWelcomeFourthPage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(CGRectGetHeight([[ws view] bounds])));
        make.left.equalTo(etimgvWelcomeThirdPage.mas_right).offset(0);
        make.right.equalTo(ws.evsrvWelcomePage.mas_right).offset(0);
        make.top.equalTo(ws.evsrvWelcomePage.mas_top).offset(0);
        make.bottom.equalTo(ws.evsrvWelcomePage.mas_bottom).offset(0);
    }];
}

@end
