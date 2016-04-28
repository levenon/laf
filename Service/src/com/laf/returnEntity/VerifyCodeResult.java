package com.laf.returnEntity;

public class VerifyCodeResult {
	
	/**
	 * 验证码
	 */
	private String code;
	/**
	 * 密钥
	 */
	private String secret;
	
	public VerifyCodeResult() {
		
	}

	public VerifyCodeResult(String code, String secret) {
		this.code = code;
		this.secret = secret;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getSecret() {
		return secret;
	}

	public void setSecret(String secret) {
		this.secret = secret;
	}

}
