//
//  LFGetTuiManager.m
//  LostAndFound
//
//  Created by Marke Jave on 16/3/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFGetTuiManager.h"

#import "GeTuiSdk.h"

@implementation LFGetTuiManager

+ (void)efConfigurate:(id<GeTuiSdkDelegate>)delegate;{
    
    [GeTuiSdk startSdkWithAppId:egGeTuiAppID appKey:egGeTuiAppKey appSecret:egGeTuiAppSecret delegate:delegate];
    NIF_DEBUG(@"个推appID : %@ , appKey : %@ , appSecret : %@", egGeTuiAppID, egGeTuiAppKey, egGeTuiAppSecret);
}

@end
