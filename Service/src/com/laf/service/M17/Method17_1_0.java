package com.laf.service.M17;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.common.utils.ContextUtil;
import com.laf.entity.Image;
import com.laf.entity.Location;
import com.laf.entity.Login;
import com.laf.entity.Notice;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.ImageService;
import com.laf.service.common.LocationService;
import com.laf.service.common.NoticeService;
import com.laf.util.DateTimeUtil;
import com.laf.util.JsonUtil;

/**
 * 
 * 创建失物招领
 * 
 * */
@Service
public class Method17_1_0 extends BaseMethod {

	@Autowired
	NoticeService noticeService;

	@Autowired
	LocationService locationService;

	@Autowired
	ImageService imageService;
	
	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return createFoundServer(login, params);
	}

	@Override
	public Map<String, Object> getMethodParams() {

		// 主要位置
		Map<String, Object> location = new HashMap<String, Object>();
		location.put("latitude", String.class);
		location.put("longitude", String.class);
		location.put("name", String.class);
		location.put("address", String.class);
		location.put("aliss", String.class);

		// 图片
		List<Map<String, Object>> images = new ArrayList<Map<String, Object>>();
		Map<String, Object> image = new HashMap<String, Object>();
		image.put("url", String.class);
		image.put("title", String.class);
		images.add(image);

		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("title", String.class);
		parameters.put("cid", String.class);
		parameters.put("happenTime", String.class);
		parameters.put("location", location);
		parameters.put("images", images);

		return parameters;
	}

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	@Override
	public boolean isParamsComplete(JSONObject params) {
		Map<String, Object> map = JsonUtil.readJson2Map(params);
		return StringUtils.isNotBlank((String) map.get("title")) && StringUtils.isNotBlank((String) params.get("cid")) && StringUtils.isNotBlank((String) params.get("happenTime"))
				&& map.get("location") != null && map.get("images") != null;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method17_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return true;
	}

	@SuppressWarnings("unchecked")
	private JSONArray createFoundServer(Login login, JSONObject params) {
		System.out.println("用户ID:" + login.getId() + " 开始创建失物招领");

		// 获取param参数
		String title = (String) params.get("title");
		Integer cid = Integer.parseInt((String) params.get("cid"));
		String happenTime = (String) params.get("happenTime");
		JSONObject JSONMainLocation = (JSONObject) params.get("location");
		JSONArray JSONImages = (JSONArray) params.get("images");

		if (JSONMainLocation != null && JSONMainLocation instanceof JSONObject) {

			Notice notice = noticeService.addNotice(null, title, cid, login.getUid(), null);
			notice.setHappenTime(DateTimeUtil.parse(happenTime));
			notice.setType(NoticeType.Found.value());

			Location mainLocation = (Location) JSONObject.toBean(JSONMainLocation, Location.class);
			if (mainLocation != null) {

				mainLocation.setNoticeId(notice.getId());
				// 添加主要位置
				locationService.save(mainLocation);

				notice.setLocationId(mainLocation.getId());
			}

			if (JSONImages != null && JSONImages instanceof JSONArray && JSONImages.size() > 0) {

				List<Image> images = (List<Image>) JSONArray.toList(JSONImages, new Image(), new JsonConfig());

				for (Image image : images) {

					image.setNoticeId(notice.getId());
					// 添加图片
					imageService.save(image);

					if (notice.getImageId() == null) {
						// 设置默认图片
						notice.setImageId(image.getId());
					}
				}
			}

			noticeService.update(notice);

			JSONObject result = new JSONObject();

			result.put("id", notice.getId());
			result.put("time", new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(notice.getCreateTime()));

			return JSONArray.fromObject(result);

		} else {
			throw new SystemException(ResponseCodes.NoticeNotExsits, null);
		}
	}
}
