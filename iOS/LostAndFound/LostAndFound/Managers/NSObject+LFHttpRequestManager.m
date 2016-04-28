//
//  LFHttpRequestManager.m
//  LostAndFound
//
//  Created by Marike Jave on 14-9-23.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//
#import <Foundation/NSObjCRuntime.h>
#import "LFHttpRequestManager.h"
#import "NSObject+LFHttpRequestManager.h"

@implementation NSObject (HttpRequestManager)

/**
 
 接口编号：	M0.1.0
 接口描述：	初始化
 接口校验：	需要
 登录校验：	需要
 数据返回类型：	results
 
 */

- (LFHttpRequest*)efInitialWithDeviceNumber:(NSString*)deviceNumber
                                deviceToken:(NSString*)deviceToken
                                 appVersion:(NSString*)appVersion
                              bundleVersion:(NSString*)bundleVersion
                              systemVersion:(NSString*)systemVersion
                                 deviceName:(NSString*)deviceName
                                deviceModel:(NSString*)deviceModel
                                    success:(XLFNoneResultSuccessedBlock)successedBlock
                                    failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"deviceType":itos(LFDeviceTypeIOS),
                             @"deviceNumber":ntoe(deviceNumber),
                             @"deviceToken":ntoe(deviceToken),
                             @"appVersion":ntoe(appVersion),
                             @"bundleVersion":ntoe(bundleVersion),
                             @"systemVersion":ntoe(systemVersion),
                             @"deviceName":ntoe(deviceName),
                             @"deviceModel":ntoe(deviceModel),
                             @"sid":ntoe([[LFUserManagerRef evLocalUser] sid])};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M0" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForLogin
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results) {
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
    
}

/**
 
 接口编号：	M1.1.0
 接口描述：	登录
 接口校验：	需要
 登录校验：	不需要
 数据返回类型：	results
 
 ----------------------------------------------------------------------------------
 
 传入参数:Map
 参数中文名	参数英文名        参数类型       是否必填                 说明
 用户名	    account        字符串         platformId为0时，必填
 密码	    password        md5位字符串    platformId为0时，必填
 平台编号	    platformId      数值           是                      为0时为标准登录，校验userId,password，反之，校验platformAccount
 平台账号	    platformAccount	字符串         platformId不为0时，必填   platformId不为0时，校验该字段
 设备类型	    deviceType      数值           是                      0:未知设备类型，1:iOS，2:android，3:WindowsPhone
 设备号	    deviceNum       字符串         是                      设备唯一标示（用于多点登录）
 设备令牌	    deviceToken     字符串         否 ，iOS选填             设备令牌用于推送
 
 */

- (LFHttpRequest*)efLoginWithAccount:(NSString*)account
                            password:(NSString*)password
                        platformType:(LFPlatformType)platformType
                              openId:(NSString*)openId
                         deviceToken:(NSString*)deviceToken
                              genter:(NSInteger)genter
                            nickname:(NSString*)nickname
                        headImageUrl:(NSString*)headImageUrl
                             success:(LFLoginSuccessedBlock)successedBlock
                             failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"account":ntoe(account),
                             @"password":ntoe(password),
                             @"platformType":itos(platformType),
                             @"openId":ntoe(openId),
                             @"deviceToken":ntoe(deviceToken),
                             @"genter":itos(genter),
                             @"nickname":ntoe(nickname),
                             @"headImageUrl":ntoe(headImageUrl)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M1" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForLogin
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results) {
                                               successedBlock((id)request , results , [LFUser modelWithAttributes:[results firstObject]]);
                                           }
                                           failure:failedBlock];
    
}

/**
 
 接口编号：	M2.1.0
 接口描述：	获取用户信息
 接口校验：	需要
 登录校验：	需要
 数据返回类型：	results
 
 ----------------------------------------------------------------------------------
 
 传入参数:Map
 参数中文名	参数英文名	参数类型	是否必填	说明
 用户ID	userId	数值	是
 
 ----------------------------------------------------------------------------------
 
 返回参数:Map
 参数中文名	参数英文名       参数类型	说明
 用户名      account        字符串
 头像地址    headImgUrl	    字符串
 Email      email           字符串
 真是姓名    realName        字符串
 电话       telephone	    字符串
 金币	    coin            数值
 收藏数      collectCount	    数值
 发布数	    distributeCount	数值
 总收益	    achievement	    数值
 
 ----------------------------------------------------------------------------------
 
 例子
 "{
 "code":200,
 "data":{
 "account":"aaaa",
 "headImgUrl":"http://www.asds.com/img.png",
 "email":"30000@qq.com",
 "realName":"小明",
 "telephone":"13033334444",
 "coin":100,
 "collectionCount":12,
 "distributeCount":32,
 "achievement":2342,
 }
 }"
 
 */

