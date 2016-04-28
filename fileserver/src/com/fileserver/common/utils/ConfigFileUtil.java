package com.fileserver.common.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * 读取URLMap 
 * @author tangbiao
 *
 */
public class ConfigFileUtil {
	private final static String configFileName = "/configfile.properties";

	private static Properties properties = new Properties();

	static {

		InputStream stream = null;
		try {

			stream = ConfigFileUtil.class.getResourceAsStream(configFileName);
			if (stream != null) {
				properties.load(stream);
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			if (stream != null) {
				try {
					stream.close();
				} catch (IOException e) {
					// ignore
				}
			}
		}

	}

	/**
	 * @param key
	 * @return 返回 key 值
	 */
	public static String getValue(String key) {

		return properties.getProperty(key);

	}

	/**
	 * @return 返回 properties
	 */
	public static Properties getProperties() {
		return properties;
	}

	public static void main(String[] args) {
		System.out.println(checkIP("192.168.31.1"));
	}

	/*
	 * 检测访问IP是否在允许的范围内，配置文件在ConfigFile.properties中
	 */
	public static boolean checkIP(String str) {

		String value = ConfigFileUtil.getValue("SERVICEGROUP");
		String[] split = value.split(",");
		for (int i = 0; i < split.length; i++) {

			if (split[i].indexOf('*') >= 0) {
				String prefix = split[i].substring(0, split[i].indexOf('*'));
				if (str.startsWith(prefix)) {
					return true;
				}

			} else {
				if (split[i].equals(str))
					return true;
			}

		}
		return false;
	}
}
