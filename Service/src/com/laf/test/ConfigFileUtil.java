package com.laf.test;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import com.laf.remote.RemoteFileService;

/**
 * 读取URLMap 
 * @author tangbiao
 *
 */
public class ConfigFileUtil {
	private final static String configFileName = "/2.jpg";


	static InputStream stream = null;	
	
	public static String getBase64FromStream() throws IOException {

		stream = ConfigFileUtil.class.getResourceAsStream(configFileName);
			
		ByteArrayOutputStream output = new ByteArrayOutputStream();
	    byte[] buffer = new byte[4096];
	    int n = 0;
	    while (-1 != (n = stream.read(buffer))) {
	        output.write(buffer, 0, n);
	    }
	    byte[] bytes = output.toByteArray();
//	    System.out.println("bytes.length:" + bytes.length);
	      
	    return new BASE64Encoder().encode(bytes);
	    
	}
	 
	public static void main(String[] args) throws IOException {
		
		//文件流转base64请求远程文件服务器
		String fileStr = getBase64FromStream();
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] data = decoder.decodeBuffer(fileStr);
		
		String extention = "jpg";
		String file_type = "1";
		
		String json = RemoteFileService.instance.create(file_type, extention, data);

		System.out.println(json);
		System.exit(0);
	}

}
