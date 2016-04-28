package com.laf.service.M2;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.laf.common.enums.NoticeType;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.returnEntity.UserInfoResult;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;
import com.laf.util.JsonUtil;

/**
 * 获取用户信息
 */
@Service
public class Method2_1_0 extends BaseMethod {

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	// 参数完整性校验
	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		if (StringUtils.isNotBlank((String) map.get("uid"))) {
			return true;
		}
		return false;
	}

	// 获取参数列表
	public Map<String, Object> getMethodParams(){
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("uid", String.class);

		return parameters;
	}

	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method2_1_0");
		}

		return null;
	}

	public boolean needsVerifyLoginState() {
		return true;
	}

	// 业务逻辑处理
	public JSONArray dealWithParams(Login login, JSONObject params) {
		if (isParamsComplete(params)) {
			return getUserDetailInfo(login, params);
		}
		throw new SystemException(ResponseCodes.IllegalArgument, null);
	}

	/**
	 * 获取用户信息
	 * 
	 * @param params
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private JSONArray getUserDetailInfo(Login login, JSONObject params) {	

		System.out.println("用户ID:" + login.getId() + "开始获取用户信息");
		
		Integer uid = login.getUid();
		UserInfoResult userInfoResult = new UserInfoResult();
		
		String hql = "select new com.returnEntity.UserInfoResult(u.id, u.nickname, u.realname, u.headImgUrl, u.email, u.telephone, " +
					 	   " (select count(distinct f.id) from User us, Notice f where us.id = f.uid and us.id = "+ uid +" and f.type = " + NoticeType.Found.value() +" ), " +
					       " (select count(distinct l.id) from User us, Notice l where us.id = l.uid and us.id = "+ uid +" and l.type = " + NoticeType.Lost.value() +" )) " +
					       " from User u" +
					       " where u.id = " + uid;
		
		List<UserInfoResult> list =  null;
		try {
			list = find(hql);
		} catch (Exception e) {
			throw new SystemException(ResponseCodes.AccessUserInfoFailed, e);
		}
		if (list != null && !list.isEmpty()) {// 判断用户是否存在
			userInfoResult = list.get(0);
		} else {
			throw new SystemException(ResponseCodes.UserNotExist, null);
		}

		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
		jsonConfig.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
	
		return JSONArray.fromObject(userInfoResult, jsonConfig);
	}

}
