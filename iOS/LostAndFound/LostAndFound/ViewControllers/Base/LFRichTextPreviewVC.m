//
//  LFRichTextPreviewVC.m
//  LostAndFound
//
//  Created by Marike Jave on 15/6/13.
//  Copyright (c) 2015年 Marike Jave. All rights reserved.
//

#import <XLFCommonKit/XLFCommonKit.h>

#import "LFRichTextPreviewVC.h"

@interface LFRichTextPreviewVC () <UIWebViewDelegate, LFHttpRequestManagerProtocol>

@property(nonatomic, strong) UIWebView *evwbvNormal;

@end

@implementation LFRichTextPreviewVC

- (instancetype)initWithUrl:(NSString *)url;{
    self = [self init];
    if (self) {
        
        [self setTitle:nil];
        [self setEvUrl:url];
    }
    return self;
}

- (instancetype)initWithHtml:(NSString *)html;{
    self = [self init];
    if (self) {
        
        [self setEvHtmlString:html];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setEvTextUserInterfaceEnable:YES];
        [self setEvDefaultMode:YES];
//        [self setEvWebpageJumpEnable:YES];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [[self view] addSubview:[self evwbvNormal]];
    
    [self _efInstallConstraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[[self evwbvNormal] scrollView] setContentInset:UIEdgeInsetsMake(STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT, 0, 0, 0)];
    
    if ([[self evUrl] length]) {
        
        if ([self evDefaultMode]) {
            
            [[self evwbvNormal] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self evUrl]]]];
        }
        else{
            
            LFHttpRequest *etreqLoadHtml = [self fileRequestWithUrl:[self evUrl]
                                                  hiddenLoadingView:NO
                                                            success:[self efSuccessBlock]
                                                            failure:[self efFailedBlock]];

            [etreqLoadHtml startAsynchronous];
        }
    }
    else if ([[self evHtmlString] length]){
        
        [[self evwbvNormal] loadHTMLString:[self evHtmlString] baseURL:nil];
    }
}

- (void)_efInstallConstraints{
    
    Weakself(ws);
    
    [[self evwbvNormal] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(ws.view).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter and setter

- (UIWebView*)evwbvNormal{
    
    if (!_evwbvNormal) {
        
        _evwbvNormal = [UIWebView emptyFrameView];
        [_evwbvNormal setBackgroundColor:[UIColor whiteColor]];
        [_evwbvNormal setDelegate:self];
        [[_evwbvNormal scrollView] setShowsHorizontalScrollIndicator:NO];
        [[_evwbvNormal scrollView] setShowsVerticalScrollIndicator:NO];
    }
    return _evwbvNormal;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{
    
    NSURL *url = [request URL];
    
    if (![self evWebpageJumpEnable] &&
        ([[url scheme] isEqualToString: @"http"] ||
         [[url scheme] isEqualToString:@"https"] ||
         [[url scheme] isEqualToString: @"mailto" ])
        && (navigationType == UIWebViewNavigationTypeLinkClicked)) {
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView;{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;{
    
    if (![self evTextUserInterfaceEnable]) {
        
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    }
    if (![[self title] length]) {
        
        [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title;"]];
    }
    
    if (![[self title] length]) {
        
        [self setTitle:@"网页"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;{
    
}

- (XLFSuccessedBlock)efSuccessBlock{
    
    Weakself(ws);
    XLFSuccessedBlock successBlock = ^(id request, id result){
        
        NSString *html = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        [[ws evwbvNormal] loadHTMLString:html baseURL:nil];
    };
    return successBlock;
}

- (XLFFailedBlock)efFailedBlock{
    
    Weakself(ws);
    
    XLFFailedBlock successBlock = ^(id request, NSError *error){
        
        [MBProgressHUD showWithStatus:[error domain] afterDelay:1.f inView:[ws view]];
    };
    return successBlock;
}

@end
