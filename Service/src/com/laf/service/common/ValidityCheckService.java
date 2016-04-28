package com.laf.service.common;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.laf.service.BaseService;
import com.laf.util.MD5Util;

@Service
public class ValidityCheckService extends BaseService {

	@Value("${verify.privateKey}")
	private String privateKey = "";
	
	public boolean validityCheck(String method, String params, String session, String encryption) {
		
		return encryption.equals(encrypt(method, params, session));
	}
	
	public String encrypt(String method, String params, String session) {
	
		return MD5Util.getMD5Str(("m=" + method+ "&sid=" + session + "&p=" + params + "&pk=" + privateKey), "utf-8");
	}
}
