package com.laf.service.common;

import java.util.List;

import org.springframework.stereotype.Service;

import com.laf.entity.Region;
import com.laf.service.BaseService;

@Service
public class RegionService extends BaseService {

	public Region regionById(Integer id) {

		Object object = findById(Region.class, id);
		if (object != null && object instanceof Region) {
			return (Region)object;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Region> regionByNoticeId(Integer noticeId) {
		
		return find(" from Region where noticeId = " + noticeId);
	}
	
	public Region addRegion(Integer noticeId, String title) {
		
		Region region = new Region();
		region.setNoticeId(noticeId);
		region.setTitle(title);

		save(region);
		
		return region;
	}
	
	public void removeRegion(Integer id) {

		Region region = new Region();
		region.setId(id);

		delete(region);
	}
	
	public Region updateRegion(Integer id, Integer noticeId, String title) {

		Region region = regionById(id);
		
		if (region != null) {

			region.setNoticeId(noticeId);
			region.setTitle(title);

			update(region);
		}
		return region;
	}
}
