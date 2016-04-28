package com.fileserver.common.utils;


/**
 * 参数解析帮助类
 * @author tangbiao
 *
 */
public class ParamParseHelper {
	
	/**
	 * 图片参数解析，获取相应的参数数组
	 * @param urlParam 参数
	 * @param match  匹配参数
	 * @return
	 */
	public static String[] getParams(String urlParam, String match){
		int index = urlParam.indexOf(match);
		String[] params = urlParam.substring(
				index + match.length()).split(",");
		return params;
	} 
}
