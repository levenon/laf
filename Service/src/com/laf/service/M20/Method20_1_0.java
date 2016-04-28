package com.laf.service.M20;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.CommonImage;
import com.laf.entity.Login;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.CommonImageService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;
import com.laf.util.JsonUtil;

/**
 * 
 * 获取常用图片
 * 
 * */
@Service
public class Method20_1_0 extends BaseMethod {

	@Autowired
	private CommonImageService commonImageService;

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return fetchCommonImages(params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();

		parameters.put("page", String.class);
		parameters.put("size", String.class);
		
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
			return (IService) ContextUtil.getContext().getBean("method20_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	private JSONArray fetchCommonImages(JSONObject params) {

		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		Integer page = Math.max(Integer.parseInt((String) map.get("page")), DefaultCode.Code_Qurey_Default_Page);
		Integer size = Math.max(Integer.parseInt((String) map.get("size")), DefaultCode.Code_Qurey_Default_Size);
		
		List<CommonImage> images = commonImageService.commonImages(page, size);
		
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
		jsonConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor());
		
		return JSONArray.fromObject(images, jsonConfig);
	}
}
