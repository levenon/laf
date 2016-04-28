package com.laf.service.M19;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.LoginService;

/**
 * 
 * 登出
 * 
 * */
@Service
public class Method19_1_0 extends BaseMethod {

	@Autowired
	private LoginService loginService;

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return logoutServer(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();

		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {
		return true;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method19_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	private JSONArray logoutServer(Login login, JSONObject params) {

		System.out.println("用户ID:" + login.getId() + " 登出");

		login.setValid(DefaultCode.Code_False);
		login.setLogoutTime(new Date());
		loginService.update(login);

		return new JSONArray();
	}
}
