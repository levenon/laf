package com.laf.service.M10;

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

import com.laf.common.constants.DefaultCode;
import com.laf.common.enums.NoticeType;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Category;
import com.laf.entity.Login;
import com.laf.returnEntity.NoticeResult;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.CategoryService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;
import com.laf.util.JsonUtil;

/**
 * 
 * 获取用户的所有公告
 * 
 * */
@Service
public class Method10_1_0 extends BaseMethod {

	@Autowired
	CategoryService categoryService;

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return fetchUserNoticesServer(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("noticeType", String.class);
		parameters.put("cid", String.class);
		parameters.put("page", String.class);
		parameters.put("size", String.class);

		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {

		Map<String, Object> map = JsonUtil.readJson2Map(params);

		return StringUtils.isNotBlank((String) map.get("noticeType"));
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method10_1_0");
		}

		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	@SuppressWarnings("unchecked")
	private JSONArray fetchUserNoticesServer(Login login, JSONObject params) {

		System.out.println("用户ID:" + login.getId() + " 获取用户所有公告");

		// 获取param参数
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		NoticeType noticeType = NoticeType.values()[Integer.parseInt((String) map.get("noticeType"))];
		Integer categoryId = (map.get("cid") != null && ((String) map.get("cid")).length() != 0) ? Integer.parseInt((String) map.get("cid")) : null;
		Integer page = Math.max(Integer.parseInt((String) map.get("page")), DefaultCode.Code_Qurey_Default_Page);
		Integer size = Math.max(Integer.parseInt((String) map.get("size")), DefaultCode.Code_Qurey_Default_Size);

		String hql = " select new com.laf.returnEntity.NoticeResult( no.id, no.title, no.cid, no.uid, no.happenTime, no.updateTime, no.state, no.type, no.createTime, "
				+ " lo.id, lo.latitude, lo.longitude, lo.name, lo.address, lo.aliss, im.id, im.remoteId, lo.name, us.nickname, us.headImageUrl, ca.name, ca.parentId ) "
				+ " from Notice no, Image im, User us, Location lo, Category ca " 
				+ " where no.cid = ca.id and no.imageId = im.id and us.id = no.uid and lo.id = no.locationId and no.uid = " + login.getUid() + " and no.isDelete = " + DefaultCode.Code_Zero;
		
		if (categoryId != null) {
			Category category = categoryService.categoryById(categoryId);
			if (category != null) {
				hql += " and no.cid = " + categoryId;
			} else {
				throw new SystemException(ResponseCodes.CategoryNotExsits, null);
			}
		}
		if (noticeType != NoticeType.All) {
			hql += " and no.type = " + noticeType.value();
		}
		hql += " order by no.createTime desc";

		List<NoticeResult> results = findListByPage(hql, page, size);

		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
		jsonConfig.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor());

		return JSONArray.fromObject(results, jsonConfig);
	}
}