- (LFHttpRequest*)efGetUserInfoWithSuccess:(LFUserSuccessedBlock)successedBlock
                                   failure:(XLFFailedBlock)failedBlock;{
    NSDictionary *params = @{};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M2" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetUserInfo
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results) {
                                               successedBlock((id)request , results , [LFUser modelWithAttributes:results] );
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M3.1.0
 接口描述：	修改用户信息
 接口校验：	需要
 登录校验：	需要
 数据返回类型：	results
 
 ----------------------------------------------------------------------------------
 
 传入参数:Map
 参数中文名	参数英文名	参数类型	是否必填	说明
 用户ID	    userId       数值	是
 头像      headImgUrl	字符串	否
 Email      email        字符串	否
 真是姓名    realName     字符串	否
 电话        telephone	 字符串	否
 
 ----------------------------------------------------------------------------------
 
 返回参数：无
 例子
 "{
 "code":200,
 "data":{}
 }"
 
 */

- (LFHttpRequest*)efModifyUserInfoWithHeadImgUrl:(NSString*)headImgUrl
                                           email:(NSString*)email
                                        nickname:(NSString*)nickname
                                        realname:(NSString*)realname
                                       telephone:(NSString*)telephone
                                      modifyType:(LFModitfyUserInfoType)modifyType
                                         success:(XLFNoneResultSuccessedBlock)successedBlock
                                         failure:(XLFFailedBlock)failedBlock;{
    
    return [self efModifyUserInfoWithUserId:nil
                                 headImgUrl:headImgUrl
                                      email:email
                                   nickname:nickname
                                   realname:realname
                                  telephone:telephone
                                 modifyType:modifyType
                                    success:successedBlock
                                    failure:failedBlock];
}

- (LFHttpRequest*)efModifyUserInfoWithUserId:(NSString*)userId
                                  headImgUrl:(NSString*)headImgUrl
                                       email:(NSString*)email
                                    nickname:(NSString*)nickname
                                    realname:(NSString*)realname
                                   telephone:(NSString*)telephone
                                  modifyType:(LFModitfyUserInfoType)modifyType
                                     success:(XLFNoneResultSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (userId) {
        [params setObject:ntoe(userId) forKey:@"uid"];
    }
    if (modifyType & LFModitfyUserInfoTypeHeadImage) {
        [params setObject:ntoe(headImgUrl) forKey:@"headImgUrl"];
    }
    if (modifyType & LFModitfyUserInfoTypeEmail) {
        [params setObject:ntoe(email) forKey:@"email"];
    }
    if (modifyType & LFModitfyUserInfoTypeNickname) {
        [params setObject:ntoe(nickname) forKey:@"nickname"];
    }
    if (modifyType & LFModitfyUserInfoTypeRealname) {
        [params setObject:ntoe(realname) forKey:@"realname"];
    }
    if (modifyType & LFModitfyUserInfoTypeTelephone) {
        [params setObject:ntoe(telephone) forKey:@"telephone"];
    }
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M3" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForModifyUser
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M4.1.0
 接口描述：	用户反馈
 接口校验：	需要
 登录校验：	需要
 数据返回类型：	results
 
 */

- (LFHttpRequest*)efFeedbackWithContent:(NSString*)content
                                   name:(NSString*)name
                              telephone:(NSString*)telephone
                                success:(XLFNoneResultSuccessedBlock)successedBlock
                                failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"content":ntoe(content),
                             @"name":ntoe(name),
                             @"telephone":ntoe(telephone)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M4" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForFeedback
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
}

