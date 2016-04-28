package com.laf.common.enums;

public enum FileType {

	// 0：未知文件，1：office file[office文件] , 2：rar/zip[压缩文件]，3：MP4/avi[视频文件]，4：jpg/png[图片文件] 5：mp3/wav/midi/wma/amr/aac[音频文件]
	Unknown(0), Office(1), Archive(2), Video(3), Image(4), Audio(5);

	private int value = 0;

	private FileType(int value) {
		this.value = value;
	}

	public static FileType valueOf(int value) {
		switch (value) {
		case 0:
			return Unknown;
		case 1:
			return Office;
		case 2:
			return Archive;
		case 3:
			return Video;
		case 4:
			return Image;
		case 5:
			return Audio;
		default:
			return Unknown;
		}
	}

	public int value() {
		return this.value;
	}
}
