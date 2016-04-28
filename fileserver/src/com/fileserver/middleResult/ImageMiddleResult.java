package com.fileserver.middleResult;

public class ImageMiddleResult {

	private String contentType;
	private byte[] data;

	public ImageMiddleResult() {
		super();
	}

	public ImageMiddleResult(String contentType, byte[] data) {
		super();
		this.contentType = contentType;
		this.data = data;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public byte[] getData() {
		return data;
	}

	public void setData(byte[] data) {
		this.data = data;
	}
}
