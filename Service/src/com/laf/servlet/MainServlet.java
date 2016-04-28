package com.laf.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.laf.common.constants.DefaultCode;
import com.laf.common.enums.MethodNumber;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.entity.Login;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.LoginService;
import com.laf.service.common.RequestLogService;
import com.laf.util.MD5Util;

public class MainServlet extends  HttpServlet{
	
	private static final long serialVersionUID = 1L;
	private String privateKey = ResourceBundle.getBundle("application").getString("verify.privateKey");
	private RequestLogService requestLogService;
	private LoginService loginService;
	private ApplicationContext applicationContext;
	
	@Override
	public void init() throws ServletException {
		applicationContext = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
		requestLogService  = (RequestLogService) applicationContext.getBean("requestLogService");
		loginService  = (LoginService) applicationContext.getBean("loginService");
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.sendRedirect("./index.html");
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html");
		
		server(request, response);
	}
	
	public void server(HttpServletRequest request, HttpServletResponse response){

		String paramArea = request.getHeader("paramArea");
		Boolean fromParam = paramArea != null ? paramArea.equalsIgnoreCase("form") : true;

		String method = fromParam ? request.getParameter("m") : request.getHeader("m") ;
		String version = fromParam ? request.getParameter("v") : request.getHeader("v") ;
		String params = fromParam ? request.getParameter("p") : request.getHeader("p") ;
		String session = fromParam ? request.getParameter("s") : request.getHeader("s") ;
		String encryption = fromParam ? request.getParameter("k") : request.getHeader("k") ;
		
		try {
			
			System.out.println("开始执行请求\nmethod : " + method + "\nversion : " + version + "\nparams : " + params + "\nsession : " + session + "\nencryption : " + encryption);
			String string = execute(request, response, method, version, params, session, encryption).toString();	

			PrintWriter out = response.getWriter();
			out.print(string);
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public String execute(HttpServletRequest request, HttpServletResponse response, String method, String version, String params, String session, String encryption) {
			
		String code = ResponseCodes.Success.getCode();
		JSONObject result = new JSONObject();
		try{
			// 验证接口有效性
			checkEncryption(method, version, params, session, encryption);

			IService methodBrigde = matchInteface(method);
			// 判断是否需要登录，如果需要则校验登录状态
			BaseMethod service = (BaseMethod) methodBrigde.matchVersion(version);
			// 检查接口是否可用
			checkIntefaceUsable(service);

			service.setRequest(request);
			service.setResponse(response);

			// 校验登陆
			Login login = checkLogin(service, session);
			// 不需要登录或者已登录，则执行逻辑
			JSONObject jsonParams = params.length() != DefaultCode.Code_Zero ? JSONObject.fromObject(params) : new JSONObject();

			// 检查参数完整性
			checkParamterComplete(service, jsonParams);

			JSONArray results = service.dealWithParams(login, jsonParams);

			ResponseCodes codes = ResponseCodes.Success;
			// 根据返回值判断是否操作成功
			result.put("code", codes.getCode());
			result.put("message", codes.getMessage());
			result.put("data", results != null ? results : new JSONArray());
			
		} catch(SystemException e) {

			code = e.getErrorCode();
			//捕获系统异常，返回错误信息客户端
			result.put("code", e.getErrorCode());
			result.put("message", e.getErrorMsg());
			result.put("data", new JSONArray());
			result.put("errorInfo", e.getThrowable().getMessage());
		} catch(Exception e){
			
			ResponseCodes codes = ResponseCodes.FailOperDB;
			code = codes.getCode();
			result.put("code", codes.getCode());
			result.put("message", codes.getMessage());
			result.put("data", new JSONArray());
			result.put("errorInfo", e.getMessage());
		} finally {
			String device = null;
			try {
				device = new String(request.getHeader("User-Agent").getBytes("ISO-8859-1"), "UTF-8");
			} catch (UnsupportedEncodingException e1) {
				System.out.println(e1.toString());
				device = "unknown";
			}
			
			try {
				requestLogService.addRequestLog(method, version, params, new Date(), code, device);
			} catch (SystemException e) {
				//捕获系统异常，返回错误信息到客户端
				result.put("code", e.getErrorCode());
				result.put("message", e.getErrorMsg());
				result.put("data", new JSONArray());
				result.put("errorInfo", e.getThrowable().getMessage());
			}
		}
		System.out.println(result.toString());
		return result.toString();
	}

	private IService matchInteface(String method) {
		
		Map<String, String> methodNumber = new MethodNumber();
		String InterfaceName = methodNumber.get(method);
		if (InterfaceName == null) {
			throw new SystemException(ResponseCodes.InterfaceNoExist, null);
		}
		try {
			return (IService) applicationContext.getBean(InterfaceName);	
		} catch (Exception e) {
			throw new SystemException(ResponseCodes.InterfaceLinkError, null);
		}	
	}
	
	private void checkEncryption(String method, String version, String params, String session, String encryption) throws SystemException {

		if (encryption != null && !encryption.isEmpty()) {
			String originEncryption = "m=" + method + "&sid=" + session + "&p=" + params + "&pk=" + privateKey;
			if (!encryption.equals(MD5Util.getMD5Str(originEncryption, "utf-8"))) {
				throw new SystemException(ResponseCodes.MatchInterWrong, null);
			}
		} else {
			throw new SystemException(ResponseCodes.IllegalVisit, null);
		}
	}

	private void checkIntefaceUsable(IService service) throws SystemException {

		if (!service.isInterfaceUsable()) {
			throw new SystemException(ResponseCodes.DiabledInterface, null);
		}
	}

	private Login checkLogin(IService service, String session) throws SystemException {

		Login login = null;
		if (service.needsVerifyLoginState()) {
			login = loginService.loginBySession(session);
			if (login != null) {
				if (DefaultCode.Code_True != login.getValid().booleanValue()) {
					throw new SystemException(ResponseCodes.LoginInvalid, null);// 登录失效
				}
			} else {
				throw new SystemException(ResponseCodes.NotPermissions, null);// 未登录
			}
		}
		return login;
	}

	private void checkParamterComplete(IService service, JSONObject parameters) throws SystemException {

		if (DefaultCode.Code_True != service.isParamsComplete(parameters)) {
			throw new SystemException(ResponseCodes.IllegalArgument, null);
		}
	}
}
