package com.laf.remote;

import java.io.IOException;

import org.apache.commons.httpclient.HttpException;

/**
 * 综合积分系统WEB上传文件转发接口
 * 
 * 	文件远程服务  参数：后台主机Servlet地址
 * 
 * @author dingdong
 * @version $Revision: 1.1 $
 * 建立日期 2011-12-19
 */
public interface HttpProxy
{

	/**
	 * 上传文件到服务器知道目录
	 * @param in 文件流 
	 * @param fileName 文件名
	 * @return 操作成功||操作失败
	 * @throws HttpException
	 * @throws IOException
	 */
	public String create(String file_type, String extension, byte[] data) throws HttpException, IOException;

	/**
	 * 查找远程文件|下载文件
	 * @param fileName 文件名
	 * @return 操作成功||操作失败
	 * @throws HttpException
	 * @throws IOException
	 */
	public String query(String file_type, String extension, byte[] data) throws HttpException, IOException;
	
	/**
	 * 删除远程文件
	 * @param fileName 文件名
	 * @return 操作成功||操作失败
	 * @throws HttpException
	 * @throws IOException
	 */
	public boolean delete(String file_type, String extension, byte[] data) throws HttpException, IOException;

}