/**
 接口编号：	M5.1.0
 接口描述：	获取公告分类
 接口校验：	需要
 登录校验：	不需要
 数据返回类型：	results
 *
 *  获取公告分类
 *
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efGetNoticeCategoriesWithSuccess:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                           failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M5" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetNoticeCategories
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               successedBlock((id)request, results, [results modelsWithClass:[LFCategory class]]);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M6.0
 接口描述：	发送验证码
 接口校验：	需要
 登录校验：	不需要
 数据返回类型：	results
 
 ----------------------------------------------------------------------------------
 
 传入参数:Map
 参数中文名	参数英文名	参数类型                是否必填            说明
 手机号码    telephone	字符串（base64位字符串）  type为1时，必填
 邮箱       email        字符串（base64位字符串）  type为0时，必填
 验证类型    type         数值                   是                验证类型 ， 0：邮箱 ，1：手机
 
 ----------------------------------------------------------------------------------
 
 返回参数:Map
 参数中文名	参数英文名	参数类型	说明
 验证码	code	字符串
 
 ----------------------------------------------------------------------------------
 
 例子
 "{
 "code":200,
 "data":{ "code":"324224" }
 }"
 
 */

- (LFHttpRequest*)efSendCodeWithAccount:(NSString*)account
                                   type:(LFPlatformType)type
                                success:(LFVerifyCodeSuccessedBlock)successedBlock
                                failure:(XLFFailedBlock)failedBlock;{
    NSDictionary *params = @{@"account":ntoe(account),
                             @"type":itos(type)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M6" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForSendCode
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, NSArray * results) {
                                               successedBlock((id)request , results , [[results modelsWithClass:[LFVerifyCode class]] firstObject]);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M7.1.0
 接口描述：	注册
 接口校验：	需要
 登录校验：	不需要
 数据返回类型：	results
 
 ----------------------------------------------------------------------------------
 
 传入参数:Map
 参数中文名	参数英文名	参数类型                是否必填	说明
 用户名      account    字符串                   是
 密码        password	字符串（base64位字符串）	是
 
 ----------------------------------------------------------------------------------
 
 返回参数：无
 例子
 "{
 "code":200,
 "data":{ }
 }"
 */

- (LFHttpRequest*)efRegisterWithAccount:(NSString*)account
                               password:(NSString*)password
                           platformType:(LFPlatformType)platformType
                                   code:(NSString*)code
                                   zone:(NSString*)zone
                                 secret:(NSString*)secret
                                success:(XLFNoneResultSuccessedBlock)successedBlock
                                failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"account":ntoe(account),
                             @"password":ntoe(password),
                             @"platformType":itos(platformType),
                             @"code":ntoe(code),
                             @"zone":ntoe(zone),
                             @"secret":ntoe(secret)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M7" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForRegister
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
    
}

/**
 
 接口编号：	M8.1.0
 接口描述：	重置密码
 接口校验：	需要
 登录校验：	不需要
 数据返回类型：	results
 
 ----------------------------------------------------------------------------------
 
 传入参数:Map
 参数中文名	 参数英文名	  参数类型                是否必填	说明
 手机号码     telephone	  字符串（base64位字符串）	 type为1时，必填
 邮箱         email        字符串（base64位字符串）	 type为0时，必填
 验证类型      type         数值                   是             类型 ， 0：邮箱，1：手机
 新密码       newPassword	  字符串（base64位字符串）	 是
 验证码        code        字符串                  是
 
 ----------------------------------------------------------------------------------
 
 返回参数：无
 例子
 "{
 "code":200,
 "data":{ }
 }"
 
 */
- (LFHttpRequest*)efResetPasswordWithAccount:(NSString*)account
                                 newPassword:(NSString*)newPassword
                                platformType:(LFPlatformType)platformType
                                        zone:(NSString*)zone
                                        code:(NSString*)code
                                      secret:(NSString*)secret
                                     success:(XLFNoneResultSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"account":ntoe(account),
                             @"newPassword":ntoe(newPassword),
                             @"platformType":itos(platformType),
                             @"zone":ntoe(zone),
                             @"code":ntoe(code),
                             @"secret":ntoe(secret)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M8" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForResetPassword
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M9.1.0
 接口描述：	修改密码
 接口校验：	需要
 登录校验：	需要
 数据返回类型：	results
 
 ----------------------------------------------------------------------------------
 
 传入参数:Map
 参数中文名    参数英文名      参数类型               是否必填            说明
 旧密码       oldPassword 	字符串（base64位字符串）	是
 新密码       newPassword   	字符串（base64位字符串）	是
 
 ----------------------------------------------------------------------------------
 
 返回参数：无
 例子	"{
 "code":200,
 "data":{ }
 }"
 
 */

