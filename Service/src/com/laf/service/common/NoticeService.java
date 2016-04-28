package com.laf.service.common;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.entity.Image;
import com.laf.entity.Location;
import com.laf.entity.Notice;
import com.laf.entity.Region;
import com.laf.returnEntity.ImagesNoticeResult;
import com.laf.returnEntity.CompleteNoticeResult;
import com.laf.service.BaseService;

@Service
public class NoticeService extends BaseService {
	
	@Autowired
	LocationService locationService;
	
	@Autowired
	RegionService regionService;
	
	@Autowired
	ImageService imageService;
	
	public Notice noticeById(Integer id) {
		Object object = findById(Notice.class, id);
		if (object != null && object instanceof Notice) {
			return (Notice)object;
		}
		return null;
	}
	
	public ImagesNoticeResult imagesNoticeById(Integer id) {
		
		String hql = "select new com.laf.returnEntity.ImagesNoticeResult( no.id, no.title, no.cid, no.uid, no.happenTime, no.updateTime, no.state, no.type, no.createTime, "
				+ "lo.id, lo.latitude, lo.longitude, lo.name, lo.address, lo.aliss, " + "im.id, im.remoteId, im.title," + "us.nickname, us.headImageUrl," + " ca.name, ca.parentId ) "
				+ "from Notice no, Image im, User us, Location lo, Category ca " 
				+ "where no.imageId = im.id and no.cid = ca.id and us.id = no.uid and lo.id = no.locationId and no.id = " + id;

		ImagesNoticeResult imagesNoticeResult = (ImagesNoticeResult) findObjectByCondition(hql);
		List<Image> images = imageService.imagesByNoticeId(id);

		imagesNoticeResult.setImages(images);
		
		return imagesNoticeResult;
	}

	public CompleteNoticeResult completeNoticeDetailById(Integer id) {
		
		String hql = " select new com.laf.returnEntity.CompleteNoticeResult( no.id, no.title, no.cid, no.uid, no.happenTime, no.updateTime, no.state, no.type, no.createTime, "
				+ " lo.id, lo.latitude, lo.longitude, lo.name, lo.address, lo.aliss, " + "im.id, im.remoteId, im.title," + "us.nickname, us.headImageUrl, ca.name, ca.parentId ) " 
				+ " from Notice no, Image im, User us, Location lo, Category ca "
				+ " where no.imageId = im.id and no.cid = ca.id and us.id = no.uid and lo.id = no.locationId and no.id = " + id;

		CompleteNoticeResult completeNoticeResult = (CompleteNoticeResult) findObjectByCondition(hql);

		List<Location> locations = locationService.possibleLocationByNoticeId(id);
		List<Region> regions = regionService.regionByNoticeId(id);
		List<Image> images = imageService.imagesByNoticeId(id);

		completeNoticeResult.setLocations(locations);
		completeNoticeResult.setRegions(regions);
		completeNoticeResult.setImages(images);
		
		return completeNoticeResult;
	}
	
	public Notice addNotice(Integer locationId, String title, Integer cid, Integer uid, Integer imageId) {
		
		Notice notice = new Notice();
		notice.setLocationId(locationId);
		notice.setTitle(title);
		notice.setUid(uid);
		notice.setCid(cid);
		notice.setImageId(imageId);

		save(notice);
		
		return notice;
	}
	
	public void removeNotice(Integer id) {

		Notice notice = new Notice();
		notice.setId(id);

		delete(notice);
	}
	
	public Notice updateNotice(Integer id, Integer locationId, String title, Integer cid, Integer uid, Integer imageId) {

		Notice notice = noticeById(id);
		
		if (notice != null) {

			notice.setLocationId(locationId);
			notice.setTitle(title);
			notice.setUid(uid);
			notice.setImageId(imageId);

			update(notice);
		}
		return notice;
	}
}
