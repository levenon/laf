package com.fileserver.common.enums;

public enum FileType {
	
	Normal(0, "normal", "普通文件"),

	Image(1, "image", "图片");
	
	private int code;
	
	private String dir;
	
	private String name;
	
	private FileType(int code, String dir, String name) {
		this.code = code;
		this.name = name;
		this.dir = dir;
	}
	
	public String getDir() {
		return this.dir;
	}
	
	public int getCode() {
		return this.code;
	}
	
	public String getName() {
		return this.name;
	}
	
	public static FileType getTypeByCode(int code){
		for(FileType type : FileType.values()){
			if(type.getCode() == code) {
				return type;
			}
		}
		throw new IllegalArgumentException("未能找到匹配的FileType:" + code);
	}
	
}
