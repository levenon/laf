package com.laf.common.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * 
 * @author tangbiao
 *
 */
public class StreamIOHelper {
	/**
	 * 输入流转化为字符串
	 * @param is
	 * @return
	 * @throws IOException
	 */
	public static String inputStreamToStr(InputStream is, String charset) throws IOException {
		BufferedReader in = new BufferedReader(new InputStreamReader(is, "ISO-8859-1"));
		StringBuffer buffer = new StringBuffer();
		String line = "";
		while ((line = in.readLine()) != null) {
			buffer.append(line);
		}
		return new String(buffer.toString().getBytes("ISO-8859-1"), charset);
	}
}
