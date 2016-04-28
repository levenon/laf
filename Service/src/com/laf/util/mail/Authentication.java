package com.laf.util.mail;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

//获取帐号密码
public class Authentication extends Authenticator{
		String username=null;  
	  String password=null;  
	  
	  public Authentication(){ 
		  
	  }  
	  public Authentication(String username, String password) {  
		  this.username = username;  
		  this.password = password;  
	  }  
	  protected PasswordAuthentication getPasswordAuthentication(){
		  //文件解析
		  PasswordAuthentication pa = new PasswordAuthentication(username, password);
	  return pa;
	  }
}
