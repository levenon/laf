package com.laf.util.mail;

import java.util.Date;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
public class MailSender  {  
/**  
  * 以文本格式发送邮件  
  */  
  public boolean sendTextMail(SendMail mailInfo) { 
	  // 判断是否需要身份认证  
	  Authentication authenticator = null;  
	  Properties pro = mailInfo.getProperties();
	  if (mailInfo.isValidate()) {  
		  // 如果需要身份认证，则创建一个密码验证器  
		  authenticator = new Authentication("email@domain.com", "password");
	  }  
	  // 根据邮件会话属性和密码验证器构造一个发送邮件的session  
	  Session sendMailSession = Session.getDefaultInstance(pro,authenticator);  
	  sendMailSession.setDebug(true);
	  try {
		  Message mailMessage = new MimeMessage(sendMailSession);
		  Address from = new InternetAddress(mailInfo.getFromAddress());
		  Address to = new InternetAddress(mailInfo.getToAddress());
		  
		  mailMessage.setFrom(from);  
		  mailMessage.setRecipient(Message.RecipientType.TO,to);
		  mailMessage.setSubject(mailInfo.getSubject());
		  mailMessage.setSentDate(new Date()); 
		  mailMessage.setText(mailInfo.getContent());
		  
		  Transport.send(mailMessage);
		  
		  return true;  
	  } catch (MessagingException ex) {  
		  ex.printStackTrace();  
	  }
	  return false;  
  }
  /**  
  * 以HTML格式发送邮件  
  */  
  public boolean sendHtmlMail(SendMail mailInfo){  
	  // 判断是否需要身份认证  
	  Authentication authenticator = null;  
	  Properties pro = mailInfo.getProperties();
	  if (mailInfo.isValidate()) {  
		  authenticator = new Authentication("email@domain.com", "password");
	  }  
	  // 根据邮件会话属性和密码验证器构造一个发送邮件的session  
	  Session sendMailSession = Session.getDefaultInstance(pro,authenticator);  
	  try {  
		  // 根据session创建一个邮件消息  
		  Message mailMessage = new MimeMessage(sendMailSession);
		  Address from = new InternetAddress(mailInfo.getFromAddress());
		  Address to = new InternetAddress(mailInfo.getToAddress());  
		  
		  mailMessage.setFrom(from);
		  // Message.RecipientType.TO属性表示接收者的类型为TO  
		  mailMessage.setRecipient(Message.RecipientType.TO,to);
		  mailMessage.setSubject(mailInfo.getSubject());
		  mailMessage.setSentDate(new Date());
		  Multipart mainPart = new MimeMultipart();
		  BodyPart html = new MimeBodyPart();
		  html.setContent(mailInfo.getContent(), "text/html; charset=utf-8");  
		  mainPart.addBodyPart(html);
		  mailMessage.setContent(mainPart);
		  Transport.send(mailMessage);  
		  
		  return true;  
	  } catch (MessagingException ex) {  
	  ex.printStackTrace();  
	  }  
	  return false;  
	  }
}  
