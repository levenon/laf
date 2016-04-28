package com.laf.service.common;

import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.laf.common.constants.DefaultCode;
import com.laf.entity.Login;
import com.laf.service.BaseService;
import com.laf.util.MD5Util;

@Service
@SuppressWarnings({ "unchecked" })
public class LoginService extends BaseService {

	public Login loginById(Integer id) {
		Object object = findById(Login.class, id);
		if (object != null && object instanceof Login) {
			return (Login) object;
		}
		return null;
	}

	public Login loginBySession(String session) {

		Object object = findObjectByCondition("from Login where session = '" + session + "' and isDelete = " + DefaultCode.Code_Zero);
		if (object != null && object instanceof Login) {
			return (Login) object;
		}
		return null;
	}

	@SuppressWarnings("rawtypes")
	public List allLoginById(Integer uid, int valid) {
		return find("from Login where uid = " + uid + " and valid = " + valid + " and isDelete = " + DefaultCode.Code_Zero + " order by createTime  desc");
	}

	@SuppressWarnings("rawtypes")
	public List allLoginOnDevice(String deviceToken, int valid) {
		return find("from Login where deviceToken = '" + deviceToken + "' and valid = " + valid + " and isDelete = " + DefaultCode.Code_Zero + " order by createTime  desc");
	}

	@SuppressWarnings("rawtypes")
	public List allLoginOnDeviceOrById(Integer uid, String deviceToken, int valid) {
		return find("from Login where (uid = " + uid + " or deviceToken = '" + deviceToken + "') and valid = " + valid + " and isDelete = " + DefaultCode.Code_Zero
				+ " order by createTime  desc");
	}

	public Login addLogin(Integer uid, String deviceToken) {

		List<Login> list = allLoginOnDeviceOrById(uid, deviceToken, DefaultCode.Code_One);
		// 更新登录表状态
		// 有登录记录
		if (list != null && list.size() != DefaultCode.Code_Zero) {
			for (int nIndex = 0; nIndex < list.size(); nIndex++) {
				Login exsitLogin = list.get(nIndex);
				exsitLogin.setValid(DefaultCode.Code_False);
				exsitLogin.setLogoutTime(new Date());
				update(exsitLogin);
			}
		}
		Login login = new Login();
		login.setUid(uid);
		login.setDeviceToken(deviceToken);
		login.setIsDelete(DefaultCode.Code_False);
		login.setValid(DefaultCode.Code_True);
		login.setSession(MD5Util.getMD5Str(UUID.randomUUID().toString(), "utf-8"));

		save(login);

		return login;
	}

	public void removeLogin(Integer id) {

		Login login = new Login();
		login.setId(id);

		delete(login);
	}

	public Login updateLogin(Integer id, Integer uid, String deviceToken) {

		Login login = loginById(id);

		if (login != null) {

			login.setUid(uid);
			login.setDeviceToken(deviceToken);

			update(login);
		}
		return login;
	}

	@Transactional
	public void save(Login login) {
		login.setLoginTime(new Date());

		super.save(login);
	}
}
