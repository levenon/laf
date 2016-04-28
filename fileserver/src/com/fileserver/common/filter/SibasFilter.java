package com.fileserver.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.fileserver.common.enums.ResponseCodes;
import com.fileserver.common.utils.ConfigFileUtil;

/**
 * IP 过滤器
 * @author tangbiao
 *
 */
@SuppressWarnings("unused")
public class SibasFilter implements Filter {
	
	public void destroy() {
		// TODO Auto-generated method stub

	}
	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain filter) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;

		HttpServletResponse response = (HttpServletResponse) res;
		
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");

		String addr = request.getRemoteAddr();
		boolean checkIP = ConfigFileUtil.checkIP(addr);
		if (true) {
			filter.doFilter(req, res);
		} else {
			JSONArray ja = new JSONArray();
			JSONObject jo = new JSONObject();
			jo.put("code", ResponseCodes.NotPermissions.getCode());
			jo.put("message", ResponseCodes.NotPermissions.getMessage());
			ja.add(jo);
			response.getWriter().print(ja.toString());
			return;
		}

	}

	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub

	}

}
