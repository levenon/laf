package com.laf.pay.weixin;

/**
 * 微信支付配置
 * @author tangbiao
 *
 */
public class WeixPayConfig {
    public static String APP_ID = "wxd2bf2986c6d063bd";//微信开发平台应用id
    
    //商户号
    public static String mCH_ID = "";
    //交易类型
    public static String TRADE_TYPE = "APP";

    public static String APP_SECRET = "bac21b7b5552cffb4c1680b5eb10a488";//应用对应的凭证

    public static String APP_KEY = "aThyXefIH5lUuglpmziEVljbWPUu3UVaBklKG20Ka4Y1RFQfQNPOsb8OIh1P5KQQDxeFvN1mTNHjyuC3GVvB94L8vsaD3UxQsVSg8jLQ2N9WSCjGDEIJg1BaMEieTYVO";

    public static String PARTNER = "1227195601";//财付通商户号

    public static String PARTNER_KEY = "fdd8267fa06d056204f3841c44b0f3b6";//商户号对应的密钥

    public static String TOKENURL = "https://api.weixin.qq.com/cgi-bin/token"; //获取access_token对应的url

    public static String GRANT_TYPE = "client_credential";//常量固定值

    public static String GATEURL = "https://api.weixin.qq.com/pay/genprepay?access_token=";//获取预支付id的接口url

    public static String SIGN_METHOD = "sha1";//签名算法常量值

    public static String NOTIFY_URL;

    public static String BILL_CREATE_IP;

	public static String getNOTIFY_URL() {
		return NOTIFY_URL;
	}

	public static void setNOTIFY_URL(String nOTIFY_URL) {
		NOTIFY_URL = nOTIFY_URL;
	}

	public static String getBILL_CREATE_IP() {
		return BILL_CREATE_IP;
	}

	public static void setBILL_CREATE_IP(String bILL_CREATE_IP) {
		BILL_CREATE_IP = bILL_CREATE_IP;
	}
}
