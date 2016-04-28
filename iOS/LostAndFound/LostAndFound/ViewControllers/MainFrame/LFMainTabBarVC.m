//
//  MainTabBarVC.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-18.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import "LFMainTabBarVC.h"
#import "LFHttpRequestManager.h"
#import "LFTabBarItemNC.h"

#import "LFFoundPullMenuVC.h"
#import "LFLostPullMenuVC.h"

#import "LFFoundsVC.h"

#import "LFCategoryMenuVC.h"

#import "LFLostsVC.h"

@interface LFMainTabBarVC ()

@property(nonatomic, strong) LFFoundsVC *evFoundVC;
@property(nonatomic, strong) LFLostsVC *evLostVC;

@property(nonatomic, strong) LFFoundPullMenuVC *evFoundPullMenuVC;
@property(nonatomic, strong) LFLostPullMenuVC *evLostPullMenuVC;


@end

@implementation LFMainTabBarVC

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setViewControllers:@[[[LFTabBarItemNC alloc] initWithRootViewController:[self evLostPullMenuVC]],
                               [[LFTabBarItemNC alloc] initWithRootViewController:[self evFoundPullMenuVC]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - accessory

- (LFFoundsVC *)evFoundVC{
    
    if (!_evFoundVC) {
        
        _evFoundVC = [LFFoundsVC viewController];
    }
    return _evFoundVC;
}

- (LFFoundPullMenuVC *)evFoundPullMenuVC{
    
    if (!_evFoundPullMenuVC) {
        
        LFFoundsVC *etFoundVC = [self evFoundVC];
        
        LFCategoryMenuVC *etFoundMenuVC = [[LFCategoryMenuVC alloc] initWithDelegate:etFoundVC];
        
        _evFoundPullMenuVC = [[LFFoundPullMenuVC alloc] initWithRightViewController:etFoundMenuVC
                                                               centerViewController:etFoundVC];
    }
    return _evFoundPullMenuVC;
}

- (LFLostsVC *)evLostVC{
    
    if (!_evLostVC) {
        
        _evLostVC = [LFLostsVC viewController];
    }
    return _evLostVC;
}

- (LFLostPullMenuVC *)evLostPullMenuVC{
    
    if (!_evLostPullMenuVC) {
        
        LFLostsVC *etLostVC = [self evLostVC];
        
        LFCategoryMenuVC *etLostMenuVC = [[LFCategoryMenuVC alloc] initWithDelegate:etLostVC];
        
        _evLostPullMenuVC = [[LFLostPullMenuVC alloc] initWithRightViewController:etLostMenuVC
                                                             centerViewController:etLostVC];
    }
    return _evLostPullMenuVC;
}

#pragma mark - LFMenuControllerPresenting

- (void)menuControllerWillOpen:(LFMenuController *)menuController;{
    
    [[self view] setUserInteractionEnabled:NO];
}

- (void)menuControllerDidClose:(LFMenuController *)menuController;{
    
    [[self view] setUserInteractionEnabled:YES];
}

@end
