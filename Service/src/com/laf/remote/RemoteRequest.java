package com.laf.remote;

import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethodBase;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;

import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.InputStreamUtil;

public class RemoteRequest {
	// httpclient读取内容时使用的字符集
	private static final String CONTENT_CHARSET = "UTF-8";
	
	/**
	 * 远程提交文件服务
	 * 
	 * @param url
	 *            远程服务
	 * @param nameValuePairs
	 *            参数
	 * @return
	 * @throws IOException
	 */
	@SuppressWarnings("deprecation")
	public static String remoteSaveOrUpdate(String url, NameValuePair[] nameValuePairs, byte[] data)
			throws IOException {

		NameValuePair[] pairs = new NameValuePair[nameValuePairs.length];
		System.arraycopy(nameValuePairs, 0, pairs, 0, nameValuePairs.length);

		InputStream inputStream = null;
		try {
			inputStream = InputStreamUtil.byteTOInputStream(data);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		PostMethod method = new PostMethod(url);
		method.setQueryString(pairs);
		method.setRequestBody(inputStream);
		String model = executeMethod(null, method);

		return model;
	}

	/**
	 * 远程删除文件服务
	 * 
	 * @param url
	 *            远程服务
	 * @param nameValuePairs
	 *            参数
	 * @return boolean
	 */
	public static boolean remoteDelete(String url,
			NameValuePair[] nameValuePairs) {

		NameValuePair[] pairs = new NameValuePair[nameValuePairs.length];
		System.arraycopy(nameValuePairs, 0, pairs, 0, nameValuePairs.length);

		PostMethod method = new PostMethod(url);
		method.setQueryString(pairs);
		if (executeMethod(null, method) != null)
			return true;
		return false;
	}

	/**
	 * 远程服务查询方法，返回流对象 用于文件传输系统
	 * 
	 * @param client
	 *            httpclient
	 * @param url
	 *            远程服务的url
	 * @param nameValuePairs
	 *            参数
	 * @return InputStream
	 */
	public static String remoteQuery(String url,
			NameValuePair[] nameValuePairs, byte[] data) {

		NameValuePair[] pairs = new NameValuePair[nameValuePairs.length];
		System.arraycopy(nameValuePairs, 0, pairs, 0, nameValuePairs.length);

		PostMethod method = new PostMethod(url);
		method.setQueryString(pairs);
		return executeMethod(null, method);
	}

	/**
	 * 执行method
	 * 
	 * @param client
	 *            httpclient
	 * @param method
	 *            url请求method
	 * @return 流对象
	 */
	private static String executeMethod(HttpClient client,
			HttpMethodBase method) {

		MultiThreadedHttpConnectionManager connectionManager = new MultiThreadedHttpConnectionManager();
		HttpClient httpClient;
		if (client == null) {
			httpClient = new HttpClient(connectionManager);
		} else {
			httpClient = client;
		}
		try {
			// 设置编码
			httpClient.getParams().setParameter(
					HttpMethodParams.HTTP_CONTENT_CHARSET, CONTENT_CHARSET);
			// 设置成默认的恢复策略，在发生异常时候将自动重试3次
			method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
					new DefaultHttpMethodRetryHandler());
			int statusCode = httpClient.executeMethod(method);
			if (statusCode == HttpStatus.SC_OK) {
				return method.getResponseBodyAsString();
			}
			else {
				throw new SystemException(ResponseCodes.FailInvokeRemote, null);
			}
		} catch (IOException e) {
			throw new SystemException(ResponseCodes.FailCommunication, e);
		}
	}
}
