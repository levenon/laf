package com.laf.test;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.laf.common.enums.MethodNumber;
import com.laf.common.utils.ContextUtil;
import com.laf.service.IService;

public class GetParamsStringsAjax extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@SuppressWarnings("unused")
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		resp.setContentType("text/html;charset=utf-8");
		resp.setCharacterEncoding("UTF-8");
		//端口号模拟
		String interfaceNumbers = req.getParameter("interfaceNumber");
		String str = (String)(new MethodNumber()).get(interfaceNumbers + "");
		IService controller = null;
//		try {
//			controller = (IService) Class.forName(str).newInstance();
			controller = (IService) ContextUtil.getContext().getBean(str);
//		} catch (InstantiationException e) {
//			e.printStackTrace();
//		} catch (IllegalAccessException e) {
//			e.printStackTrace();
//		} catch (ClassNotFoundException e) {
//			e.printStackTrace();
//		}
		
//		Map<String, Object> parameters = controller.getMethodParams();
//		
//		if(interfaceNumbers != null) {
//			JSONArray array = new JSONArray();  
//	        JSONObject member = null;
//	        JSONObject json = new JSONObject();
//	        for (int i = 0; i < list.size(); i++) {  
//	            member = new JSONObject();  
//	            member.put("param", list.get(i));
//	            array.add(member);  
//	        }
//	        json.put("array", array);
//	        json.put("number", list.size());
//	        PrintWriter pw = resp.getWriter();
//	        
//	        pw.print(json.toString());
//	        pw.close();
//		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}
}
