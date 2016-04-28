package com.laf.common.utils;

/**
 * 时间帮助类
 * @author tangbiao
 *
 */
public class TimeHelper {

	/**
	 * 将秒转化成    时:分:秒
	 * @param longTime
	 * @return
	 */
	public static String getTime(int longTime) {
		StringBuffer sb = new StringBuffer("");
		int hour = longTime / 3600; 
		int temp = longTime % 3600;
		int min = temp / 60;
		temp = temp % 60;
		int sec = temp;
		
		if (hour < 10) {
			sb.append("0" + hour + ":");
		} else {
			sb.append(hour + ":");
		}
		
		if (min < 10) {
			sb.append("0" + min + ":");
		} else {
			sb.append(min + ":");
		}
		
		if (sec < 10) {
			sb.append("0" + sec);
		} else {
			sb.append(sec);
		}
		
		return sb.toString();
	}
	
}