- (LFHttpRequest*)efModifyPasswordOldPassword:(NSString*)oldPassword
                                  newPassword:(NSString*)newPassword
                                      success:(XLFNoneResultSuccessedBlock)successedBlock
                                      failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"oldPassword":ntoe(oldPassword),
                             @"newPassword":ntoe(newPassword)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M9" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForModifyPassword
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M10.1.0
 接口描述：	获取用户公告
 接口校验：	需要
 登录校验：	需要
 
 */
- (LFHttpRequest*)efGetUserNoticesWithNoticeType:(LFNoticeType)noticeType
                                      categoryId:(NSString *)categoryId
                                            page:(NSInteger)page
                                            size:(NSInteger)size
                                         success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                         failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"noticeType":itos(noticeType),
                             @"cid":ntoe(categoryId),
                             @"page":itos(page),
                             @"size":itos(size)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M10" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetUserNotices
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               if (noticeType == LFNoticeTypeFound) {
                                                   successedBlock((id)request, results, [results modelsWithClass:[LFFound class]]);
                                               }
                                               if (noticeType == LFNoticeTypeLost) {
                                                   successedBlock((id)request, results, [results modelsWithClass:[LFLost class]]);
                                               }
                                               if (noticeType == (LFNoticeTypeFound | LFNoticeTypeLost)) {
                                                   successedBlock((id)request, results, [results modelsWithClass:[LFNotice class]]);
                                               }
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M11.1.0
 接口描述：	获取公告列表
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efGetNoticesWithNoticeType:(LFNoticeType)noticeType
                                  categoryId:(NSString *)categoryId
                                        time:(NSString *)time
                                        more:(BOOL)more
                                        size:(NSInteger)size
                                     success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"noticeType":itos(noticeType),
                             @"cid":ntoe(categoryId),
                             @"time":ntoe(time),
                             @"more":itos(more),
                             @"size":itos(size)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M11" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetNotices
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request, results,
                                                              [results modelsWithClass:select(noticeType == LFNoticeTypeAll, [LFNotice class],
                                                                                              select(noticeType == LFNoticeTypeLost, [LFLost class], [LFFound class]))]);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M12.1.0
 接口描述：	获取寻物启事详情
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efGetLostDetailWithLostId:(NSString *)lostId
                                    success:(LFGetLostDetailSuccessedBlock)successedBlock
                                    failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"id":ntoe(lostId)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M12" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetLostDetail
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               successedBlock((id)request, results, [[results modelsWithClass:[LFLost class]] firstObject]);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M13.1.0
 接口描述：	获取失物招领详情
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efGetFoundDetailWithFoundId:(NSString *)foundId
                                      success:(LFGetFoundDetailSuccessedBlock)successedBlock
                                      failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"id":ntoe(foundId)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M13" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetFoundDetail
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               successedBlock((id)request, results, [[results modelsWithClass:[LFFound class]] firstObject]);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M14.1.0
 接口描述：	和公告发布者取得联系
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efContactNoticePublisherWithNoticeId:(NSString *)noticeId
                                               success:(LFUserSuccessedBlock)successedBlock
                                               failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"noticeId":ntoe(noticeId)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M14" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForContactNoticePublisher
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               successedBlock((id)request, results, [[results modelsWithClass:[LFUser class]] firstObject]);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M15.1.0
 接口描述：	关闭公告
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efCloseNoticeWithNoiticeId:(NSString *)noiticeId
                                     success:(XLFSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"noticeId":ntoe(noiticeId)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M15" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForCloseNotice
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:successedBlock
                                           failure:failedBlock];
}

