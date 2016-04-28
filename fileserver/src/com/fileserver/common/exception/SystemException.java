package com.fileserver.common.exception;

import org.apache.commons.lang3.StringUtils;

import com.fileserver.common.enums.ErrorCodeType;
import com.fileserver.common.enums.ResponseCodes;
 
/**
 * 自定义系统异常，集成RuntimeException，可以不捕获，
 * @author tangbiao
 *
 */
public class SystemException  extends RuntimeException {

	private static final long serialVersionUID = 2116725965190104270L;
	
	private String errorCode;
	private String errorMsg;
	private ErrorCodeType errorCodeType;
	private String[] args;
	private Throwable throwable;

//	public SystemException(String errorCode, String... args) {
//		super(errorCode);
//		this.errorCode = errorCode;
//		this.errorMsg = args[0];
//		this.args = args;
//	}

//	public SystemException(ResponseCodes codes) {
//		super(codes.getCode());
//		this.errorCode = codes.getCode();
//		this.errorMsg = codes.getMessage();
//		this.args = null;
//	}

	public SystemException(ResponseCodes codes, Throwable throwable) {
		super(throwable);
		this.errorCode = codes.getCode();
		this.errorMsg = codes.getMessage();
		this.args = null;
		this.throwable = throwable;
	}

//	public SystemException(String errorCode, Throwable throwable) {
//		super(throwable);
//		this.setThrowable(throwable);
//		this.errorCode = errorCode;
//	}

//	public String getExceptionStackMsg() {
//		if (this.t != null) {
//			return this.t.getStackTrace().toString();
//		}
//		if (this.exceptionStackMsg != null) {
//			return this.exceptionStackMsg;
//		}
//		return null;
//	}

	public boolean isSystemException() {
		return (StringUtils.isNotBlank(this.errorCode)) && (this.errorCode.startsWith("S"));
	}

	public boolean isBusinessException() {
		return (StringUtils.isNotBlank(this.errorCode)) && (this.errorCode.startsWith("B"));
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

	public Throwable getThrowable() {
		if (throwable == null) {
			throwable = new Throwable();
		}
		return throwable;
	}

	public void setThrowable(Throwable throwable) {
		this.throwable = throwable;
	}
}
