//
//  UIImagePickerController+Categories.m
//  UDrivingCustomer
//
//  Created by Marike Jave on 15/11/25.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "UIImagePickerController+Categories.h"

@implementation UIImagePickerController (Categories)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate{
    
    return YES;
}

- (BOOL)prefersStatusBarHidden{
    
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return  UIStatusBarStyleLightContent;
}

- (UIViewController *)evVisibleViewController{
    
    return self;
}

//- (UIViewController *)childViewControllerForStatusBarHidden{
//    return nil;
//}
//
//- (UIViewController *)childViewControllerForStatusBarStyle{
//    return nil;
//}

#pragma clang diagnostic pop

@end