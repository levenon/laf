package com.laf.remote;

import java.io.IOException;

import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.NameValuePair;

public class RemoteFileService implements HttpProxy {

	/**
	 * 文件二进制
	 */
	public static String FILE = "FILE";

	/**
	 * 文件类型定义
	 */
	public static String FILE_TYPE = "FILE_TYPE";

	/**
	 * 文件根路径
	 */
	public static String FILE_ROOT_URL = "FILE_ROOT_URL";

	/**
	 * 文件扩展名
	 */
	public static String EXTENTION = "EXTENTION";

	private static String URL = "http://localhost:8080/fileserver/upload";

	private RemoteFileService() {
	}

	public static RemoteFileService instance = new RemoteFileService();

	/*
	 * （非 Javadoc）
	 * 
	 * @see com.skyon.sibas.remotefile.HttpProxy#create(java.io.InputStream,
	 * java.lang.String)
	 */

	public String create(String file_type, String extention, byte[] data)
			throws HttpException, IOException {

		NameValuePair[] pairs = createNameValuePair(file_type, extention);

		return RemoteRequest.remoteSaveOrUpdate(URL, pairs, data);

	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see com.skyon.sibas.remotefile.HttpProxy#query(java.lang.String)
	 */

	public String query(String file_type, String extension, byte[] data)
			throws HttpException, IOException {

		NameValuePair[] pairs = createNameValuePair(file_type, extension);
		return RemoteRequest.remoteQuery(URL, pairs, data);

	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see com.skyon.sibas.remotefile.HttpProxy#delete(java.lang.String)
	 */

	public boolean delete(String file_type, String extension, byte[] data)
			throws HttpException, IOException {

		NameValuePair[] pairs = createNameValuePair(file_type, extension);
		return RemoteRequest.remoteDelete(URL, pairs);

	}

	/**
	 * 生成请求NameValuePair
	 * 
	 * @param file_type
	 * @param extension
	 * @param file
	 * @return
	 */
	private NameValuePair[] createNameValuePair(String file_type,
			String extention) {
		NameValuePair[] pairs = new NameValuePair[2];
		pairs[0] = new NameValuePair(FILE_TYPE, file_type);
		pairs[1] = new NameValuePair(EXTENTION, extention);
		return pairs;
	}

}