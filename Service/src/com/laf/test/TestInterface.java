package com.laf.test;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.laf.common.enums.MethodNumber;
import com.laf.service.IService;
//输出code和json时，在网页加上一个参数表示是网页还是手机端，如果是手机端设为false，不需要返回错误描述，网页端相反
//错误代码，写在xml中。 需要时，使用流获取描述。
public class TestInterface extends HttpServlet{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@SuppressWarnings("unused")
	private static char hexDigits[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

	@Override
	@SuppressWarnings("unused")
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		resp.setContentType("text/html;charset=utf-8");
		resp.setCharacterEncoding("UTF-8");
		String interfaceNumber = req.getParameter("m");
		System.out.println(interfaceNumber);
		String uuid = req.getParameter("sid");
		System.out.println(uuid);
		String uvk = req.getParameter("uvk");
		System.out.println(uvk);
		JSONObject js = JSONObject.fromObject(req.getParameter("p"));
		StringBuffer sb = new StringBuffer();
		sb.append("m=");
		sb.append(interfaceNumber);
		sb.append("&");
		sb.append("sid=");
		sb.append(uuid);
		sb.append("&");
		sb.append("p=");
		//获取界面数据并拼装成JSONObject对象
		JSONObject object = new JSONObject();
		String str = (String) new MethodNumber().get(interfaceNumber + "");
		IService controller = null;
		try {
			controller = (IService) Class.forName(str).newInstance();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
//		List list = controller.getMethodParams();
//		for(int i=0; i<list.size(); i++) {
//			object.put(list.get(i), req.getParameter((String) list.get(i)));
//		}

		sb.append(js.toString());
		System.out.println(sb.toString());
		
		//MD5加密
		String returnString = null;
		if(!sb.toString().isEmpty()) {
			returnString = getMD5Str(sb.toString(), "utf-8");
		}
	    JSONObject json = new JSONObject();
	    JSONArray array = new JSONArray();
		if(returnString.equals(uvk)){
			 json.put("code", 200);
		     json.put("content", "测试通过");
		     json.put("bz", object.toString());
		}else{
			 json.put("code", 404);
		     json.put("content", "测试失败，请检查传入的JSON格式是否正确");
		     json.put("bz", object.toString());
		}
		array.add(json);
		PrintWriter pw = resp.getWriter();
	    pw.print(array.toString());
	    System.out.println(array.toString());
	    pw.close();
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		doGet(req, resp);
	}
	
	public synchronized static final String getMD5Str(String str,String charSet) throws UnsupportedEncodingException { //md5加密  
	    MessageDigest messageDigest = null;    
	    try {    
	        messageDigest = MessageDigest.getInstance("MD5");    
	        messageDigest.reset();   
	        if(charSet==null){  
	            messageDigest.update(str.getBytes());  
	        }else{  
	            messageDigest.update(str.getBytes(charSet));    
	        }             
	    } catch (NoSuchAlgorithmException e) {    
	        e.printStackTrace();
	    }    
	      
	    byte[] byteArray = messageDigest.digest();    
	    StringBuffer md5StrBuff = new StringBuffer();    
	    for (int i = 0; i < byteArray.length; i++) {                
	        if (Integer.toHexString(0xFF & byteArray[i]).length() == 1)    
	            md5StrBuff.append("0").append(Integer.toHexString(0xFF & byteArray[i]));    
	        else    
	            md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));    
	    }    
	    return md5StrBuff.toString();
	}  
}
