package com.laf.service.M4;

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
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.FeedbackService;
import com.laf.util.JsonUtil;

/**
 * 
 * 意见反馈
 * 
 * */

@Service
public class Method4_1_0 extends BaseMethod {

	@Autowired
	FeedbackService feedbackService;

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	// 参数完整性校验
	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		// 验证必填参数是否为空
		if (StringUtils.isNotBlank((String) map.get("content"))) {
			return true;
		}
		return false;
	}

	// 获取参数列表
	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("content", String.class);
		parameters.put("telephone", String.class);
		parameters.put("name", String.class);

		return parameters;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method4_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return feedBackServer(login, params);
	}

	private JSONArray feedBackServer(Login login, JSONObject params) {
		System.out.println("用户ID:" + login.getId() + " 开始用户反馈");

		Map<String, Object> map = JsonUtil.readJson2Map(params);
		// 储存反馈信息
		String content = (String) map.get("content");
		String name = (String) map.get("name");
		String telephone = (String) map.get("telephone");
		try {
			feedbackService.addFeedback(content, login.getUid(), telephone, name);
		} catch (Exception e) {
			throw new SystemException(ResponseCodes.FeedbackFailed, e);
		}

		return new JSONArray();
	}
}
