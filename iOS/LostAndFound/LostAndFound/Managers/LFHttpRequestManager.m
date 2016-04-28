//
//  LFHttpRequestManager.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-23.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//
#import <Foundation/NSObjCRuntime.h>
#import <XLFCommonKit/XLFCommonKit.h>
#import <PrivateAPI/PrivateAPI.h>

#import "LFHttpRequestManager.h"

#import "LFConfigManager.h"

#pragma mark 配置文件属性  config.json文件配置

#define BUILD_ENVIROMENT BUILD_ENVIRONMENT_PREPARE_PRODUCTION

#if (BUILD_ENVIROMENT == BUILD_ENVIRONMENT_PRODUCTION)

#define ServerURL           [[LFConfigManager shareConfigManager] serverUrl]
#define ServerImageUrl      [[LFConfigManager shareConfigManager] imageServerUrl]
#define ServerFileUrl       [[LFConfigManager shareConfigManager] fileUrl]
#define ServerVideoUrl      [[LFConfigManager shareConfigManager] videoUrl]

#elif (BUILD_ENVIROMENT == BUILD_ENVIRONMENT_PREPARE_PRODUCTION)

#define ServerURL           [[LFConfigManager shareConfigManager] releaseServerUrl]
#define ServerImageUrl      [[LFConfigManager shareConfigManager] releaseImageUrl]
#define ServerFileUrl       [[LFConfigManager shareConfigManager] releaseFileUrl]
#define ServerVideoUrl      [[LFConfigManager shareConfigManager] releaseVideoUrl]

#else

#define ServerURL           [[LFConfigManager shareConfigManager] debugServerUrl]
#define ServerImageUrl      [[LFConfigManager shareConfigManager] debugImageUrl]
#define ServerFileUrl       [[LFConfigManager shareConfigManager] debugFileUrl]
#define ServerVideoUrl      [[LFConfigManager shareConfigManager] debugVideoUrl]

#endif


@implementation LFHttpRequest

- (BOOL)filter:(NSData*)responseData result:(id*)result/* json or xml */ error:(NSError **)err;{
    
    id json = [responseData objectFromJSONData];
    
    if (!json) {
        
        NIF_ERROR(@"%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        
        *err = [[NSError alloc] initWithDomain:@"解析失败" code:NSIntegerMax userInfo:[self descInfo]];
        
        return NO;
    }
    
    if ([json isKindOfClass:[NSArray class]]) {
        json = [json firstObject];
    }
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        
        NSInteger statusCode = [[json objectForKey:@"code"] integerValue];
        NSString *message = ntoe([json objectForKey:@"message"]);
        
        if ([self responseStatusCode] == 200 && statusCode == 200) {
            *result = [json objectForKey:@"data"];
            if (![*result isKindOfClass:[NSDictionary class]] && ![*result isKindOfClass:[NSArray class]]) {
                
                *result = nil;
            }
            return YES;
        }
        if (![message length]) {
            
            message = NSLocalizedString(itos(statusCode),nil);
        }
        *err = [[NSError alloc] initWithDomain:message code:statusCode userInfo:nil];
    }
    else {
        *err = [[NSError alloc] initWithDomain:@"系统异常" code:0 userInfo:nil];
    }
    return NO;
}

- (BOOL)shouldListeningError:(NSError *)err{
    
    return [[self listeningErrorInfos] containsObject:itos([err code])];
}

@end

@interface LFHttpRequestManager ()

@property(nonatomic, copy) NSArray *evListeningErrorCodes;

@end

@implementation LFHttpRequestManager

+ (void)load{
    [super load];
    
    [[self class] registerHttpRequestClass:[LFHttpRequest class]];
}

- (instancetype)init{
    self = [super init];
    
    if (self) {
        
        [LFHttpRequest registerListeningErrorBlockForGlobal:[self _efListeningErrorCallback]];
        
        [self setEvListeningErrorCodes:@[@"10001", @"10004", @"10011"]];
    }
    return self;
}

- (void (^)(LFHttpRequest *httpRequest, NSError *error))_efListeningErrorCallback{
    
    return ^(LFHttpRequest *httpRequest, NSError *error){
        
        [LFUserManager efLogout];
    };
}

/**
 *  业务参数 转换成 表单参数
 *
 *  @param params 业务参数
 *
 *  @return form 表单餐宿
 */

/**
 
 表单参数1：	 Key	m
	Value	 接口编号加上版本号  如：M1.1 ，其中M1是接口号 ，".1" 是版本号
	类型      字符串
	描述      每个接口方法有一个编号
 
 表单参数2：	 Key	p
	Value	 业务参数	业务参数
	类型      字符串
	描述      具体业务的参数，value为map类型
 
 表单参数3：	 Key	u
	Value	 id
	类型      字符串
	描述      "s端颁发给c端的登录凭证，
 部分请求须携带此参数，
 方便服务端做权限校验"
 
 表单参数4：	 Key	s
	Value	 md5，16进制编码
	类型      字符串
	描述      签名
 
 */

+ (XLFHttpParameter*)formParamsWithMethodId:(NSString *)methodId
                                    version:(NSString *)version
                                     params:(NSDictionary*)params;
{
    NSString *method = ntoe(methodId) ;
    NSString *parameters = ntoe([params JSONString]);
    NSString *session = ntoe([[[LFUserManager shareManager] evLocalUser] sid]);
    
    NSString *encryption = [LFEncriptionPrivateUtil encriptionWithMethod:method session:session parameters:parameters];
    
    NSDictionary *formParams = @{@"m":method,
                                 @"p":parameters,
                                 @"s":session,
                                 @"k":encryption,
                                 @"v":ntoe(version)};
    
    NSDictionary *headerParams = @{@"paramArea":@"form"};
    
    XLFHttpParameter *etHttpParameter = [XLFHttpParameter new];
    
    [etHttpParameter setHandle:ServerURL];
    [etHttpParameter setFormParams:formParams];
    [etHttpParameter setHeadParams:headerParams];
    
    return etHttpParameter;
}

