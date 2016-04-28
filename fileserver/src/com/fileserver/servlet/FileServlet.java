package com.fileserver.servlet;

import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.fileserver.common.enums.ResponseCodes;
import com.fileserver.common.exception.SystemException;
import com.fileserver.entity.FileInfo;
import com.fileserver.service.commonService.FileInfoService;

public class FileServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private FileInfoService fileInfoService;
	private String rootFilePath = getServletContext().getRealPath("/");

	@Override
	public void init() throws ServletException {
		super.init();

		WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
		fileInfoService = (FileInfoService) context.getBean("fileInfoService");
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		request.setCharacterEncoding("utf-8");
		request.setCharacterEncoding("utf-8");
		
		server(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

		JSONObject object = new JSONObject();
		object.put("code", ResponseCodes.IllegalArgument.getCode());
		object.put("message", ResponseCodes.IllegalArgument.getMessage());

		response.getWriter().write(object.toString());
	}

	private void server(HttpServletRequest request, HttpServletResponse response) {

		JSONObject object = new JSONObject();
		try {
			Integer fileId = Integer.parseInt(request.getPathInfo());
			// 接口校验
			if (fileId != null) {
				FileInfo fileInfo = fileInfoService.fileInfoById(fileId);
				FileInputStream fileInputStream = new FileInputStream(rootFilePath + fileInfo.getFilePath() + fileId);
				int size = fileInputStream.available();
		        if(size > 0){
		        	response.setContentType(fileInfo.getContentType());
		        	
		        	byte fileData[]= new byte[size];
		        	fileInputStream.read(fileData);  //读数据   
		        	fileInputStream.close();   
		        	
		        	ServletOutputStream outputStream = response.getOutputStream();  
		        	outputStream.write(fileData);  
		        	outputStream.flush();  
		        	outputStream.close();       
		        }
			} else {
				throw new SystemException(ResponseCodes.IllegalArgument, null);
			}
		} catch (SystemException e) {
			e.printStackTrace();
			object.put("code", e.getErrorCode());
			object.put("message", e.getErrorMsg());
			object.put("errorInfo", e.getThrowable().getStackTrace().toString());
		} catch (Exception e) {
			e.printStackTrace();
			object.put("code", ResponseCodes.UnKnownError.getCode());
			object.put("message", ResponseCodes.UnKnownError.getMessage());
			object.put("errorInfo", e.getStackTrace().toString());
		} finally {
			try {
				response.getWriter().write(object.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
