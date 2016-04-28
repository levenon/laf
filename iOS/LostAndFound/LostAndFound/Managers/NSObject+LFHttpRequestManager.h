//
//  LFHttpRequestManager.h
//  LostAndFound
//
//  Created by Marike Jave on 14-9-23.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import "LFHttpRequestManager.h"

#import "LFUserManager.h"

#import "LFUser.h"

#import "LFLost.h"

#import "LFEditableLost.h"

#import "LFFound.h"

#import "LFEditableFound.h"

#import "LFCategory.h"

#import "LFVerifyCode.h"

/**
 
 接口文档
 
 接口定义
 请求协议：	 http
 请求方式：	 post
 请求格式：	 form表单
 返回数据格式：json/BYTE
 
 ----------------------------------------------------------------------------------
 
 form表单结构：
 
 表单参数1：	Key     M
 Value	接口编号加上版本号  如：M1.1 ，其中M1是接口号 ，".1" 是版本号
 类型     字符串
 描述     每个接口方法有一个编号
 表单参数2：	Key	p
 Value	业务参数	业务参数
 类型     字符串
 描述     具体业务的参数，value为map类型
 表单参数3：	Key	uvk
 Value	uuid
 类型     字符串
 描述     s端颁发给c端的登录凭证，部分请求须携带此参数，方便服务端做权限校验
 表单参数4：	Key	sid
 Value	md5，16进制编码
 类型     字符串
 描述     对m=…&uuid=…&p=…使用md5签名
 
 ----------------------------------------------------------------------------------
 
 返回数据结构：json
 
 字段名	字段类型     描述
 code	int         错误代码，200为正确返回
 data	list/map	返回参数集合，map 或者 list
 
 例子:
 {
 "code":200,
 "data":{
 "key1":"value1",
 "key2":"value2"
 }
 }
 
 ----------------------------------------------------------------------------------
 
 返回数据结构：BYTE
 
 字段名	字段类型    描述
 无     二进制流    数据流
 
 ----------------------------------------------------------------------------------
 
 校验
 接口校验    md5     对“表单参数4”s中的value进行校验
 ----------------------------------------------------------------------------------
 错误代码
 代码编号    描述
 901        访问无效
 902        参数缺失或者不完整
 
 ----------------------------------------------------------------------------------
 
 登录校验    uuid    对“表单参数3”u中的value进行校验，校验登录许可
 ----------------------------------------------------------------------------------
 错误代码
 代码编号	   描述
 903	   无权访问
 904	   登录已过期
 
 ----------------------------------------------------------------------------------
 
 */

@class LFHttpRequest;

typedef void (^LFVerifyCodeSuccessedBlock)(LFHttpRequest *request ,id result ,LFVerifyCode *verifyCode);

typedef void (^LFUsersSuccessedBlock)(LFHttpRequest *request, id json, NSArray *users/* LFUser */);

typedef void (^LFUserSuccessedBlock)(LFHttpRequest *request, id json, LFUser *user/* LFUser */);

typedef void (^LFLoginSuccessedBlock)(LFHttpRequest *request, id json , LFUser *user/* LFUser */);

typedef void (^LFGetLostDetailSuccessedBlock)(LFHttpRequest *request, id json, LFLost *lost);

typedef void (^LFCreateNoticeSuccessedBlock)(LFHttpRequest *request, id json, LFNoticeBase *noticeBase);

typedef void (^LFGetFoundDetailSuccessedBlock)(LFHttpRequest *request, id json, LFFound *found);

typedef NS_ENUM(NSInteger ,HttpRequestTag){
    
    LFHttpRequestTagForUnknown = 1<<3,
    LFHttpRequestTagForLogin = LFHttpRequestTagForUnknown + 1,
    LFHttpRequestTagForRegister,
    LFHttpRequestTagForSendCode,
    LFHttpRequestTagForResetPassword,
    LFHttpRequestTagForModifyPassword,
    LFHttpRequestTagForGetUserInfo,
    LFHttpRequestTagForModifyUser,
    LFHttpRequestTagForGetUserNotices,
    LFHttpRequestTagForGetNotices,
    LFHttpRequestTagForGetLostDetail,
    LFHttpRequestTagForGetFoundDetail,
    LFHttpRequestTagForContactNoticePublisher,
    LFHttpRequestTagForCreateLost,
    LFHttpRequestTagForCreateFound,
    LFHttpRequestTagForCloseNotice,
    LFHttpRequestTagForGetNoticeCategories,
    LFHttpRequestTagForFeedback,
    LFHttpRequestTagForUploadFile,
    LFHttpRequestTagForLogout,
    LFHttpRequestTagForGetCommonImages,
    
    LFHttpRequestTagForProjectAuthDownload = 1<<4
};

@protocol LFHttpRequestManagerProtocol<NSObject>

@optional

