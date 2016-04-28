package com.laf.common.exception;

import java.io.PrintWriter;
import java.io.StringWriter;

import org.apache.commons.lang3.StringUtils;

import com.laf.common.enums.ErrorCodeType;
/**
 * 自定义异常基类   需要捕获
 * @author tangbiao
 *
 */
public class BaseException extends Exception {
	private static final long serialVersionUID = 1L;
	private String errorCode;
	private String errorMsg;
	private ErrorCodeType errorCodeType;
	private String[] args;
	private Throwable t;
	private String exceptionStackMsg;

	public BaseException(String errorCode, String[] args) {
		super(errorCode);
		this.errorCode = errorCode;
		this.args = args;
	}

	public BaseException(String errorCode, Throwable t) {
		super(t);
		this.t = t;
		this.errorCode = errorCode;
	}

	public String getExceptionStackMsg() {
		if (this.t != null) {
			return this.t.getStackTrace().toString();
		}
		if (this.exceptionStackMsg != null) {
			return this.exceptionStackMsg;
		}
		return null;
	}

	public boolean isSystemException() {
		return (StringUtils.isNotBlank(this.errorCode))
				&& (this.errorCode.startsWith("S"));
	}

	public boolean isBusinessException() {
		return (StringUtils.isNotBlank(this.errorCode))
				&& (this.errorCode.startsWith("B"));
	}

	public String getErrorCode() {
		return this.errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMsg() {
		return this.errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	public ErrorCodeType getErrorCodeType() {
		return this.errorCodeType;
	}

	public void setErrorCodeType(ErrorCodeType errorCodeType) {
		this.errorCodeType = errorCodeType;
	}

	public String[] getArgs() {
		return this.args;
	}

	public void setArgs(String[] args) {
		this.args = args;
	}

	public Throwable getT() {
		return this.t;
	}

	public void setT(Throwable t) {
		this.t = t;
	}

	public void setExceptionStackMsg(String exceptionStackMsg) {
		this.exceptionStackMsg = exceptionStackMsg;
	}

	public static RuntimeException unchecked(Exception e) {
		if ((e instanceof RuntimeException)) {
			return (RuntimeException) e;
		}
		return new RuntimeException(e);
	}

	public static String getStackTraceAsString(Exception e) {
		StringWriter stringWriter = new StringWriter();
		e.printStackTrace(new PrintWriter(stringWriter));
		return stringWriter.toString();
	}
}