/**
 
 接口编号：	M16.1.0
 接口描述：	创建寻物启事
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efCreateLostWithTitle:(NSString *)title
                             happenTime:(NSString *)happenTime
                               category:(LFCategory *)category
                               location:(LFLocation *)location
                              locations:(NSArray<LFLocation *> *)locations
                                regions:(NSArray<LFRegion *> *)regions
                                 images:(NSArray<LFImage *> *)images
                                success:(XLFOnlyStringResponseSuccessedBlock)successedBlock
                                failure:(XLFFailedBlock)failedBlock;{
    
    NSMutableArray<NSDictionary *> *etImages = [NSMutableArray<NSDictionary *> array];
    
    for (LFImage *image in images) {
        
        [etImages addObject:@{@"title":ntoe([image title]),
                              @"remoteId":ntoe([image remoteId])}];
    }
    
    NSMutableArray *etLocations = [NSMutableArray<NSDictionary *> array];
    
    for (LFLocation *location in locations) {
        
        [etLocations addObject:@{@"name":ntoe([location name]),
                                 @"address":ntoe([location address]),
                                 @"aliss":ntoe([location aliss]),
                                 @"latitude":ftos([location latitude]),
                                 @"longitude":ftos([location longitude])}];
    }
    
    NSMutableArray *etRegions = [NSMutableArray<NSArray *> array];
    
    for (LFRegion *region in regions) {
        
        NSMutableArray *etRegion = [NSMutableArray<NSDictionary *> array];
        
        for (LFLocation *location in [region locations]) {
            
            [etRegion addObject:@{@"name":ntoe([location name]),
                                  @"address":ntoe([location address]),
                                  @"aliss":ntoe([location aliss]),
                                  @"latitude":ftos([location latitude]),
                                  @"longitude":ftos([location longitude])}];
        }
        
        [etRegions addObject:etRegion];
    }
    
    NSDictionary *params = @{@"title":ntoe(title),
                             @"happenTime":ntoe(happenTime),
                             @"cid":ntoe([category id]),
                             @"location":@{@"name":ntoe([location name]),
                                           @"address":ntoe([location address]),
                                           @"aliss":ntoe([location aliss]),
                                           @"latitude":ftos([location latitude]),
                                           @"longitude":ftos([location longitude])},
                             @"images":etImages,
                             @"locations":etLocations,
                             @"regions":etRegions};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M16" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForCreateLost
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               successedBlock((id)request, results, [[results firstObject] modelWithClass:[LFNoticeBase class]]);
                                           }
                                           failure:failedBlock];
}

- (LFHttpRequest*)efCreateLostWithLost:(LFLost *)lost
                               success:(LFCreateNoticeSuccessedBlock)successedBlock
                               failure:(XLFFailedBlock)failedBlock;{
    
    return [self efCreateLostWithTitle:[lost title]
                            happenTime:[lost happenTime]
                              category:[lost category]
                              location:[lost location]
                             locations:[lost locations]
                               regions:[lost regions]
                                images:[lost images]
                               success:successedBlock
                               failure:failedBlock];
}

/**
 
 接口编号：	M17.1.0
 接口描述：	创建失物招领
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efCreateFoundWithTitle:(NSString *)title
                              happenTime:(NSString *)happenTime
                                category:(LFCategory *)category
                                location:(LFLocation *)location
                                  images:(NSArray<LFImage *> *)images
                                 success:(LFCreateNoticeSuccessedBlock)successedBlock
                                 failure:(XLFFailedBlock)failedBlock;{
    
    NSMutableArray<NSDictionary *> *etImages = [NSMutableArray<NSDictionary *> array];
    
    for (LFImage *image in images) {
        
        [etImages addObject:@{@"title":ntoe([image title]),
                              @"remoteId":ntoe([image remoteId])}];
    }
    
    NSDictionary *params = @{@"title":ntoe(title),
                             @"happenTime":ntoe(happenTime),
                             @"cid":ntoe([category id]),
                             @"location":@{@"name":ntoe([location name]),
                                           @"address":ntoe([location address]),
                                           @"aliss":ntoe([location aliss]),
                                           @"latitude":ftos([location latitude]),
                                           @"longitude":ftos([location longitude])},
                             @"images":etImages};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M17" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForCreateFound
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               successedBlock((id)request, results, [[results modelsWithClass:[LFNoticeBase class]] firstObject]);
                                           }
                                           failure:failedBlock];
}

- (LFHttpRequest*)efCreateFoundWithFound:(LFFound *)found
                                 success:(LFCreateNoticeSuccessedBlock)successedBlock
                                 failure:(XLFFailedBlock)failedBlock;{
    
    return [self efCreateFoundWithTitle:[found title]
                             happenTime:[found happenTime]
                               category:[found category]
                               location:[found location]
                                 images:[found images]
                                success:successedBlock
                                failure:failedBlock];
}

/**
 *
 接口编号：	M18.0
 接口描述：	上传文件 或者 上传图片
 接口校验：	需要
 登录校验：	需要
 数据返回类型：	json
 
 */
