//
//  LFAboutVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFAboutVC.h"

@interface LFAboutVC ()

@end

@implementation LFAboutVC

- (instancetype)init{
    self = [super init];
    if (self) {
        
        [self setTitle:@"关于"];
        [self setEvUrl:@"http://idev.iwoce.com/laf/pages/aboutus.html"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