/**
 *  初始化
 *
 *  @param deviceType     设备类型
 *  @param deviceNumber   设备号
 *  @param deviceToken    设备令牌
 *  @param successedBlock  成功回调block
 *  @param failedBlock     失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efInitialWithDeviceNumber:(NSString*)deviceNumber
                                deviceToken:(NSString*)deviceToken
                                 appVersion:(NSString*)appVersion
                              bundleVersion:(NSString*)bundleVersion
                              systemVersion:(NSString*)systemVersion
                                 deviceName:(NSString*)deviceName
                                deviceModel:(NSString*)deviceModel
                                    success:(XLFNoneResultSuccessedBlock)successedBlock
                                    failure:(XLFFailedBlock)failedBlock;

/**
 *  登录
 *
 *  @param account        用户名
 *  @param password        密码
 *  @param platformId      平台ID
 *  @param platformAccount 平台账号
 *  @param deviceType      设备类型
 *  @param deviceNum       设备号
 *  @param deviceToken     设备令牌
 *  @param successedBlock  成功回调block
 *  @param failedBlock     失败回调block
 *
 *  @return 请求对象
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
                             failure:(XLFFailedBlock)failedBlock;

/**
 *  注册
 *
 *  @param account       用户名
 *  @param password       密码
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efRegisterWithAccount:(NSString*)account
                               password:(NSString*)password
                           platformType:(LFPlatformType)platformType
                                   code:(NSString*)code
                                   zone:(NSString*)zone
                                 secret:(NSString*)secret
                                success:(XLFNoneResultSuccessedBlock)successedBlock
                                failure:(XLFFailedBlock)failedBlock;

/**
 *  发送验证码
 *
 *  @param telephone      手机号码
 *  @param email          邮箱
 *  @param type           验证码类型
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efSendCodeWithAccount:(NSString*)account
                           platformType:(LFPlatformType)platformType
                                success:(LFVerifyCodeSuccessedBlock)successedBlock
                                failure:(XLFFailedBlock)failedBlock;

/**
 *  重置密码
 *
 *  @param telephone      手机号
 *  @param email          邮箱
 *  @param type           类型
 *  @param newPassword    新密码
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efResetPasswordWithAccount:(NSString*)account
                                 newPassword:(NSString*)newPassword
                                platformType:(LFPlatformType)platformType
                                        zone:(NSString*)zone
                                        code:(NSString*)code
                                      secret:(NSString*)secret
                                     success:(XLFNoneResultSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;

/**
 *  修改密码
 *
 *  @param userId         用户ID
 *  @param oldPassword    旧密码
 *  @param newPassword    新密码
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */

- (LFHttpRequest*)efModifyPasswordWithOldPassword:(NSString*)oldPassword
                                      newPassword:(NSString*)newPassword
                                          success:(XLFNoneResultSuccessedBlock)successedBlock
                                          failure:(XLFFailedBlock)failedBlock;
/**
 *  获取用户信息
 *
 *  @param userId         用户ID
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efGetUserInfoWithSuccess:(LFUserSuccessedBlock)successedBlock
                                   failure:(XLFFailedBlock)failedBlock;

/**
 *  修改用户信息
 *
 *  @param userId         用户ID,如果不传，则为修改自己的用户信息
 *  @param headImgUrl     头像链接
 *  @param email          邮箱数据
 *  @param realName       真实姓名
 *  @param telephone      手机号码
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efModifyUserInfoWithHeadImgUrl:(NSString*)headImgUrl
                                           email:(NSString*)email
                                        nickname:(NSString*)nickname
                                        realname:(NSString*)realname
                                       telephone:(NSString*)telephone
                                      modifyType:(LFModitfyUserInfoType)modifyType
                                         success:(XLFNoneResultSuccessedBlock)successedBlock
                                         failure:(XLFFailedBlock)failedBlock;

- (LFHttpRequest*)efModifyUserInfoWithUserId:(NSString*)userId
                                  headImgUrl:(NSString*)headImgUrl
                                       email:(NSString*)email
                                    nickname:(NSString*)nickname
                                    realname:(NSString*)realname
                                   telephone:(NSString*)telephone
                                  modifyType:(LFModitfyUserInfoType)modifyType
                                     success:(XLFNoneResultSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;
/**
 *  获取用户公告
 *
 *  @param userId         用户id
 *  @param noticeType     公告类型
 *  @param page           页号
 *  @param size           数量
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efGetUserNoticesWithNoticeType:(LFNoticeType)noticeType
                                      categoryId:(NSString *)categoryId
                                            page:(NSInteger)page
                                            size:(NSInteger)size
                                         success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                         failure:(XLFFailedBlock)failedBlock;
/**
 *  获取公告分类
 *
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efGetNoticeCategoriesWithSuccess:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                           failure:(XLFFailedBlock)failedBlock;

/**
 *  获取公告列表
 *
 *  @param noticeType     公告类型
 *  @param page           页号
 *  @param size           数量
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efGetNoticesWithNoticeType:(LFNoticeType)noticeType
                                  categoryId:(NSString *)categoryId
                                        time:(NSString *)time
                                        more:(BOOL)more
                                        size:(NSInteger)size
                                     success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;
/**
 *  获取寻物启事详情
 *
 *  @param lostId       公告ID
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efGetLostDetailWithLostId:(NSString *)lostId
                                    success:(LFGetLostDetailSuccessedBlock)successedBlock
                                    failure:(XLFFailedBlock)failedBlock;
/**
 *  获取失物招领详情
 *
 *  @param lostId         公告ID
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efGetFoundDetailWithFoundId:(NSString *)foundId
                                      success:(LFGetFoundDetailSuccessedBlock)successedBlock
                                      failure:(XLFFailedBlock)failedBlock;

/**
 *  和公告发布者取得联系
 *
 *  @param lostId         公告ID
 *  @param demanderId     需求者ID
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efContactNoticePublisherWithNoticeId:(NSString *)noticeId
                                               success:(LFUserSuccessedBlock)successedBlock
                                               failure:(XLFFailedBlock)failedBlock;

/**
 *  关闭公告
 *
 *  @param userId         用户ID
 *  @param lostId         公告ID
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efCloseNoticeWithNoiticeId:(NSString *)noiticeId
                                     success:(XLFSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;

/**
 *  创建寻物启事
 *
 *  @param userId         用户ID
 *  @param title          标题
 *  @param happenTime     发生时间
 *  @param location       主要地点
 *  @param locations      可能地点
 *  @param images         图片
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efCreateLostWithTitle:(NSString *)title
                             happenTime:(NSString *)happenTime
                               category:(LFCategory *)category
                               location:(LFLocation *)location
                              locations:(NSArray<LFLocation *> *)locations
                                regions:(NSArray<LFRegion *> *)regions
                                 images:(NSArray<LFImage *> *)images
                                success:(LFCreateNoticeSuccessedBlock)successedBlock
                                failure:(XLFFailedBlock)failedBlock;

- (LFHttpRequest*)efCreateLostWithLost:(LFLost *)lost
                               success:(LFCreateNoticeSuccessedBlock)successedBlock
                               failure:(XLFFailedBlock)failedBlock;

/**
 *  创建失物招领
 *
 *  @param userId         用户ID
 *  @param title          标题
 *  @param happenTime     发生时间
 *  @param location       主要地点
 *  @param images         图片
 *  @param successedBlock 成功回调block
 *  @param failedBlock    失败回调block
 *
 *  @return 请求对象
 */
