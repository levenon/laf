package com.laf.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.laf.returnEntity.CompleteNoticeResult;
import com.laf.service.common.NoticeService;

public class DetailJSPServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8517051427256299149L;
	private NoticeService noticeService;

	public void init() {
		ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
		noticeService = (NoticeService) applicationContext.getBean("noticeService");
	}
	
	@SuppressWarnings("deprecation")
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession(true); 
				
		String strId = request.getParameter("id");
		Integer id = null;
		
		if (strId != null) {
			id = Integer.parseInt(strId);
		}
		if (id != null) {

			CompleteNoticeResult completeNoticeResult = noticeService.completeNoticeDetailById(id);
			
			session.putValue("noticeDetail", completeNoticeResult);
			
			getServletContext().getRequestDispatcher("/pages/detail.jsp").forward(request, response);
		}		
	}
}
