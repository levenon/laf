package com.laf.service.M12;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.returnEntity.CompleteNoticeResult;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.NoticeService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;
import com.laf.util.JsonUtil;

/**
 * 
 * 获取寻物启事详情
 * 
 * */
@Service
public class Method12_1_0 extends BaseMethod {

	@Autowired
	NoticeService noticeService;
	
	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return fetchLostDetailServer(params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("id", String.class);

		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		return StringUtils.isNotBlank((String) map.get("id"));
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method12_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	private JSONArray fetchLostDetailServer(JSONObject params) {

		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		Integer id = Integer.parseInt((String) map.get("id"));
		System.out.println("开始获取寻物启事详情 ID:" + id);

		CompleteNoticeResult lostResult = noticeService.completeNoticeDetailById(id);

		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
		jsonConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor());

		return JSONArray.fromObject(lostResult, jsonConfig);
	}
}
