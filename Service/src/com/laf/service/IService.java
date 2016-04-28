package com.laf.service;

import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.laf.entity.Login;

public interface IService {

	// 匹配版本号
	public IService matchVersion(String version);

	// 是否校验登录状态
	public boolean needsVerifyLoginState();

	// 检测接口是否可用
	public boolean isInterfaceUsable();

	// 业务方法 
	public JSONArray dealWithParams(Login login, JSONObject params) throws Exception;

	// 获取各接口参数列表
	public Map<String, Object> getMethodParams() ;

	// 接口完整性校验
	public boolean isParamsComplete(JSONObject params);
}
