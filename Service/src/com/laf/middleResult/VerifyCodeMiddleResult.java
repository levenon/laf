package com.laf.middleResult;

import com.laf.entity.VerifyCode;

public class VerifyCodeMiddleResult {

	private VerifyCode verifyCode;
	private String secret;

	public String getSecret() {
		return secret;
	}

	public void setSecret(String secret) {
		this.secret = secret;
	}

	public VerifyCode getVerifyCode() {
		return verifyCode;
	}

	public void setVerifyCode(VerifyCode verifyCode) {
		this.verifyCode = verifyCode;
	}
}
