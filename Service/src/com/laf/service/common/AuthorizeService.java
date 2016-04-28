package com.laf.service.common;

import java.util.List;

import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.common.enums.PlatformType;
import com.laf.entity.Authorize;
import com.laf.service.BaseService;
import com.laf.util.UUIDUtil;

@Service
public class AuthorizeService extends BaseService {

	public Authorize authorizeById(Integer id) {

		Object object = findById(Authorize.class, id);
		if (object != null && object instanceof Authorize) {
			return (Authorize) object;
		}
		return null;
	}

	public Authorize authorizeByAccount(String account) {

		Object object = findObjectByCondition("from Authorize where account ='" + account + "' and isDelete = " + DefaultCode.Code_Zero);
		if (object != null && object instanceof Authorize) {
			return (Authorize) object;
		}
		return null;
	}

	public Authorize authorizeByAccount(PlatformType platformType, String account) {

		Object object = findObjectByCondition("from Authorize where platformId = " + platformType.value() + " and account ='" + account + "' and isDelete = "
				+ DefaultCode.Code_Zero);
		if (object != null && object instanceof Authorize) {
			return (Authorize) object;
		}
		return null;
	}

	public Authorize authorizeByOpenAccount(PlatformType platformType, String openId) {

		Object object = findObjectByCondition("from Authorize where platformId = " + platformType.value() + " and openId = '" + openId + "' and isDelete = " + DefaultCode.Code_Zero);
		if (object != null && object instanceof Authorize) {
			return (Authorize) object;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Authorize> authorizesByUid(Integer uid) {

		return find("from Authorize where uid = " + uid + " and isDelete = " + DefaultCode.Code_Zero);
	}

	public Authorize authorizeByUid(PlatformType platformType, Integer uid) {

		Object object = findObjectByCondition("from Authorize where platformId = " + platformType.value() + " and uid ='" + uid + "' and isDelete = "
				+ DefaultCode.Code_Zero);
		if (object != null && object instanceof Authorize) {
			return (Authorize) object;
		}
		return null;
	}
	
	public Authorize addAuthorize(Integer uid, PlatformType platformType, String account) {

		Authorize authorize = new Authorize();
		authorize.setPlatformId(platformType.value());
		authorize.setAccount(account);
		authorize.setIsDelete(Boolean.FALSE);
		authorize.setUid(uid);

		save(authorize);

		return authorize;
	}

	public Authorize addAuthorizeWithOpenAccount(Integer uid, PlatformType platformType, String platformPrefix, String openId) {

		Authorize authorize = new Authorize();
		authorize.setPlatformId(platformType.value());
		authorize.setOpenId(openId);
		authorize.setAccount(platformPrefix + UUIDUtil.randomShortUUID());
		authorize.setIsDelete(Boolean.FALSE);
		authorize.setUid(uid);

		save(authorize);

		return authorize;
	}

	public void removeAuthorize(Integer id) {

		Authorize authorize = new Authorize();
		authorize.setId(id);

		delete(authorize);
	}

	public void removeAuthorizesByUid(Integer uid) {

		List<Authorize> authorizes = authorizesByUid(uid);

		for (Authorize authorize : authorizes) {
			
			delete(authorize);		
		}
	}

	public Authorize updateAuthorize(Integer id, Integer uid, PlatformType platformType, String openId, String account) {

		Authorize authorize = authorizeById(id);

		if (authorize != null) {

			authorize.setPlatformId(platformType.value());
			authorize.setOpenId(openId);
			authorize.setAccount(account);
			authorize.setIsDelete(Boolean.FALSE);
			authorize.setUid(uid);

			update(authorize);
		}
		return authorize;
	}
}
