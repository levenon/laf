package com.laf.util.mail;

public class Test {
	public static void main(String[] args){  
		  //设置邮件参数  
		  SendMail mail = new SendMail();  
//		  mail.setMailServerHost("smtp.qq.com");
//		  mail.setMailServerPort("25");  
//		  mail.setValidate(true);
//		  mail.setUserName("503318485@qq.com");
//		  mail.setPassword("lijing110001");
//		  mail.setFromAddress("503318485@qq.com");
		  mail.setToAddress("308865427@163.com");
		  mail.setSubject("验证码");
		  mail.setContent(Captchas.getSixRandomString());
		  //发送邮件  
		  MailSender sms = new MailSender();  
		  sms.sendTextMail(mail);//发送文体格式 
		  System.out.println("11111111111111111111");
	} 
}
