package com.laf.common.enums;

/**
 * 平台类型
 */
public enum PlatformType {

	Normal(0), Telephone(1), Email(2), Sina(3), Tencent(4), Wechat(5), Ali(6), RenRen(7);

	private int value = 0;	

	private PlatformType(int value) {
		this.value = value;
	}

	public static PlatformType valueOf(int value) {
		switch (value) {
		case 0:
			return Normal;
		case 1:
			return Telephone;
		case 2:
			return Email;
		case 3:
			return Sina;
		case 4:
			return Tencent;
		case 5:
			return Wechat;
		case 6:
			return Ali;
		case 7:
			return RenRen;
		default:
			return Normal;
		}
	}

	public int value() {
		return this.value;
	}
}