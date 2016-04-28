package com.laf.pay.weixin.util;

import java.math.BigDecimal;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;

import com.laf.pay.weixin.WeixPayConfig;

/**
 * 微信支付帮助类
 * @author tangbiao
 *
 */
public class WeixPayHelper {
    public static String getNonceStr() {
        Random random = new Random();
        return MD5Util.MD5Encode(String.valueOf(random.nextInt(10000)), "UTF-8");
    }

    public static String getTimeStamp() {
        return String.valueOf(System.currentTimeMillis() / 1000);
    }

    public static String packageValue(String orderId, BigDecimal totalPrice) {
        List<NameValuePair> params = new LinkedList<NameValuePair>();
        //params.add(new BasicNameValuePair("bank_type", "WX"));
        params.add(new BasicNameValuePair("mch_id", WeixPayConfig.mCH_ID));
        params.add(new BasicNameValuePair("nonce_str", getNonceStr()));
        params.add(new BasicNameValuePair("body", "微训支付"));
        params.add(new BasicNameValuePair("fee_type", "1"));
        params.add(new BasicNameValuePair("input_charset", "UTF-8"));
        params.add(new BasicNameValuePair("notify_url", WeixPayConfig.NOTIFY_URL));
        params.add(new BasicNameValuePair("out_trade_no", orderId));
        params.add(new BasicNameValuePair("partner", WeixPayConfig.PARTNER));
        params.add(new BasicNameValuePair("spbill_create_ip", WeixPayConfig.BILL_CREATE_IP));
        params.add(new BasicNameValuePair("trade_type", WeixPayConfig.TRADE_TYPE));
        // 微信支付单位为分
        params.add(new BasicNameValuePair("total_fee", totalPrice.multiply(new BigDecimal(100)).setScale(0, BigDecimal.ROUND_HALF_UP).toString()));

        // 生成 package
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < params.size(); i++) {
            sb.append(params.get(i).getName());
            sb.append('=');
            sb.append(params.get(i).getValue());
            sb.append('&');
        }
        sb.append("key=");
        sb.append(WeixPayConfig.PARTNER_KEY);
        String packageSign = MD5Util.MD5Encode(sb.toString(), "UTF-8").toUpperCase();
        return URLEncodedUtils.format(params, "utf-8") + "&sign=" + packageSign;
    }

    public static boolean isTenpaySign(Map<String, Object> params) {
        Iterator<Map.Entry<String, Object>> iterator = params.entrySet().iterator();
        Set<String> sortSet = new TreeSet<String>();
        while (iterator.hasNext()) {
            Map.Entry<String, Object> entity = iterator.next();
            String k = (String)entity.getKey();
            String v = (String)entity.getValue();
            if(!"sign".equals(k) && StringUtils.isNotEmpty(v) && !"".equals(v)) {
                sortSet.add(k + "=" + v);
            }
        }

        StringBuilder signStr = new StringBuilder();
        Iterator<String> setIterator = sortSet.iterator();
        while (setIterator.hasNext()) {
            String item = setIterator.next();
            signStr.append(item);
            signStr.append("&");
        }
        signStr.append("key=" + WeixPayConfig.PARTNER_KEY);

        //算出摘要
        String sign = MD5Util.MD5Encode(signStr.toString(), "UTF-8").toLowerCase();

        String tenpaySign = ((String)params.get("sign")).toLowerCase();
        return tenpaySign.equals(sign);
    }
}
