package com.laf.service.M14;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.returnEntity.UserSummaryResult;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.HelpService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;
import com.laf.util.JsonUtil;

/**
 * 
 * 和公告发布者取得联系
 * 
 * */
@Service
public class Method14_1_0 extends BaseMethod {

	@Autowired
	HelpService helpService;

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return contactPublisherServer(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("noticeId", String.class);

		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		return StringUtils.isNotBlank((String) map.get("noticeId"));
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method14_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	private JSONArray contactPublisherServer(Login login, JSONObject params) {
		System.out.println("用户ID:" + login.getId() + " 联系发布者");
		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		Integer noticeId = Integer.parseInt((String) map.get("noticeId"));

		UserSummaryResult userSummaryResult = (UserSummaryResult) findObjectByCondition("select new com.laf.returnEntity.UserSummaryResult( us.id, us.nickname, us.realname, us.email, us.telephone, us.headImageUrl )"
				+ " from User us, Notice no" + " " + " where us.id = no.uid and no.id = " + noticeId);
		if (userSummaryResult != null) {

			helpService.addHelp(login.getUid(), noticeId);

			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
			jsonConfig.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());

			return JSONArray.fromObject(userSummaryResult, jsonConfig);
		} else {
			throw new SystemException(ResponseCodes.NoticeNotExsits, null);
		}
	}
}
