//
//  LFShareSDKManager.m
//  LostAndFound
//
//  Created by Marke Jave on 16/3/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFShareSDKManager.h"

#import <SMS_SDK/SMSSDK.h>

@implementation LFShareSDKManager

+ (void)efConfigurate;{
    
    [SMSSDK registerApp:egShareSDKAppKey withSecret:egShareSDKSecret];
    NIF_DEBUG(@"SMSSDK appKey : %@, secretKey: %@", egShareSDKAppKey, egShareSDKSecret);
}

@end
