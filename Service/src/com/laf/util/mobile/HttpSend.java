package com.laf.util.mobile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.regex.Pattern;

import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;

public class HttpSend {

	private String username;
	private String password;
	private String phoneNumber;
	private String content;
	private String urlString;

	public HttpSend(String username, String password, String phoneNumber,
			String content) {
		this.username = username;
		this.password = password;
		this.phoneNumber = phoneNumber;
		this.content = content;
	}

	public void send() throws Exception {
		// 生成一个URL对象
		Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");

		if (p.matcher(phoneNumber).matches()) {
			urlString = "http://www.smsbao.com/sms?u=" + username + "&p="
					+ password + "&m=" + phoneNumber + "&c=" + content;
		} else {
			throw new SystemException(ResponseCodes.ErrorTelePhoneNumber, null);
		}
		URL url = new URL(urlString);
		// 打开URL
		HttpURLConnection urlConnection = (HttpURLConnection)url.openConnection();
		// 得到输入流，即获得返回值
		BufferedReader reader = new BufferedReader(new InputStreamReader(
				urlConnection.getInputStream()));
		String line;
		// 读取返回值，进行判断
		while ((line = reader.readLine()) != null) {
			int result = Integer.valueOf(line);
			if (result != 0) {
				throw new SystemException(ResponseCodes.ErrorSendMessage, null);
			}
			System.out.println("发送成功");
		}
	}

	public static void main(String[] args) throws Exception {
		new HttpSend("weixun2015", "c6b19fd9155dfa87e6351913e72dd9de", "18964138417", "测试短信").send();
		System.out.println("===============================");
	}
}
