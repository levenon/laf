package com.laf.middleResult;

import com.laf.entity.VerifyCode;

public class VerifyStatus {

	private boolean status = false;
	private VerifyCode verifyCode;
	
	public boolean getStatus() {
		return status;
	}
	public void setStatus(boolean status) {
		this.status = status;
	}
	public VerifyCode getVerifyCode() {
		return verifyCode;
	}
	public void setVerifyCode(VerifyCode verifyCode) {
		this.verifyCode = verifyCode;
	}
}
