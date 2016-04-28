package com.laf.service.M8;

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
import com.laf.middleResult.VerifyStatus;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.AuthorizeService;
import com.laf.service.common.SecretKeyService;
import com.laf.service.common.UserService;
import com.laf.service.common.VerifyCodeService;
import com.laf.util.JsonUtil;
import com.laf.util.MD5Util;

/**
 * 
 * 找回密码
 * 
 * */
@Service
public class Method8_1_0 extends BaseMethod {

	@Autowired
	AuthorizeService authorizeService;

	@Autowired
	SecretKeyService secretKeyService;

	@Autowired
	VerifyCodeService verifyCodeService;

	@Autowired
	UserService userService;

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return resetPasswordServer(params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("account", String.class);
		parameters.put("newPassword", String.class);
		parameters.put("code", String.class);
		parameters.put("secret", String.class);
		parameters.put("platformType", String.class);
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
		if (StringUtils.isNotBlank((String) map.get("account")) && StringUtils.isNotBlank((String) map.get("newPassword"))
				&& StringUtils.isNotBlank((String) map.get("platformType"))) {

			PlatformType platformType = PlatformType.values()[Integer.parseInt((String) map.get("platformType"))];
			if (PlatformType.Normal != platformType) {

				if (PlatformType.Email == platformType) {
					return StringUtils.isNotBlank((String) map.get("code")) && StringUtils.isNotBlank((String) map.get("secret"));
				} else if (PlatformType.Telephone == platformType) {
					return StringUtils.isNotBlank((String) map.get("code")) && StringUtils.isNotBlank((String) map.get("zone"));
				}
			} else {
				return true;
			}
		}
		return false;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method8_1_0");
		}

		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	private JSONArray resetPasswordServer(JSONObject params) {

		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		String account = (String) map.get("account");
		String password = (String) map.get("newPassword");
		String secret = (String) map.get("secret");
		String code = (String) map.get("code");
		String zone = (String) map.get("zone");
		PlatformType platformType = PlatformType.values()[Integer.parseInt((String) map.get("platformType"))];

		// 根据平台类型 选择对应的登陆方式,返回用户信息
		// 用户名登陆
		if (platformType == PlatformType.Normal || platformType == PlatformType.Telephone || platformType == PlatformType.Email) {
			// 注册信息
			Authorize authorize = authorizeService.authorizeByAccount(platformType, account);
			if (authorize != null) {
				// 校验验证码
				if (platformType != PlatformType.Normal) {
					// 校验验证码
					VerifyStatus verifyStatus = verifyCodeService.matchVerifyCode(platformType, account, zone, code, secret);
					if (verifyStatus.getStatus()) {
						User user = userService.userByUid(authorize.getUid());
						if (user != null) {
							user.setPassword(MD5Util.getMD5Str(password, "utf-8"));
							userService.update(user);
						}
						if (verifyStatus.getVerifyCode() != null) {
							verifyCodeService.invalidVerifyCode(verifyStatus.getVerifyCode());
						}
					} else {
						throw new SystemException(ResponseCodes.VerifyCodeIncerrect, null);
					}
				}
			} else {
				throw new SystemException(ResponseCodes.UserNotExist, null);
			}
		} else {
			throw new SystemException(ResponseCodes.ErrorPlatformType, null);
		}

		return new JSONArray();
	}
}
