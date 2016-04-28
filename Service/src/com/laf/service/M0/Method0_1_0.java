package com.laf.service.M0;

import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.enums.DeviceType;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Device;
import com.laf.entity.Login;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.DeviceService;
import com.laf.service.common.LoginService;
import com.laf.util.JsonUtil;

/**
 * 
 * 应用初始化
 * 
 * */

@Service
public class Method0_1_0 extends BaseMethod {

	@Autowired
	DeviceService deviceService;

	@Autowired
	LoginService loginService;
	
	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	// 参数完整性校验
	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		// 验证必填参数是否为空
		return StringUtils.isNotBlank((String) map.get("deviceType")) && StringUtils.isNotBlank((String) map.get("deviceNumber"))
				&& StringUtils.isNotBlank((String) map.get("deviceToken")) && StringUtils.isNotBlank((String) map.get("appVersion"))
				&& StringUtils.isNotBlank((String) map.get("bundleVersion")) && StringUtils.isNotBlank((String) map.get("systemVersion"))
				&& StringUtils.isNotBlank((String) map.get("deviceName")) && StringUtils.isNotBlank((String) map.get("deviceModel"));
	}

	// 获取参数列表
	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("deviceType", String.class);
		parameters.put("deviceNumber", String.class);
		parameters.put("deviceToken", String.class);
		parameters.put("appVersion", String.class);
		parameters.put("bundleVersion", String.class);
		parameters.put("systemVersion", String.class);
		parameters.put("deviceName", String.class);
		parameters.put("deviceModel", String.class);
		parameters.put("uid", String.class);

		return parameters;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method0_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) throws Exception {
		return initialApplicationServer(params);
	}

	// 登录逻辑处理
	public JSONArray initialApplicationServer(JSONObject params) throws Exception {

		Map<String, Object> map = JsonUtil.readJson2Map(params);
		DeviceType deviceType = DeviceType.values()[Integer.parseInt((String) map.get("deviceType"))];
		String deviceNumber = (String) map.get("deviceNumber");
		String deviceToken = (String) map.get("deviceToken");
		String appVersion = (String) map.get("appVersion");
		String bundleVersion = (String) map.get("bundleVersion");
		String systemVersion = (String) map.get("systemVersion");
		String deviceName = (String) map.get("deviceName");
		String deviceModel = (String) map.get("deviceModel");
		String session = (String) map.get("sid");

		System.out.println("开始初始化应用 DeviceType:" + deviceType + " deviceNumber:" + deviceNumber + " deviceToken:" + deviceToken + " appVersion:" + appVersion + " bundleVersion:" + bundleVersion
				+ " systemVersion:" + systemVersion + " deviceName:" + deviceName + " deviceModel:" + deviceModel);

		Device device = deviceService.deviceByDeviceNumber(deviceNumber);
		if (device != null) {
			deviceService.updateDevice(device.getId(), deviceType, deviceNumber, deviceToken, appVersion, bundleVersion, systemVersion, deviceName, deviceModel);
		} else {
			deviceService.addDevice(deviceType, deviceNumber, deviceToken, appVersion, bundleVersion, systemVersion, deviceName, deviceModel);
		}
		
		if (session != null) {			
			Login login = loginService.loginBySession(session);
			if (login == null) {
				throw new SystemException(ResponseCodes.Unlogin, null);
			}
			else if (!login.getValid()){
				throw new SystemException(ResponseCodes.LoginInvalid, null);
			}
		}
		return new JSONArray();
	}
}
