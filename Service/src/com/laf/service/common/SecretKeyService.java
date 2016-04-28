package com.laf.service.common;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.entity.SecretKey;
import com.laf.service.BaseService;
import com.laf.util.MD5Util;

@Service
public class SecretKeyService extends BaseService {

	public SecretKey secretKeyById(Integer id) {
		Object object = findById(SecretKey.class, id);
		if (object != null && object instanceof SecretKey) {
			return (SecretKey)object;
		}
		return null;
	}
	
	public SecretKey secretKeyBySecret(String secret) {
		Object object = findObjectByCondition("from SecretKey where secret = '" + secret + "' and isDelete = " + DefaultCode.Code_Zero);
		if (object != null && object instanceof SecretKey) {
			return (SecretKey)object;
		}
		return null;
	}
	
	public SecretKey addSecretKey() {
		SecretKey secretKey = new SecretKey();
		secretKey.setSecret(MD5Util.getMD5Str(UUID.randomUUID().toString(), "utf-8"));
		
		save(secretKey);
		
		return secretKey;
	}

	public SecretKey updateSecretKey(Integer id, String secret) {
		
		SecretKey secretKey = secretKeyById(id);
		
		if (secretKey != null) {
			secretKey.setSecret(secret);
			
			update(secretKey);
		}
		return secretKey;
	}
	
	public void removeSecretKey(Integer id) {
		SecretKey secretKey = new SecretKey();
		secretKey.setId(id);
		
		delete(secretKey);
	}
	
	public void removeSecretKey(String secret) {
		
		SecretKey secretKey = (SecretKey) find("from SecretKey where secret = " + secret + " and isDelete = " + DefaultCode.Code_Zero);
		if (secretKey != null) {
			delete(secretKey);	
		}
	}
}
