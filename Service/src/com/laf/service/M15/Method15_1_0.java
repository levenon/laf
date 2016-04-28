package com.laf.service.M15;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.enums.NoticeState;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.entity.Notice;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.NoticeService;
import com.laf.service.common.NoticeStateChangeService;
import com.laf.util.JsonUtil;

/**
 * 
 * 关闭公告
 * 
 * */
@Service
public class Method15_1_0 extends BaseMethod {

	@Autowired
	NoticeService noticeService;

	@Autowired
	NoticeStateChangeService noticeStateChangeService;

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return closeNoticeServer(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("noiticeId", String.class);

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
			return (IService) ContextUtil.getContext().getBean("method15_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	private JSONArray closeNoticeServer(Login login, JSONObject params) {
		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		Integer noticeId = Integer.parseInt((String) map.get("noticeId"));
		
		Notice notice = noticeService.noticeById(noticeId);

		System.out.println("用户ID:" + login.getUid() + " 开始关闭公告" + " ID:" + noticeId);
		
		if (notice != null) {

			noticeStateChangeService.addNoticeStateChange(noticeId, login.getUid(), NoticeState.Close);

			notice.setState(NoticeState.Close.value());
			noticeService.update(notice);

			return new JSONArray();
		} 
		else {
			throw new SystemException(ResponseCodes.NoticeNotExsits, null);
		}
	}
}
