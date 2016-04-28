package com.fileserver.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fileserver.common.contants.ServerContants;
import com.fileserver.common.utils.InputStreamUtil;

public abstract class BaseFileServlet extends HttpServlet {

	private static final long serialVersionUID = -5042876183356814299L;

	protected abstract void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException;

	protected abstract void doPost(HttpServletRequest arg0,
			HttpServletResponse arg1) throws ServletException, IOException;

	/**
	 * 获取文件名称
	 * 
	 * @param request
	 * @return extension
	 */
	protected String getExtFromRequest(HttpServletRequest request) {
		return request.getParameter(ServerContants.EXTENTION);
	}

	/**
	 * 获取文件类型
	 * 
	 * @param request
	 * @return
	 */
	protected String getFileTypeFromRequest(HttpServletRequest request) {
		return request.getParameter(ServerContants.FILE_TYPE);
	}

	/**
	 * 获取文件二进制
	 * 
	 * @param request
	 * @return file 字节数组
	 * @throws IOException
	 */
	protected byte[] getFileFromRequest(HttpServletRequest request) {
		byte[] data = null;
		try {
			ServletInputStream inputStream = request.getInputStream();

			data = InputStreamUtil.InputStreamTOByte(inputStream);
			
		} catch (IOException e) {

		}
		return data;
	}

}
