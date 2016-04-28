package com.laf.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;

public class MD5Util {
	//md5加密
	public synchronized static final String getMD5Str(String str,String charSet){   
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
	    	throw new SystemException(ResponseCodes.ErrorMD5Create, e);
	    } catch (UnsupportedEncodingException e) {
	    	throw new SystemException(ResponseCodes.ErrorMD5Create, e);
		}    
	      
	    byte[] byteArray = messageDigest.digest();    
	    StringBuffer md5StrBuff = new StringBuffer();    
	    for (int i = 0; i < byteArray.length; i++) {                
	        if (Integer.toHexString(0xFF & byteArray[i]).length() == 1){
	            md5StrBuff.append("0").append(Integer.toHexString(0xFF & byteArray[i]));
	        } 
	        else {    
	            md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));    
	        }
	    }    
	    return md5StrBuff.toString();
	}  
}
