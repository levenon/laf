package com.laf.service.M3;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.UserService;
import com.laf.util.JsonUtil;

/**
 * 
 * 修改用户信息
 * 
 * */
@Service
public class Method3_1_0 extends BaseMethod {

	@Autowired
	UserService userService;
	
	@Override
	public Map<String, Object> getMethodParams(){
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("headImage", String.class);
		parameters.put("nickname", String.class);
		parameters.put("realname", String.class);
		parameters.put("telephone", String.class);
		parameters.put("email", String.class);
		
		parameters.put("uid", String.class);

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
			return (IService) ContextUtil.getContext().getBean("method3_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return modifyUserInfo(login, params);
	}

	private JSONArray modifyUserInfo(Login login, JSONObject params) {		
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		Integer uid = map.get("uid") != null ? Integer.parseInt((String) map.get("uid")) : login.getUid();
		String headImgUrl = (String) map.get("headImgUrl");
		String nickname = (String) map.get("nickname");
		String realname = (String) map.get("realname");
		String telephone = (String) map.get("telephone");
		String email = (String) map.get("email");

		System.out.println("用户ID:" + uid + " 开始修改用户" + uid + "的信息");
		userService.updateUser(uid, nickname, realname, headImgUrl, telephone, email);
		
		return new JSONArray();
	}

}
