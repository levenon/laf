//
//  LFGetTuiManager.h
//  LostAndFound
//
//  Created by Marke Jave on 16/3/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GeTuiSdk.h"

@interface LFGetTuiManager : NSObject

+ (void)efConfigurate:(id<GeTuiSdkDelegate>)delegate;

@end
