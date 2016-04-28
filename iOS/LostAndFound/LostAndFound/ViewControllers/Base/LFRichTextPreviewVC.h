//
//  LFRichTextPreviewVC
//  LostAndFound
//
//  Created by Marike Jave on 15/6/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

@interface LFRichTextPreviewVC : LFBaseViewController

- (instancetype)initWithUrl:(NSString *)url;

- (instancetype)initWithHtml:(NSString *)html;

@property(nonatomic, strong, readonly) UIWebView *evwbvNormal;

@property (nonatomic, copy  ) NSString* evUrl;              // web link

@property (nonatomic, copy  ) NSString* evHtmlString;       // html code string

@property(nonatomic, assign) BOOL      evTextUserInterfaceEnable;  // If YES, user's actions will be enable, such as select, copy and so on, default is YES.

@property(nonatomic, assign) BOOL      evWebpageJumpEnable;        // If YES, webpage link will be available, default is YES.

@property(nonatomic, assign) BOOL      evDefaultMode;      

@end
