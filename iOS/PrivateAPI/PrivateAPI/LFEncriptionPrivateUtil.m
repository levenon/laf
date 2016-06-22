//
//  LFEncriptionPrivateUtil.m
//  PrivateAPI
//
//  Created by Marke Jave on 16/3/24.
//  Copyright © 2016年 Marike Jave. All rights reserved.
//

#import "LFEncriptionPrivateUtil.h"

#import "LFConstantsPrivate.h"

#import "XLFCommonKit.h"

@implementation LFEncriptionPrivateUtil

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
	Value	 uuid
	类型      字符串
	描述      "s端颁发给c端的登录凭证，
 部分请求须携带此参数，
 方便服务端做权限校验"
 
 表单参数4：	 Key	s
	Value	 md5，16进制编码
	类型      字符串
	描述      对m=…&uuid=…&p=…使用md5签名
 
 */

+ (NSString *)encriptionWithMethod:(NSString *)method session:(NSString *)session parameters:(NSString *)parameters{
    
    NSString *encryptionOriginAppInfo = [[NSString stringWithFormat:@"id=%@&name=%@&version=%@", egAllowAppBundleIdentifier, egAllowAppDisplayName, egAllowAppVersion] encodeMD5];
    
    NSString *encryptionAppInfo = [[NSString stringWithFormat:@"id=%@&name=%@&version=%@", [NSBundle bundleIdentifier], [NSBundle bundleDisplayName], [NSBundle appVersion]] encodeMD5];
    
    if ([encryptionAppInfo isEqualToString:encryptionOriginAppInfo]) {
        
        NSString *original = [NSString stringWithFormat:@"m=%@&sid=%@&p=%@&pk=%@", method, session, parameters, egServicePrivateKey];
        
        NSString *encryption = [original encodeMD5];
        
        NIF_DEBUG(@"md5 origin:%@ \nsecret:%@", original, encryption);
        
        return encryption;
    }
    return @"FORBIDDEN";
}

@end
