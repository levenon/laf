

package com.fileserver.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.fileserver.common.enums.ImageKind;
import com.fileserver.common.enums.ResponseCodes;
import com.fileserver.common.exception.SystemException;
import com.fileserver.common.media.ThumbGenerator;
import com.fileserver.entity.FileInfo;
import com.fileserver.entity.ImageBinderInfo;
import com.fileserver.entity.ImageInfo;
import com.fileserver.middleResult.ImageMiddleResult;
import com.fileserver.service.commonService.FileInfoService;
import com.fileserver.service.commonService.ImageBinderInfoService;
import com.fileserver.service.commonService.ImageInfoService;

public class BindImageServlet extends HttpServlet {

	private static final long serialVersionUID = -7045454552111840413L;

	private ImageBinderInfoService imageBinderInfoService;
	private ImageInfoService imageInfoService;
	private FileInfoService fileInfoService;

	@Override
	public void init() throws ServletException {
		super.init();

		WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
		imageBinderInfoService = (ImageBinderInfoService) context.getBean("imageBinderInfoService");
		imageInfoService = (ImageInfoService) context.getBean("imageInfoService");
		fileInfoService = (FileInfoService) context.getBean("fileInfoService");
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");

		server(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

		JSONObject object = new JSONObject();		
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");

		object.put("code", ResponseCodes.IllegalVisit.getCode());
		object.put("message", ResponseCodes.IllegalVisit.getMessage());

		response.getWriter().write(object.toString());
	}

	private void server(HttpServletRequest request, HttpServletResponse response) {

		JSONObject error = null;
		ServletOutputStream servletOutputStream = null;
		try {
			
			ImageMiddleResult imageMiddleResult = excute(request);
			if (imageMiddleResult != null) {
				try {
					response.setContentType(imageMiddleResult.getContentType());
					servletOutputStream = response.getOutputStream();
					servletOutputStream.write(imageMiddleResult.getData());
				} catch (IOException e) {
					throw new SystemException(ResponseCodes.ErrFileCommunication, e);
				}
			}
		} catch (SystemException e) {
			error = new JSONObject();
			error.put("code", e.getErrorCode());
			error.put("message", e.getErrorMsg());
			error.put("errorInfo", e.getThrowable().getStackTrace().toString());
		} catch (Exception e) {
			error = new JSONObject();
			error.put("code", ResponseCodes.UnKnownError.getCode());
			error.put("message", ResponseCodes.UnKnownError.getMessage());
			error.put("errorInfo", e.getStackTrace().toString());
		} 
		try {
			if (error != null) {
				PrintWriter printWriter = null;
				if (servletOutputStream != null ) {
					printWriter = new PrintWriter(servletOutputStream);
				}
				else{
					printWriter = response.getWriter();	
				}
				printWriter.write(error.toString());
				printWriter.close();
			}
			else{
				if (servletOutputStream != null ) {
					servletOutputStream.close();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private ImageMiddleResult excute(HttpServletRequest request) throws IOException {

		// 图片ID
		Integer imageBinderId = Integer.parseInt(request.getParameter("id"));
		// 图片缩放
		String scale = request.getParameter("scale");
		// 裁剪锚点
		String anchor = request.getParameter("anchor");
		// 图片裁剪
		String crop = request.getParameter("crop");
		// 图片质量
		String quality = request.getParameter("quality");
		// 图片旋转角度
		String rotate = request.getParameter("rotate");
		// 图片文件类型
		String format = request.getParameter("format");
		// 图片规格 @2x @3x
//		String spec = request.getParameter("spec");
		// 图片文件类型
		String kind = request.getParameter("kind");

		if (StringUtils.isNotBlank(format)) {
			format = format.toLowerCase();
		} else {
			format = "png";
		}
		// 标识内存中是否有操作图片
		if (imageBinderId != null) {// 若没有id，直接null
			
			ImageBinderInfo imageBinderInfo = imageBinderInfoService.imageBinderInfoById(imageBinderId);
			ImageKind imageKind = kind != null ? ImageKind.valueOf(kind) : ImageKind.defaullt;
			
			ImageInfo imageInfo = imageInfoService.imageInfoById(imageBinderInfo.destinateImageId(imageKind));
			if (imageInfo == null || imageInfo.getId() == null) {
				throw new SystemException(ResponseCodes.ImageNotExist, null);
			}

			FileInfo fileInfo = fileInfoService.fileInfoById(imageInfo.getFileId());
			String filePath = fileInfo.getFilePath() + "/" + fileInfo.getId();
			
			return ThumbGenerator.imageHandle(filePath, scale, anchor, crop, quality, rotate, format);
		}
		else{
			throw new SystemException(ResponseCodes.ImageIdNotBeEmpty, null);
		}
	}
}
