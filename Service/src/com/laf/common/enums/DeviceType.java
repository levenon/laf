package com.laf.common.enums;

public enum DeviceType {

	Unknown(0), IOS(1), Android(2), WindowsPhone(3);

	private int value = 0;

	private DeviceType(int value) {
		this.value = value;
	}

	public static DeviceType valueOf(int value) {
		switch (value) {
		case 0:
			return Unknown;
		case 1:
			return IOS;
		case 2:
			return Android;
		case 3:
			return WindowsPhone;
		default:
			return Unknown;
		}
	}

	public int value() {
		return this.value;
	}
}
