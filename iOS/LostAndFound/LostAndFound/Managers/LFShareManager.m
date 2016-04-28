//
//  LFShareManager.m
//  LostAndFound
//
//  Created by Marike Jave on 14-11-20.
//  Copyright (c) 2014年 Marike Jave. All rights reserved.
//

#import "UMSocial.h"

#import "LFShareManager.h"

#import "LFConstants.h"

@interface LFShareManager ()<WXApiDelegate, UMSocialUIDelegate>

@property(nonatomic, strong) LFShareInfo *evShareInfo;

@end

@implementation LFShareManager

+ (LFShareManager *)sharedInstance;{
    
    static LFShareManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[LFShareManager alloc] init];
    });
    return instance;
}

+ (void)efShareInfo:(LFShareInfo *)shareInfo {
    
    [[self sharedInstance] efShareInfo:shareInfo];
}

- (void)efShareInfo:(LFShareInfo *)shareInfo{
    
    [self setEvShareInfo:shareInfo];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:[[[[UIApplication sharedApplication] delegate] window] rootViewController]
                                         appKey:egUMengAppKey
                                      shareText:[shareInfo content]
                                     shareImage:[shareInfo image]
                                shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline,
                                                  UMShareToQQ, UMShareToQzone, UMShareToSina,
                                                  UMShareToSms, UMShareToEmail]
                                       delegate:self];
}

//下面可以设置根据点击不同的分享平台，设置不同的分享文字
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData;{
    
    [socialData setTitle:[[self evShareInfo] title]];
    [socialData setShareText:[[self evShareInfo] content]];
    [socialData setShareImage:[[self evShareInfo] image]];
    
    if ([platformName isEqualToString:UMShareToWechatSession]) {
        
        [[[socialData extConfig] wechatSessionData] setUrl:[[self evShareInfo] url]];
        [[[socialData extConfig] wechatSessionData] setTitle:[[self evShareInfo] title]];
        [[[socialData extConfig] wechatSessionData] setShareText:[[self evShareInfo] content]];
        [[[socialData extConfig] wechatSessionData] setWxMessageType:UMSocialWXMessageTypeWeb];
        [[[socialData extConfig] wechatSessionData] setShareImage:[[self evShareInfo] image]];
        [[[socialData extConfig] wechatSessionData] setUrlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[[self evShareInfo] imageUrl]]];
    }
    else if ([platformName isEqualToString:UMShareToWechatFavorite]) {
        
        [[[socialData extConfig] wechatFavoriteData] setUrl:[[self evShareInfo] url]];
        [[[socialData extConfig] wechatFavoriteData] setTitle:[[self evShareInfo] title]];
        [[[socialData extConfig] wechatFavoriteData] setShareText:[[self evShareInfo] content]];
        [[[socialData extConfig] wechatFavoriteData] setWxMessageType:UMSocialWXMessageTypeWeb];
        [[[socialData extConfig] wechatFavoriteData] setShareImage:[[self evShareInfo] image]];
        [[[socialData extConfig] wechatFavoriteData] setUrlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[[self evShareInfo] imageUrl]]];
    }
    else if ([platformName isEqualToString:UMShareToWechatTimeline]) {
        
        [[[socialData extConfig] wechatTimelineData] setUrl:[[self evShareInfo] url]];
        [[[socialData extConfig] wechatTimelineData] setTitle:fmts(@"[%@]%@", [[self evShareInfo] title], [[self evShareInfo] content])];
        [[[socialData extConfig] wechatTimelineData] setShareText:[[self evShareInfo] content]];
        [[[socialData extConfig] wechatTimelineData] setWxMessageType:UMSocialWXMessageTypeWeb];
        [[[socialData extConfig] wechatTimelineData] setShareImage:[[self evShareInfo] image]];
        [[[socialData extConfig] wechatTimelineData] setUrlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[[self evShareInfo] imageUrl]]];
    }
    else if ([platformName isEqualToString:UMShareToQQ]) {
        
        [[[socialData extConfig] qqData] setUrl:[[self evShareInfo] url]];
        [[[socialData extConfig] qqData] setTitle:[[self evShareInfo] title]];
        [[[socialData extConfig] qqData] setShareText:[[self evShareInfo] content]];
        [[[socialData extConfig] qqData] setQqMessageType:UMSocialQQMessageTypeDefault];
        [[[socialData extConfig] qqData] setShareImage:[[self evShareInfo] image]];
        [[[socialData extConfig] qqData] setUrlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[[self evShareInfo] imageUrl]]];
    }
    else if ([platformName isEqualToString:UMShareToQzone]) {
        
        [[[socialData extConfig] qzoneData] setUrl:[[self evShareInfo] url]];
        [[[socialData extConfig] qzoneData] setTitle:[[self evShareInfo] title]];
        [[[socialData extConfig] qzoneData] setShareText:[[self evShareInfo] content]];
        [[[socialData extConfig] qzoneData] setShareImage:[[self evShareInfo] image]];
    }
    else if ([platformName isEqualToString:UMShareToSina]) {
        
        [[[socialData extConfig] sinaData] setShareText:fmts(@"[%@]%@%@", [[self evShareInfo] title], [[self evShareInfo] content], [[self evShareInfo] url])];
        [[[socialData extConfig] sinaData] setUrlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[[self evShareInfo] imageUrl]]];
    }
    else if ([platformName isEqualToString:UMShareToSms]) {
        
        [[[socialData extConfig] smsData] setShareText:fmts(@"[%@]%@%@", [[self evShareInfo] title], [[self evShareInfo] content], [[self evShareInfo] url])];
        [[[socialData extConfig] smsData] setShareImage:[[self evShareInfo] image]];
    }
    else if ([platformName isEqualToString:UMShareToEmail]) {
        
        [[[socialData extConfig] emailData] setTitle:[[self evShareInfo] title]];
        [[[socialData extConfig] emailData] setShareText:fmts(@"%@%@", [[self evShareInfo] content], [[self evShareInfo] url])];
        [[[socialData extConfig] emailData] setShareImage:[[self evShareInfo] image]];
    }
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    
    NIF_DEBUG(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess){
        //得到分享到的微博平台名
        NIF_DEBUG(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
