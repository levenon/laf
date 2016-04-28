package com.laf.common.exception;

/**
 * 业务异常，集成异常基类，需要捕获
 * @author tangbiao
 *
 */
public class BusinessException extends BaseException {
	private static final long serialVersionUID = 1L;

	public BusinessException(String errorCode, String... args) {
		super(errorCode, args);
	}

	public BusinessException(String errorCode, Throwable t) {
		super(errorCode, t);
	}
}
