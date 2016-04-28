package com.laf.util.mail;

import java.util.Properties;

public class SendMail {
	// 发送邮件的服务器的IP和端口
	private String fromAddress;
	private String toAddress;
	private String userName;
	private String password;
	private boolean validate = true;
	private String subject;
	private String content;
	private String[] attachFileNames;

	/**
	 * 获得邮件会话属性
	 */
	// 需要getProperties设置参数，传递不同邮箱的种类。保证能够向不同的邮箱发送邮件。
	public Properties getProperties() {
		Properties p = new Properties();
		p.put("mail.smtp.host", "smtp.qq.com");
		p.put("mail.smtp.port", "25");
		p.put("mail.smtp.auth", validate ? "true" : "false");

		return p;
	}

	public String getFromAddress() {
		return fromAddress;
	}

	public void setFromAddress(String fromAddress) {
		this.fromAddress = fromAddress;
	}

	public String getToAddress() {
		return toAddress;
	}

	public void setToAddress(String toAddress) {
		this.toAddress = toAddress;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isValidate() {
		return validate;
	}

	public void setValidate(boolean validate) {
		this.validate = validate;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String[] getAttachFileNames() {
		return attachFileNames;
	}

	public void setAttachFileNames(String[] attachFileNames) {
		this.attachFileNames = attachFileNames;
	}

}
