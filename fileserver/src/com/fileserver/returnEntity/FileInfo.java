package com.fileserver.returnEntity;

public class FileInfo {

	/**
	 * 文件ID
	 */
	private String fileId;
	/**
	 * 文件大小
	 */
	private Integer size;
	/**
	 * 扩展名
	 */
	private String ext;
	
	public FileInfo() {}
	
	public FileInfo(String fileId, Integer size, String ext) {
		this.fileId = fileId;
		this.size = size;
		this.ext = ext;
	}

	public String getFileId() {
		return fileId;
	}

	public void setFileId(String fileId) {
		this.fileId = fileId;
	}

	public Integer getSize() {
		return size;
	}

	public void setSize(Integer size) {
		this.size = size;
	}

	public String getExt() {
		return ext;
	}

	public void setExt(String ext) {
		this.ext = ext;
	}
	
}
