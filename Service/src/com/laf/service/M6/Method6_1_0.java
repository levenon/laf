package com.laf.service.M6;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.enums.PlatformType;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.middleResult.VerifyCodeMiddleResult;
import com.laf.returnEntity.VerifyCodeResult;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.VerifyCodeService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;
import com.laf.util.JsonUtil;

/**
 * 
 * 发送验证码
 * 
 * */

@Service
public class Method6_1_0 extends BaseMethod {

	@Autowired
	VerifyCodeService verifyCodeService;

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		if (StringUtils.isNotBlank((String) map.get("account")) && StringUtils.isNotBlank((String) map.get("type"))) {
			return true;
		}

		return false;
	}

	// 获取参数列表
	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("account", String.class);
		parameters.put("type", String.class);

		return parameters;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method6_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return sendVerifyCodeServer(params);
	}

	public JSONArray sendVerifyCodeServer(JSONObject params) {

		System.out.println("开始发送验证码");

		VerifyCodeResult verifyCodeResult = new VerifyCodeResult();

		Map<String, Object> map = JsonUtil.readJson2Map(params);
		String account = (String) map.get("account");
		PlatformType platformType = PlatformType.values()[Integer.parseInt((String) map.get("type"))];

		VerifyCodeMiddleResult verifyCodeMiddleResult = verifyCodeService.sendVerifyCode(platformType, account);

		verifyCodeResult.setCode(verifyCodeMiddleResult.getVerifyCode().getCode());
		verifyCodeResult.setSecret(verifyCodeMiddleResult.getSecret());

		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
		jsonConfig.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
	
		return JSONArray.fromObject(verifyCodeResult, jsonConfig);
	}
}