- (LFHttpRequest*)efUploadFileWithFileData:(NSData*)fileData
                               contentType:(NSString*)contentType
                                      type:(XLFFileType)type
                                   success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                   failure:(XLFFailedBlock)failedBlock;{
    
    NSMutableArray<XLFUploadFile *> *fileDatas = [NSMutableArray<XLFUploadFile *> array];
    
    [fileDatas addObject:[XLFUploadFile uploadFileWithFileData:fileData fileName:nil contentType:contentType type:type]];
    
    return [self efUploadFilesWithFileDatas:fileDatas
                                    success:successedBlock
                                    failure:failedBlock];
}

- (LFHttpRequest*)efUploadFilesWithFileDatas:(NSArray<XLFUploadFile *> *)fileDatas
                                     success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;{
    if (!fileDatas || ![fileDatas count]) {
        return nil;
    }
    
    XLFHttpParameter *etParameters = [LFHttpRequestManager headerParamsWithMethodId:@"M18" version:@"1.0" params:@{}];
    
    NSMutableDictionary *etFileParams = [NSMutableDictionary dictionary];
    [fileDatas enumerateObjectsUsingBlock:^(XLFUploadFile * _Nonnull uploadFile, NSUInteger nIndex, BOOL * _Nonnull stop) {
        [etFileParams setValue:uploadFile forKey:fmts(@"file%d", nIndex)];
    }];
    
    [etParameters setFormParams:etFileParams];
    
    LFHttpRequest *etRequest = [LFHttpRequestManager requestWithParams:etParameters
                                                            httpMethod:XLFHttpRquestModePost
                                                               withTag:LFHttpRequestTagForUploadFile
                                                     hiddenLoadingView:YES
                                                        relationObject:self
                                                               success:^(XLFBaseHttpRequest *request, id results){
                                                                   successedBlock((id)request, results, results);
                                                               }
                                                               failure:failedBlock];
    
    return etRequest;
}

/**
 
 接口编号：	M19.1.0
 接口描述：	登出
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efLogoutWithSuccess:(XLFNoneResultSuccessedBlock)successedBlock
                              failure:(XLFFailedBlock)failedBlock;{
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M19" version:@"1.0" params:@{}]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForLogout
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M20.1.0
 接口描述：	获取常用图片
 接口校验：	需要
 登录校验：	需要
 
 */
- (LFHttpRequest*)efGetCommonImagesWithPage:(NSInteger)page
                                       size:(NSInteger)size
                                    success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                    failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"page":itos(page),
                             @"size":itos(size)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M20" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetCommonImages
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request, results, [results modelsWithClass:[LFImage class]]);
                                           }
                                           failure:failedBlock];
}

/**
 
 接口编号：	M21.1.0
 接口描述：	获取常用图片
 接口校验：	需要
 登录校验：	需要
 
 */
- (LFHttpRequest*)efModifyTelephone:(NSString *)telephone
                               code:(NSString *)code
                               zone:(NSString *)zone
                            success:(XLFNoneResultSuccessedBlock)successedBlock
                            failure:(XLFFailedBlock)failedBlock;{
    
    NSDictionary *params = @{@"telephone":ntoe(telephone),
                             @"code":ntoe(code),
                             @"zone":ntoe(zone)};
    
    return [LFHttpRequestManager requestWithParams:[LFHttpRequestManager formParamsWithMethodId:@"M21" version:@"1.0" params:params]
                                        httpMethod:XLFHttpRquestModePost
                                           withTag:LFHttpRequestTagForGetCommonImages
                                 hiddenLoadingView:YES
                                    relationObject:self
                                           success:^(XLFBaseHttpRequest *request, id results){
                                               
                                               successedBlock((id)request);
                                           }
                                           failure:failedBlock];
}

- (LFHttpRequest *)fileRequestWithUrl:(NSString*)fileUrl
                    hiddenLoadingView:(BOOL)hiddenLoadingView
                              success:(XLFSuccessedBlock)successedBlock
                              failure:(XLFFailedBlock)failedBlock;{
    
    return [LFHttpRequestManager fileRequestWithUrl:fileUrl
                                  hiddenLoadingView:hiddenLoadingView
                                     relationObject:self
                                            success:successedBlock
                                            failure:failedBlock];
}

@end


