package com.laf.service.M1;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.enums.NoticeType;
import com.laf.common.enums.PlatformType;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Authorize;
import com.laf.entity.Login;
import com.laf.entity.User;
import com.laf.returnEntity.UserSessionResult;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.AuthorizeService;
import com.laf.service.common.LoginService;
import com.laf.service.common.UserService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;
import com.laf.util.JsonUtil;
import com.laf.util.MD5Util;

/**
 * 
 * 登录
 * 
 * */
@Service
public class Method1_1_0 extends BaseMethod {

	@Autowired
	private LoginService loginService;

	@Autowired
	private AuthorizeService authorizeService;

	@Autowired
	private UserService userService;

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	// 参数完整性校验
	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);

		// 验证必填参数是否为空
		if (StringUtils.isNotBlank((String) map.get("platformType"))) {

			if (PlatformType.values()[Integer.parseInt(((String) map.get("platformType")))] == PlatformType.Normal) {
				if (StringUtils.isNotBlank((String) map.get("account")) && StringUtils.isNotBlank((String) map.get("password"))) {
					return true;
				}
			} else {
				if (StringUtils.isNotBlank((String) map.get("openId"))) {
					return true;
				}
			}
		}
		return false;
	}

	// 获取参数列表
	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("account", String.class);
		parameters.put("password", String.class);
		parameters.put("platformType", String.class);
		parameters.put("openId", String.class);
		parameters.put("deviceToken", String.class);

		return parameters;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method1_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) throws Exception {
		return loginServer(params);
	}

	// 登录逻辑处理
	@SuppressWarnings("unchecked")
	public JSONArray loginServer(JSONObject params) throws Exception {

		System.out.println("开始登录");
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		PlatformType platform = PlatformType.values()[Integer.parseInt((String) map.get("platformType"))];
		String openId = (String) map.get("openId");
		String account = (String) map.get("account");
		String password = (String) map.get("password");
		String deviceToken = (String) map.get("deviceToken");
		String nickname = (String) map.get("nickname");
		String headImageUrl = (String) map.get("headImageUrl");

		Login login = null;
		// 根据平台类型 选择对应的登陆方式,返回用户信息
		// 用户名登陆
		if (platform == PlatformType.Normal || platform == PlatformType.Telephone || platform == PlatformType.Email) {
			// 验证注册
			Authorize authorize = authorizeService.authorizeByAccount(account);
			if (authorize != null) {
				// 若已注册，获取用户信息
				User user = userService.userByUid(authorize.getUid());
				if (user.getPassword().equals(MD5Util.getMD5Str(password, "utf-8"))) {
					try {
						// 添加登录记录
						login = loginService.addLogin(user.getId(), deviceToken);
					} catch (Exception e) {
						throw new SystemException(ResponseCodes.LoginFailed, e);
					}
				} else {
					throw new SystemException(ResponseCodes.PasswordIncorrect, null);
				}
			} else {
				throw new SystemException(ResponseCodes.UserNotExist, null);
			}
		}
		// 第三方平台登陆
		else {
			Authorize authorize = authorizeService.authorizeByOpenAccount(platform, openId);
			if (authorize == null) {
				// 若还未注册，先注册
				User user = userService.addUserByOpenAccount(platform, openId, nickname, headImageUrl);
				try {
					// 添加登录记录
					login = loginService.addLogin(user.getId(), deviceToken);
				} catch (Exception e) {
					// 若添加登录记录失败，则删除原用户信息
					userService.removeUser(user.getId());
					throw new SystemException(ResponseCodes.LoginFailed, e);
				}
			} else {
				// 若已注册，获取用户信息
				User user = userService.userByUid(authorize.getUid());
				try {
					// 添加登录记录
					login = loginService.addLogin(user.getId(), deviceToken);
				} catch (Exception e) {
					throw new SystemException(ResponseCodes.LoginFailed, e);
				}
			}
		}
		if (login != null) {
			// uid, sid, nickname, realname, headImgUrl, email, telephone,
			// foundsCount, lostsCount
			String hql = " select new com.laf.returnEntity.UserSessionResult(u.id, '" + login.getSession() + "', u.nickname, u.realname, u.headImageUrl, u.email, u.telephone, "
					+ " (select count(distinct no.id) from Notice no where no.type = " + NoticeType.Found.value() + " and no.uid = " + login.getUid() + "), "
					+ " (select count(distinct no.id) from Notice no where no.type = " + NoticeType.Lost.value() + " and no.uid = " + login.getUid() + ")) " 
					+ " from User u"
					+ " where u.id = " + login.getUid();
			try {
				List<UserSessionResult> m1ReturnList = find(hql);

				JsonConfig jsonConfig = new JsonConfig();
				jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
				jsonConfig.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
				
				return JSONArray.fromObject(m1ReturnList, jsonConfig);
			} catch (Exception e) {
				// TODO: handle exception
				throw new SystemException(ResponseCodes.LoginFailed, e);
			}
		} else {
			throw new SystemException(ResponseCodes.LoginFailed, null);
		}
	}
}
