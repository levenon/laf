//
//  LFTextEditVC.h
//  LostAndFound
//
//  Created by Marike Jave on 15/12/16.
//  Copyright © 2015年 Marike Jave. All rights reserved.
//

#import "LFBaseViewController.h"

#import "LFTextField.h"

@interface LFTextEditVC : LFBaseViewController

@property(nonatomic, strong, readonly) LFTextField *evtxfInput;

@property(nonatomic, copy  , readonly) NSString *evPlaceholderText;

@property(nonatomic, copy  , readonly) void (^evblcTextEditCallback)(LFTextEditVC *textEditVC, NSString *inputText);

- (instancetype)initWithTitle:(NSString *)title
              placeholderText:(NSString *)placeholderText
             textEditCallback:(void (^)(LFTextEditVC *textEditVC, NSString *inputText))textEditCallback;

@end
