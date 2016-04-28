package com.laf.service.M21;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.enums.PlatformType;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Authorize;
import com.laf.entity.Login;
import com.laf.entity.User;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.AuthorizeService;
import com.laf.service.common.UserService;
import com.laf.service.common.VerifyCodeService;
import com.laf.util.JsonUtil;

/**
 * 
 * 修改手机号
 * 
 * */
@Service
public class Method21_1_0 extends BaseMethod {

	@Autowired
	private VerifyCodeService verifyCodeService;
	
	@Autowired
	private AuthorizeService authorizeService;

	@Autowired
	private UserService userService;
	

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return fetchCommonImages(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();

		parameters.put("telephone", String.class);
		parameters.put("code", String.class);
		parameters.put("zone", String.class);
		
		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {

		Map<String, Object> map = JsonUtil.readJson2Map(params);
		return StringUtils.isNotBlank((String) map.get("telephone")) && 
				StringUtils.isNotBlank((String) params.get("code"))&& 
				StringUtils.isNotBlank((String) params.get("zone"));
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method21_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	private JSONArray fetchCommonImages(Login login, JSONObject params) {

		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		String telephone = (String)map.get("telephone");
		String code = (String)map.get("code");		
		String zone = (String)map.get("zone");		
		
		if (telephone.matches("^[1]\\d{10}$") && verifyCodeService.verifyTelephoneCode(telephone, code, zone)) {
			Authorize authorize = authorizeService.authorizeByAccount(PlatformType.Telephone, telephone);
			if (authorize == null) {
				authorize = authorizeService.authorizeByUid(PlatformType.Telephone, login.getUid());
				if (authorize != null) {
					// 删除原来的绑定记录
					authorizeService.delete(authorize);
				}
				// 添加绑定记录
				authorize = authorizeService.addAuthorize(login.getUid(), PlatformType.Telephone, telephone);
				
				User user = userService.userByUid(login.getUid());
				user.setTelephone(telephone);
				
				userService.update(user);
			}
			else {
				throw new SystemException(ResponseCodes.TelephoneExist, null);
			}
		}
		return new JSONArray();
	}
}
