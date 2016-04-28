package com.laf.security;

import java.io.ByteArrayInputStream;
import java.io.IOException;

/**
 * 
 * @author tangbiao
 *
 */
public class EncryptHelper {
	/**
	 * MD5签名
	 * @throws IOException 
	 */
	public static String md5(String content) throws IOException {
		ByteArrayInputStream inputStream = new ByteArrayInputStream(content.getBytes());
		byte[] byteArray = Digests.md5(inputStream);
		return HexBinrary.encodeHexBinrary(byteArray).toLowerCase();
	}

	/**
	 * MD5 加密
	 * 
	 * @param content
	 * @return
	 * @throws IOException
	 */
	public static String md5(String content, String enc) throws IOException {
		ByteArrayInputStream inputStream = new ByteArrayInputStream(
				content.getBytes(enc));
		byte[] byteArray = Digests.md5(inputStream);
		return HexBinrary.encodeHexBinrary(byteArray).toLowerCase();
	}
	
	public static String encypt(String content,
			String key) {
		return Base64.encodeBase64Binrary(Digests.sha1(content.getBytes(),
				key.getBytes()));
	}
}
