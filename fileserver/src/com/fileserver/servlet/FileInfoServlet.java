package com.fileserver.servlet;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.fileserver.common.enums.ResponseCodes;
import com.fileserver.common.exception.SystemException;
import com.fileserver.common.filter.AnnotationPropertyFilter;
import com.fileserver.common.filter.JsonDateValueProcessor;
import com.fileserver.entity.FileInfo;
import com.fileserver.service.commonService.FileInfoService;

/**
 * 获取文件属性
 * 
 * @author tangbiao
 *
 */
public class FileInfoServlet extends BaseFileServlet {

	private static final long serialVersionUID = 4318875537769194549L;

	private FileInfoService fileInfoService;

	@Override
	public void init() throws ServletException {
		super.init();

		WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
		fileInfoService = (FileInfoService) context.getBean("fileInfoService");
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		// 设置返回的contentType类型
		response.setContentType("application/Json");

		server(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException {

		JSONObject object = new JSONObject();
		object.put("code", ResponseCodes.IllegalArgument.getCode());
		object.put("message", ResponseCodes.IllegalArgument.getMessage());

		response.getWriter().write(object.toString());
	}

	private void server(HttpServletRequest request, HttpServletResponse response) {
		
		JSONObject object = new JSONObject();
		String pathInfo = request.getPathInfo();
		Integer fileId = Integer.parseInt(pathInfo);
		try {
			FileInfo fileInfo = fileInfoService.fileInfoById(fileId);
			
			object.put("code", ResponseCodes.Success.getCode());
			object.put("message", ResponseCodes.Success.getMessage());

			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
			jsonConfig.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
			
			object.put("data", JSONArray.fromObject(fileInfo, jsonConfig));
			
		} catch(SystemException e) {
			object.put("code", e.getErrorCode());
			object.put("message", e.getErrorMsg());
			object.put("errorInfo", e.getThrowable().getStackTrace().toString());

		} catch (Exception e) {
			object.put("code", ResponseCodes.UnKnownError.getCode());
			object.put("message", ResponseCodes.UnKnownError.getMessage());
			object.put("errorInfo", e.getStackTrace().toString());
		}
		try {
			response.getWriter().write(JSONArray.fromObject(object).toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
