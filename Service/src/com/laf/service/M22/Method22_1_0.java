package com.laf.service.M22;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.methods.InputStreamRequestEntity;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.springframework.stereotype.Service;

import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.util.MD5Util;

/**
 * 
 * 上传图片套装，三个规格 portrait ， landscape ， square
 * 
 * */
@Service
public class Method22_1_0 extends BaseMethod {

	private String remoteServerUrl = ResourceBundle.getBundle("application").getString("remote.bindImageUploadUrl");
	private String remotePrivateKey = ResourceBundle.getBundle("application").getString("remote.privateKey");

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return uploadBindImageServer(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {
		return true;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method22_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	private JSONArray uploadBindImageServer(Login login, JSONObject params) {

		System.out.println("用户ID:" + login.getId() + " 开始上传文件");
		
		HttpServletRequest request = getRequest();
		MultiThreadedHttpConnectionManager connectionManager = new MultiThreadedHttpConnectionManager();
		HttpClient httpClient = new HttpClient(connectionManager);
		// 设置编码
		httpClient.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET, "UTF-8");
		httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(50000);// 设置连接时间
		
		System.out.println("准备连接远程文件服务器：" + remoteServerUrl);
		PostMethod postMethod = new PostMethod(remoteServerUrl);
		// 设置成默认的恢复策略，在发生异常时候将自动重试3次
		postMethod.getParams().setParameter(HttpMethodParams.RETRY_HANDLER, new DefaultHttpMethodRetryHandler());

		Enumeration<String> headerNames = request.getHeaderNames();

		while (headerNames.hasMoreElements()) {
			String headerName = (String) headerNames.nextElement();
			String headerValue = request.getHeader(headerName);
			postMethod.addRequestHeader(headerName, headerValue);
		}
		postMethod.setRequestHeader("uvk", MD5Util.getMD5Str("&pk=" + remotePrivateKey, "utf-8"));
		try {
			postMethod.setRequestEntity(new InputStreamRequestEntity(request.getInputStream()));

			int statusCode = httpClient.executeMethod(postMethod);
			if (statusCode == HttpStatus.SC_OK) {
				String response = postMethod.getResponseBodyAsString();
				JSONObject result = JSONObject.fromObject(response);
				if (result.get("code").equals("200")) {
					if (result.get("data") != null) {
						return result.getJSONArray("data");
					} else {
						return new JSONArray();
					}
				} else {
					throw new SystemException(ResponseCodes.FileUploadFailed, new Throwable(response));
				}
			} else {
				throw new SystemException(ResponseCodes.FailInvokeRemote, null);
			}
		} catch (IOException e) {
			throw new SystemException(ResponseCodes.FailCommunication, e);
		}
	}
}
