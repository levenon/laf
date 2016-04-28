//
//  LFHttpRequestManager.h
//  LostAndFound
//
//  Created by Marike Jave on 14-9-23.
//  Copyright (c) 2014年 Marike_Jave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XLFBaseHttpRequestKit/XLFBaseHttpRequestKit.h>

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
 表单参数3：	Key	u
 Value	uuid
 类型     字符串
 描述     s端颁发给c端的登录凭证，部分请求须携带此参数，方便服务端做权限校验
 表单参数4：	Key	s
 Value      md5，16进制编码
 类型     字符串
 
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
 接口校验    对“表单参数4”s中的value进行校验
 ----------------------------------------------------------------------------------
 错误代码
 代码编号    描述
 901        访问无效
 902        参数缺失或者不完整
 
 ----------------------------------------------------------------------------------
 
 登录校验    id    对“表单参数3”u中的value进行校验，校验登录许可
 ----------------------------------------------------------------------------------
 错误代码
 代码编号	   描述
 903	   无权访问
 904	   登录已过期
 
 ----------------------------------------------------------------------------------
 
 */

@interface LFHttpRequest : XLFBaseHttpRequest

@end

@interface LFHttpRequestManager : XLFHttpRequestManager

/**
 *  业务参数 转换成 表单参数
 *
 *  @param params 业务参数
 *
 *  @return form 表单餐宿
 */

+ (XLFHttpParameter*)formParamsWithMethodId:(NSString*)methodId
                                    version:(NSString *)version
                                     params:(NSDictionary*)params;


+ (XLFHttpParameter*)headerParamsWithMethodId:(NSString *)methodId
                                      version:(NSString *)version
                                       params:(NSDictionary*)params;

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
                            format:(NSString*)format;


@end

extern NSString *egfFileUrl(NSString* fileServer, NSString* fileId);

extern NSString *egfImageUrl(NSString* imageId, NSString* scale, NSString* anchor, NSString* crop, NSInteger quality, NSInteger rotate, NSString* format);

extern NSString *egfImageUrlDefault(NSString* imageId);

