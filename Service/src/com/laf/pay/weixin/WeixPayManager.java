package com.laf.pay.weixin;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.DefaultHttpRequestRetryHandler;
import org.apache.http.impl.conn.PoolingClientConnectionManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.CoreConnectionPNames;
import org.apache.http.params.HttpParams;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.laf.common.AbstractBusinessObject;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.JsonMapper;
import com.laf.common.utils.StreamIOHelper;
import com.laf.pay.weixin.util.Sha1Util;
import com.laf.pay.weixin.util.WeixPayHelper;

/**
 * 微信支付
 *
 * @author Chengfei.Sun
 */
@Component
public class WeixPayManager extends AbstractBusinessObject {
    /**
     * 设置连接超时时间
     */
    @Value("${httpclient.connection.timeout}")
    private int connectionTimeout = 30000;

    /**
     * 设置读取超时时间
     */
    @Value("${httpclient.connection.sotimeout}")
    private int SoTimeout = 120000;

    /**
     * 设置最大连接数
     */
    @Value("${httpclient.connection.maxconnection}")
    private int maxConnection = 200;

    /**
     * 设置每个路由最大连接数
     */
    @Value("${httpclient.connection.maxrouteconnection}")
    private int maxRouteConneciton = 50;

    /**
     * 设置接收缓冲
     */
    @Value("${httpclient.connection.socketbuffersize}")
    private int sockeBufferSize = 8192;

    /**
     * 设置失败重试次数
     */
    @Value("${httpclient.connection.maxretry}")
    private int maxRetry = 5;

    /**
     * 下载多线程管理器
     */
    private static PoolingClientConnectionManager connMger;

    /**
     * 下载参数
     */
    private static HttpParams connParams;

    private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

    @SuppressWarnings("unused")
	@PostConstruct
    private void afterInitialization() {
        // 初始化下载线程池
        SchemeRegistry schemeRegistry = new SchemeRegistry();
        schemeRegistry.register(new Scheme("http", 80, PlainSocketFactory
                .getSocketFactory()));
        schemeRegistry.register(new Scheme("https", 443, SSLSocketFactory
                .getSocketFactory()));

        connMger = new PoolingClientConnectionManager(schemeRegistry);
        connMger.setDefaultMaxPerRoute(maxRouteConneciton);
        connMger.setMaxTotal(maxConnection);

        // 初始化下载参数
        connParams = new BasicHttpParams();
        connParams.setParameter(CoreConnectionPNames.CONNECTION_TIMEOUT,
                connectionTimeout);
        connParams.setParameter(CoreConnectionPNames.SO_TIMEOUT, SoTimeout);
        connParams.setParameter(CoreConnectionPNames.SOCKET_BUFFER_SIZE,
                sockeBufferSize);
    }

    public HttpClient getHttpClient() {
        DefaultHttpClient client = new DefaultHttpClient(connMger, connParams);
        client.setHttpRequestRetryHandler(new DefaultHttpRequestRetryHandler(
                maxRetry, false));
        return client;
    }

    /**
     * 获取AccessToken
     *
     * @return
     */
    public WeixPayResponse getAccessToken() {
        String requestUrl = WeixPayConfig.TOKENURL + "?grant_type=" + WeixPayConfig.GRANT_TYPE + "&appid="
                + WeixPayConfig.APP_ID + "&secret=" + WeixPayConfig.APP_SECRET;
        try {
            HttpClient httpClient = getHttpClient();
            HttpGet getMethod = new HttpGet(requestUrl);
            HttpResponse response = httpClient.execute(getMethod);
            String responseStr = StreamIOHelper.inputStreamToStr(response.getEntity().getContent(), "UTF-8");
            logger.info("获取微信支付AccessToken返回:{}", responseStr);
            if (StringUtils.isNotEmpty(responseStr)) {
                WeixPayResponse payResponse = jsonMapper.fromJson(responseStr, WeixPayResponse.class);
                return payResponse;
            }
        } catch (Exception e) {
            logger.error("微信支付获取accessToken发生异常:{}", ExceptionUtils.getStackTrace(e));
            return null;
        }
        return null;
    }

    public WeixPayResponse geneOrder(String access_token, String traceid, String orderId, BigDecimal price) {
        try {
            HttpClient httpClient = getHttpClient();
            HttpPost httpRequest = new HttpPost(WeixPayConfig.GATEURL + access_token);

            Map<String, String> params = new HashMap<String, String>();
            params.put("appid", WeixPayConfig.APP_ID);
            //params.put("appkey", WeixPayConfig.APP_KEY);
            String nonceStr = WeixPayHelper.getNonceStr();
            params.put("noncestr", nonceStr);
            params.put("package", WeixPayHelper.packageValue(orderId, price));
            String timestamp = WeixPayHelper.getTimeStamp();
            params.put("timestamp", timestamp);
            params.put("traceid", traceid);
            String sign = Sha1Util.createSHA1Sign(params);
            params.put("app_signature", sign);
            params.put("sign_method", WeixPayConfig.SIGN_METHOD);

            String json = jsonMapper.toJson(params);
            // 请求
            httpRequest.setEntity(new StringEntity(json));
            HttpResponse response = httpClient.execute(httpRequest);
            String responseStr = StreamIOHelper.inputStreamToStr(response.getEntity().getContent(), "UTF-8");
            logger.info("订单:{}，微信预支付返回:{}", new Object[]{orderId, responseStr});
            if (StringUtils.isNotEmpty(responseStr)) {
                WeixPayResponse payResponse = jsonMapper.fromJson(responseStr, WeixPayResponse.class);
                payResponse.setNonceStr(nonceStr);
                payResponse.setTimestamp(timestamp);
                payResponse.setSign(sign);
                return payResponse;
            }
        } catch (Exception e) {
            logger.error("订单:{}生成微信预支付订单发生异常:{}", new Object[]{orderId, ExceptionUtils.getStackTrace(e)});
            return null;
        }
        return null;
    }

	public WeixPayResponse payment(String traceid, String orderId, BigDecimal price) {
		WeixPayResponse accessTokenresp = this.getAccessToken();
        if(accessTokenresp == null || StringUtils.isNotEmpty(accessTokenresp.getErrcode())){
            throw new SystemException(ResponseCodes.WeixTokenErroe, null);
        }
        WeixPayResponse preIdResp = this.geneOrder(accessTokenresp.getAccessToken(), traceid, orderId, price);
        if(preIdResp == null || !preIdResp.getErrcode().equals("0")){
            throw new SystemException(ResponseCodes.WeixPreIDErroe, null);
        }
        // 生成客户端所需sign
        Map<String, String> params = new HashMap<String, String>();
        params.put("appid", WeixPayConfig.APP_ID);
        params.put("appkey", WeixPayConfig.APP_KEY);
        String nonceStr = WeixPayHelper.getNonceStr();
        params.put("noncestr", nonceStr);
        params.put("package", "Sign=WXPay");
        params.put("partnerid", WeixPayConfig.PARTNER);
        params.put("prepayid", preIdResp.getPrepayid());
        String timestamp = WeixPayHelper.getTimeStamp();
        params.put("timestamp", timestamp);
        String sign = Sha1Util.createSHA1Sign(params);

        preIdResp.setNonceStr(nonceStr);
        preIdResp.setTimestamp(timestamp);
        preIdResp.setSign(sign);
        return preIdResp;
	}

}
