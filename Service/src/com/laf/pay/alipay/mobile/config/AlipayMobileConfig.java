package com.laf.pay.alipay.mobile.config;

/**
 * 
 * @author tangbiao
 *
 */
public class AlipayMobileConfig {
    // 合作身份者ID，以2088开头由16位纯数字组成的字符串
    public static String partner = "";
    
    //请求url
    public static String url = "";
    
    //service
    public static String service = "mobile.securitypay.pay";
    
    //payment_type支付类型
    public static String payment_type = "1";
    
    //商户ID
    public static String seller_id = "";
    
    //未付款交易的超时时间
    public static String it_b_pay = "30m";

    // 商户的私钥
    public static String private_key = "";

    // 支付宝的公钥，无需修改该值
    public static String ali_public_key  = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";

    // 调试用，创建TXT日志文件夹路径
    public static String log_path = "";

    // 字符编码格式 目前支持 gbk 或 utf-8
    public static String input_charset = "utf-8";

    // 签名方式 不需修改
    public static String sign_type = "RSA";

    public static String getPartner() {
        return partner;
    }

    public static void setPartner(String partner) {
        AlipayMobileConfig.partner = partner;
    }

    public static String getPrivate_key() {
        return private_key;
    }

    public static void setPrivate_key(String private_key) {
        AlipayMobileConfig.private_key = private_key;
    }

    public static String getAli_public_key() {
        return ali_public_key;
    }

    public static void setAli_public_key(String ali_public_key) {
        AlipayMobileConfig.ali_public_key = ali_public_key;
    }

    public static String getLog_path() {
        return log_path;
    }

    public static void setLog_path(String log_path) {
        AlipayMobileConfig.log_path = log_path;
    }

    public static String getInput_charset() {
        return input_charset;
    }

    public static void setInput_charset(String input_charset) {
        AlipayMobileConfig.input_charset = input_charset;
    }

    public static String getSign_type() {
        return sign_type;
    }

    public static void setSign_type(String sign_type) {
        AlipayMobileConfig.sign_type = sign_type;
    }
}