- (LFHttpRequest*)efCreateFoundWithTitle:(NSString *)title
                              happenTime:(NSString *)happenTime
                                category:(LFCategory *)category
                                location:(LFLocation *)location
                                  images:(NSArray<LFImage *> *)images
                                 success:(LFCreateNoticeSuccessedBlock)successedBlock
                                 failure:(XLFFailedBlock)failedBlock;

- (LFHttpRequest*)efCreateFoundWithFound:(LFFound *)found
                                 success:(LFCreateNoticeSuccessedBlock)successedBlock
                                 failure:(XLFFailedBlock)failedBlock;

/**
 *
 接口描述：	上传文件 或者 上传图片
 接口校验：	需要
 登录校验：	需要
 数据返回类型：	json
 
 ----------------------------------------------------------------------------------
 
 传入参数:无
 参数中文名	参数英文名	参数类型	是否必填	说明
 用户ID       userId      字符串	是
 文件         file        data	是
 文件扩展名	fileExt     字符串	是	"如果type为0时，不给于扩展名，可能存在的扩展名类型有 .doc .docx .xls .xlsx .ppt .pptx
 .rar .zip .7z  .avi .mp4 .rmvb .rm  .jpg .png .gif …"
 文件类型       type        数值	是	文件类型（0：未知文件，1：office file[office文件] , 2：rar/zip[压缩文件]，3：MP4/avi[视频文件]，4：jpg/png[图片文件]）
 
 */
- (LFHttpRequest*)efUploadFileWithFileData:(NSData*)fileData
                               contentType:(NSString*)contentType
                                      type:(XLFFileType)type
                                   success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                   failure:(XLFFailedBlock)failedBlock;

- (LFHttpRequest*)efUploadFilesWithFileDatas:(NSArray<XLFUploadFile *> *)fileDatas
                                     success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                     failure:(XLFFailedBlock)failedBlock;

/**
 
 接口编号：	M19.1.0
 接口描述：	登出
 接口校验：	需要
 登录校验：	不需要
 
 */
- (LFHttpRequest*)efLogoutWithSuccess:(XLFNoneResultSuccessedBlock)successedBlock
                              failure:(XLFFailedBlock)failedBlock;

/**
 
 接口编号：	M20.1.0
 接口描述：	获取常用图片
 接口校验：	需要
 登录校验：	需要
 
 */
- (LFHttpRequest*)efGetCommonImagesWithPage:(NSInteger)page
                                       size:(NSInteger)size
                                    success:(XLFOnlyArrayResponseSuccessedBlock)successedBlock
                                    failure:(XLFFailedBlock)failedBlock;

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
                            failure:(XLFFailedBlock)failedBlock;

- (LFHttpRequest *)fileRequestWithUrl:(NSString*)fileUrl
                    hiddenLoadingView:(BOOL)hiddenLoadingView
                              success:(XLFSuccessedBlock)successedBlock
                              failure:(XLFFailedBlock)failedBlock;
@end

@interface NSObject (HttpRequestManager)<LFHttpRequestManagerProtocol>

@end