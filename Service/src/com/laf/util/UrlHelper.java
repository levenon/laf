package com.laf.util;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.laf.common.constants.ParamConstans;

/**
 * url帮助类
 * @author tangbiao
 *
 */
public class UrlHelper {
	
	/**
	 * 解析url
	 * @param uri
	 * @return
	 */
	public static Map<String, Object> getParams(String uri) {
		
		String paramStr = null;
		String[] paramArr = null;
		Map<String, Object> map = new HashMap<String, Object>();
		int index = uri.indexOf("/");
		if (index != -1) {
			paramStr = uri.substring(index);
			paramStr = Base64Util.getFromBase64(paramStr);
			if (StringUtils.isNotBlank(paramStr)) {
				paramArr = paramStr.split("&");
			}
			if (paramArr != null && paramArr.length == 3) {
				map.put(ParamConstans.FIRST, paramArr[0]);
				map.put(ParamConstans.SECOND, paramArr[1]);
				map.put(ParamConstans.THIRD, paramArr[2]);
			}
		}
		return map;
	}	
}