+ (XLFHttpParameter*)headerParamsWithMethodId:(NSString *)methodId
                                      version:(NSString *)version
                                       params:(NSDictionary*)params;
{
    
    NSString *method = ntoe(methodId) ;
    NSString *parameters = ntoe([params JSONString]);
    NSString *session = ntoe([[[LFUserManager shareManager] evLocalUser] sid]);
    
    NSString *encryption = [LFEncriptionPrivateUtil encriptionWithMethod:method session:session parameters:parameters];
    
    NSDictionary *headerParams = @{@"m":method,
                                   @"p":parameters,
                                   @"s":session,
                                   @"k":encryption,
                                   @"v":ntoe(version),
                                   @"paramArea":@"header"};
    
    XLFHttpParameter *etHttpParameter = [XLFHttpParameter new];
    
    [etHttpParameter setHandle:ServerURL];
    [etHttpParameter setHeadParams:headerParams];
    
    return etHttpParameter;
}

/**
 *  根据参数创建请求
 *  默认为
 *
 *  @param params 参数
 *  @param method 请求类型
 *
 *  @return 请求对象
 */
+ (id)requestWithParams:(XLFHttpParameter *)params
                 method:(NSString *)method;{
    
    LFHttpRequest *etRequest = [super requestWithParams:params method:method];
    
    NSArray *etListeningErrorCodes = [[self sharedInstance] evListeningErrorCodes];
    
    if (etListeningErrorCodes && [etListeningErrorCodes count]) {
        
        [etRequest setListeningErrorInfos:etListeningErrorCodes];
    }
    
    return etRequest;
}

/**
 *  参数名称	必填	说明
 
 图片ID（文件ID）	id      字符串	是
 图片缩放       scale    字符串	否
 裁剪锚点       anchor	字符串	否
 图片裁剪       crop     字符串	否
 图片质量       quality	数值     否
 图片旋转角度    rotate	数值     否
 图片文件类型    format	字符串	否
 */

/**
 *  根据图像id，参数获取图像链接
 *
 *  @param imageId    图片id
 *  @param scale      图片缩放
 *  @param anchor     裁剪锚点 参看裁剪锚点参数表，只影响其后的裁剪偏移参数，缺省为左上角
 *  @param crop       裁剪尺寸 参看裁剪操作参数表，缺省为不裁剪
 *  @param quality    图片质量 取值范围1-100，缺省为85 如原图质量小于指定质量，则使用原图质量
 *  @param rotate     旋转角度 取值范围1-360，缺省为不旋转
 *  @param format     图片格式 支持jpg、gif、png、webp等，缺省为原图格式
 *
 *  @return 图片链接
 */

+ (NSString*)efImageUrlWithImageId:(NSString*)imageId
                             scale:(NSString*)scale
                            anchor:(NSString*)anchor
                              crop:(NSString*)crop
                           quality:(NSInteger)quality
                            rotate:(NSInteger)rotate
                            format:(NSString*)format;{
    
    NSString *imageUrl = ServerImageUrl;
    
    imageId = [imageId description];
    
    if (![imageId length]) {
        NIF_ERROR(@"图片ID不能为空");
        return nil;
    }
    else{
        imageUrl = [imageUrl stringByAppendingString:fmts(@"?id=%@",imageId)];
    }
    
    if ([scale length]) {
        imageUrl = [imageUrl stringByAppendingString:fmts(@"&scale=%@",scale)];
    }
    if ([anchor length]) {
        imageUrl = [imageUrl stringByAppendingString:fmts(@"&anchor=%@",anchor)];
    }
    if ([crop length]) {
        imageUrl = [imageUrl stringByAppendingString:fmts(@"&crop=%@",crop)];
    }
    if (quality && quality <=100) {
        imageUrl = [imageUrl stringByAppendingString:fmts(@"&quality=%d",quality)];
    }
    else{
        NIF_WARN(@"value:%d des:图片质量%d不合法",quality,quality);
    }
    if (rotate > 0 && rotate < 360) {
        imageUrl = [imageUrl stringByAppendingString:fmts(@"&rotate=%d",rotate)];
    }
    else if (rotate < 0 || rotate > 360 ){
        NIF_WARN(@"value:%d des:图片旋转角度%d不合法",rotate,rotate);
    }
    if ([format length]) {
        imageUrl = [imageUrl stringByAppendingString:fmts(@"&format=%@",format)];
    }
    
    return imageUrl;
}

@end

NSString *egfFileUrl(NSString* fileServer, NSString* fileId){
    
    return [[ServerFileUrl stringByAppendingString:fileServer] stringByAppendingString:fileId];
}

NSString *egfImageUrl(NSString* imageId, NSString* scale, NSString* anchor, NSString* crop, NSInteger quality, NSInteger rotate, NSString* format){
    
    return [LFHttpRequestManager efImageUrlWithImageId:imageId scale:scale anchor:anchor crop:crop quality:quality rotate:rotate format:format];
}

NSString *egfImageUrlDefault(NSString* imageId){
    
    return [ServerImageUrl stringByAppendingFormat:@"?id=%@",imageId];
}
