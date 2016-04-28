package com.laf.service.M9;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.entity.User;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.UserService;
import com.laf.util.JsonUtil;

/**
 * 
 * 修改密码
 * 
 * */
@Service
public class Method9_1_0 extends BaseMethod {

	@Autowired
	UserService userService;

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return resetPasswordServer(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("oldPassword", String.class);
		parameters.put("newPassword", String.class);

		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {

		Map<String, Object> map = JsonUtil.readJson2Map(params);

		return StringUtils.isNotBlank((String) map.get("oldPassword")) && StringUtils.isNotBlank((String) map.get("newPassword"));
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method9_1_0");
		}

		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	private JSONArray resetPasswordServer(Login login, JSONObject params) {

		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		String oldPassword = (String) map.get("oldPassword");
		String newPassword = (String) map.get("newPassword");

		User user = userService.userByUid(login.getUid());
		if (user != null) {
			if (user.getPassword().equals(oldPassword)) {
				user.setPassword(newPassword);
				userService.update(user);
			} else {
				throw new SystemException(ResponseCodes.OldPasswordIncorrect, null);
			}
		} else {
			throw new SystemException(ResponseCodes.UserNotExist, null);
		}

		return new JSONArray();
	}
}
