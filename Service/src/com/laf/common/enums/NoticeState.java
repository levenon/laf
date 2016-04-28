package com.laf.common.enums;

public enum NoticeState {

	// 新发布
	New(0),
	// 关闭
	Close(1),
	// 完成
	Done(2);

	private int value = 0;

	private NoticeState(int value) {
		this.value = value;
	}

	public static NoticeState valueOf(int value) {
		switch (value) {
		case 0:
			return New;
		case 1:
			return Close;
		case 2:
			return Done;
		default:
			return New;
		}
	}

	public int value() {
		return this.value;
	}
}
