package com.fileserver.servlet;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.ResourceBundle;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.fileserver.common.enums.ResponseCodes;
import com.fileserver.common.exception.SystemException;
import com.fileserver.common.utils.FileUtil;
import com.fileserver.common.utils.MD5Util;
import com.fileserver.entity.FileInfo;
import com.fileserver.entity.ImageInfo;
import com.fileserver.service.commonService.FileInfoService;
import com.fileserver.service.commonService.ImageInfoService;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.FileRenamePolicy;

/**
 * 文件上传
 * 
 * @author tangbiao
 * 
 */
public class UploadFileServlet extends BaseFileServlet {

	private static final long serialVersionUID = 3130016708304478372L;
	private static final int permitedSize = 314572800;
	private String privateKey = ResourceBundle.getBundle("application").getString("verify.privateKey");
	private ImageInfoService imageInfoService;
	private FileInfoService fileInfoService;

	@Override
	public void init() throws ServletException {
		super.init();
		WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
		imageInfoService = (ImageInfoService) context.getBean("imageInfoService");
		fileInfoService = (FileInfoService) context.getBean("fileInfoService");
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		JSONObject object = new JSONObject();
		object.put("code", ResponseCodes.IllegalArgument.getCode());
		object.put("message", ResponseCodes.IllegalArgument.getMessage());

		response.getWriter().write(object.toString());
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		// 设置返回的contentType类型
		response.setContentType("application/json");
		server(request, response);
	}

	private void server(HttpServletRequest request, HttpServletResponse response) {

		String fileFolder = "files";
		String rootFolder = getServletContext().getRealPath("");
		String webappsFolder = rootFolder.substring(0, rootFolder.lastIndexOf("/"));
		String filePath = webappsFolder + "/" + fileFolder;
		FileUtil.mkdir(filePath);

		JSONObject result = new JSONObject();
		try {
			// 获取句柄
			MultipartRequest multipartRequest = new MultipartRequest(request, filePath, permitedSize, "utf-8", new FileRenamePolicy() {

				@Override
				public File rename(File file) {
					if (createNewFile(file)) {
						return file;
					}
					String name = file.getName();
					String body = null;
					String ext = null;

					int dot = name.lastIndexOf(".");
					if (dot != -1) {
						body = name.substring(0, dot);
						ext = name.substring(dot); // includes "."
					} else {
						body = name;
						ext = "";
					}
					Date d = new Date();
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
					String dateStr = sdf.format(d); // 创建时间戳字符串
					int count = 0;
					while (!createNewFile(file) && count < 9999) {
						count++;
						String newName = body + dateStr + count + ext; // 文件名增加时间戳
						file = new File(file.getParent(), newName);
					}
					return file;
				}

				private boolean createNewFile(File file) {
					try {
						return file.createNewFile();
					} catch (IOException ignored) {
						return false;
					}
				}
			});

			String uvk = request.getHeader("uvk");
			uvk = uvk != null ? uvk : request.getParameter("uvk"); 
			// 校验接口有效性
			if (uvk != null && !uvk.isEmpty()) {
				try {
					if (!uvk.equals(MD5Util.getMD5Str("&pk=" + privateKey, "utf-8"))) {
						throw new SystemException(ResponseCodes.IllegalArgument, null);
					}
				} catch (UnsupportedEncodingException e) {
					throw new SystemException(ResponseCodes.IllegalVisit, e);
				}
			} else {
				throw new SystemException(ResponseCodes.IllegalVisit, null);
			}

			// 取得文件
			@SuppressWarnings("rawtypes")
			Enumeration files = multipartRequest.getFileNames();
			// 取得文件详细信息
			JSONArray objects = new JSONArray();
			JSONObject object = new JSONObject();
							
			while (files.hasMoreElements()) {

				String element = (String) files.nextElement();
				String contentType = multipartRequest.getContentType(element).toLowerCase();
				File file = multipartRequest.getFile(element);
				
				FileInfo fileInfo = fileInfoService.addFileInfo(filePath, UUID.randomUUID().toString().replace("-",""), file.length(), contentType);
				if (fileInfo != null) {
					try {
						FileUtil.copyFile(file, filePath, fileInfo.getId().toString());
					} catch (Exception e) {
						fileInfoService.removeFileInfo(fileInfo.getId());
						throw e;
					}
					object.put("fileId", fileInfo.getId());
					if (contentType.contains("image") || 
							contentType.contains("jpg") || 
							contentType.contains("jpeg") || 
							contentType.contains("png") || 
							contentType.contains("gif") || 
							contentType.contains("icon") || 
							contentType.contains("tiff")) {

						BufferedImage bufferedImage = ImageIO.read(file);
						int width = bufferedImage.getWidth();
						int height = bufferedImage.getHeight();
						ImageInfo imageInfo = imageInfoService.addImageInfo(fileInfo.getId(), width, height);
						object.put("imageId", imageInfo.getId()); 
					}
					FileUtil.deleteFile(file);
				}
				objects.add(object);
			}
			result.put("data", objects);

			ResponseCodes responseCodes = ResponseCodes.Success;
			result.put("code", responseCodes.getCode());
			result.put("message", responseCodes.getMessage());
		} catch (SystemException e) {
			result.put("code", e.getErrorCode());
			result.put("message", e.getMessage());
			result.put("errorInfo", e.getThrowable().getStackTrace());
		} catch (Exception e) {
			result.put("code", ResponseCodes.UnKnownError.getCode());
			result.put("message", ResponseCodes.UnKnownError.getCode());
			result.put("errorInfo", e.getStackTrace());
			e.printStackTrace();
		}
		try {
			response.getWriter().write(result.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
