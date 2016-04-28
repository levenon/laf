package com.laf.pay.alipay;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.laf.common.AbstractBusinessObject;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.pay.alipay.mobile.config.AlipayMobileConfig;
import com.laf.pay.alipay.mobile.util.AlipayCore;
import com.laf.pay.alipay.sign.RSA;

/**
 * 支付宝支付管理
 * @author tangbiao
 *
 */
@Component
public class AlipayManager extends AbstractBusinessObject{
	
//    public String purchase(String orderId, BigDecimal orderPrice) {
//        return null;
//    }
//
//    public String purchase(Map<String, Object> requestMap) {
//        return null;
//    }
//
//    public String genePagePayUrl(String orderId, BigDecimal orderPrice) {
//        return null;
//    }
//
//    public String sendValidCode(Map<String, Object> requestMap) {
//        return null;
//    }
	
	//检查商户AlipayMobileConfig.java文件的配置参数
	private boolean checkInfo() {
        String partner = AlipayMobileConfig.partner;
        //如果合作商户ID为空返回false
        if (StringUtils.isBlank(partner))
            return false;
        
        return true;
    }
	
	public String getParams(String orderId, BigDecimal price) {
		
		if (!checkInfo()) {
			throw new SystemException(ResponseCodes.ErrorAliPayParams, null);
		}
//		params.put("sign", );
//		params.put("sign_type", AlipayMobileConfig.sign_type);
//		for (int i = 0; i < list.size(); i++) {
//			params[i] = list.get(i);
//		}
//		//不知道行不行
//		httpRequest.setParameters((org.apache.commons.httpclient.NameValuePair[]) params);
		
		return null;
	}
	
	public static JSONObject getRequestData(String orderId, BigDecimal price) {
		Map<String, String> params = new HashMap<String, String>();
		params.put("partner", AlipayMobileConfig.partner);
		params.put("out_trade_no", orderId);
		params.put("subject", "微训");
		//params.put("body", "微训");
		params.put("total_fee", price.toString());
		params.put("notify_url", AlipayMobileConfig.url);
		params.put("service", AlipayMobileConfig.service);
		params.put("input_charset", AlipayMobileConfig.input_charset);
		params.put("payment_type", AlipayMobileConfig.payment_type);
		params.put("seller_id", AlipayMobileConfig.seller_id);
		//去掉空值和签名参数
		Map<String, String> map = AlipayCore.paraFilter(params);
		//生成签名结果
		String sign = buildSign(map);
		params.put("sign", sign);
		params.put("sign_type", AlipayMobileConfig.sign_type);
		
		return JSONObject.fromObject(params);
	}
	
	public static String buildSign(Map<String, String> map) {
		String content = AlipayCore.createLinkString(map); 
		String sign = RSA.sign(content, AlipayMobileConfig.private_key, AlipayMobileConfig.input_charset);
		return sign;
	}
}

