package com.laf.service.common;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.common.enums.PlatformType;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.entity.Authorize;
import com.laf.entity.Platform;
import com.laf.entity.Role;
import com.laf.entity.User;
import com.laf.service.BaseService;
import com.laf.util.MD5Util;

@Service
public class UserService extends BaseService {

	@Autowired
	private AuthorizeService authorizeService;

	@Autowired
	private PlatformService platformService;

	@Autowired
	RoleService roleService;

	public User userByUid(Integer uid) {
		Object object = findById(User.class, uid);
		if (object != null && object instanceof User) {
			return (User) object;
		}
		return null;
	}

	public User userByAuthorizeId(Integer authorizeId) {

		Authorize authorize = authorizeService.authorizeById(authorizeId);
		if (authorize != null) {
			return userByUid(authorize.getUid());
		}
		return null;
	}

	public User userByAccount(PlatformType platformType, String account) {

		Authorize authorize = authorizeService.authorizeByAccount(platformType, account);
		if (authorize != null) {
			return userByUid(authorize.getUid());
		}
		return null;
	}

	public User userByOpenAccount(PlatformType platformType, String openId) {

		Authorize authorize = authorizeService.authorizeByOpenAccount(platformType, openId);
		if (authorize != null) {
			return userByUid(authorize.getUid());
		}
		return null;
	}

	public User addUserByOpenAccount(PlatformType platformType, String openId, String nickname, String headImageUrl) throws Exception {

		Platform platform = platformService.platformById(platformType.value());
		if (platform != null) {
			Authorize authorize = authorizeService.authorizeByOpenAccount(platformType, openId);
			if (authorize == null) {
				List<Role> roles = roleService.allRoles();
				Role role = null;
				if (roles != null && roles.size() >= DefaultCode.Code_One) {
					role = roles.get(0);
				} else {
					throw new SystemException(ResponseCodes.RoleNotFound, null);
				}
				User user = new User();
				user.setRoleId(role.getId());
				user.setNickname(nickname);
				user.setHeadImageUrl(headImageUrl);
				user.setIsDelete(DefaultCode.Code_False);
				user.setPassword(MD5Util.getMD5Str(UUID.randomUUID().toString(), "utf-8"));
				save(user);
				try {
					authorizeService.addAuthorizeWithOpenAccount(user.getId(), platformType, platform.getPrefix(), openId);
					return user;
				} catch (Exception e) {
					delete(user);
					throw new SystemException(ResponseCodes.RegisterFailed, e);
				}
			} else {
				throw new SystemException(ResponseCodes.TelephoneOrEmailExist, null);
			}
		} else {
			throw new SystemException(ResponseCodes.ErrorPlatformType, null);
		}
	}

	public User addUserBy(PlatformType platformType, String account, String password) throws Exception {

		Platform platform = platformService.platformById(platformType.value());
		if (platform != null) {
			Authorize authorize = authorizeService.authorizeByAccount(platformType, account);
			if (authorize == null) {
				List<Role> list = roleService.allRoles();
				Role role = null;
				if (list != null && list.size() != DefaultCode.Code_One) {
					role = list.get(0);
				} else {
					throw new SystemException(ResponseCodes.RoleNotFound, null);
				}
				User user = new User();
				user.setRoleId(role.getId());
				user.setPassword(password);
				if (platformType == PlatformType.Email) {
					user.setEmail(account);
				} else if (platformType == PlatformType.Telephone) {
					user.setTelephone(account);
				}
				save(user);
				return user;
			} else {
				throw new SystemException(ResponseCodes.TelephoneOrEmailExist, null);
			}
		} else {
			throw new SystemException(ResponseCodes.ErrorPlatformType, null);
		}
	}

	public void removeUser(Integer id) {

		authorizeService.removeAuthorizesByUid(id);
		
		User user = new User();
		user.setId(id);

		delete(user);
	}

	public User updateUser(Integer id, String nickname, String realname, String headImageUrl, String telephone, String email) {

		User user = userByUid(id);

		if (user != null) {

			if (headImageUrl != null) {
				user.setHeadImageUrl(headImageUrl);
			}

			if (nickname != null) {
				user.setNickname(nickname);
			}

			if (realname != null) {
				user.setRealname(realname);
			}

			if (telephone != null) {
				user.setTelephone(telephone);
			}

			if (email != null) {
				user.setEmail(email);
			}
			update(user);
		} else {
			throw new SystemException(ResponseCodes.UserNotExist, null);
		}
		return user;
	}
}
