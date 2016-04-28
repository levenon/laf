package com.laf.common.enums;

import org.apache.commons.lang3.StringUtils;

public enum ErrorCodes {
	UnknownError("S0001", "未知错误类型");

	private String code;
	private String message;

	private ErrorCodes(String code, String message) {
		this.code = code;
		this.message = message;
	}

	public static ErrorCodes getResponseByCode(String code) {
		if (StringUtils.isEmpty(code)) {
			throw new NullPointerException("错误编码为空");
		}

		for (ErrorCodes responseCode : values()) {
			if (responseCode.getCode().equals(code)) {
				return responseCode;
			}
		}

		throw new IllegalArgumentException("未能找到匹配的ErrorCode:" + code);
	}

	public String getCode() {
		return this.code;
	}

	public String getMessage() {
		return this.message;
	}
}