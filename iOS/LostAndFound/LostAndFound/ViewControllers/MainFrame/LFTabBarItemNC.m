//
//  LFTabBarItemNC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFTabBarItemNC.h"

#import "LFMenuController.h"

@interface LFTabBarItemNC ()

@end

@implementation LFTabBarItemNC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated;{
    
    [super navigationController:navigationController didShowViewController:viewController animated:animated];
    
    [[self menuController] setEnableSwip:[[self childViewControllers] count] == 1];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([[self childViewControllers] count]) {
        
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    
    [super pushViewController:viewController animated:animated];
    
    [[self menuController] close];
}

@end
