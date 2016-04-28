package com.laf.common.enums;

public enum NoticeType {

	// 未知
	UnknownError(0),
	// 寻物启事
	Lost(1 << 0),
	// 失物招领
	Found(1 << 1),
	// 全部
	All(Lost.value() | Found.value());

	private int value = 1;

	private NoticeType(int value) {
		this.value = value;
	}

	public static NoticeType valueOf(int value) {
		switch (value) {
		case 1 << 0:
			return Lost;
		case 1 << 1:
			return Found;
		case 1 << 0 | 1 << 1:
			return All;
		default:
			return UnknownError;
		}
	}

	public int value() {
		return this.value;
	}
}
