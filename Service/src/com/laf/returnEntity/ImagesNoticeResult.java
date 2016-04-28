package com.laf.returnEntity;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.laf.entity.Image;

public class ImagesNoticeResult extends NoticeResult {

	private List<Image> images = new ArrayList<Image>();

	public ImagesNoticeResult(Integer id, String title, Integer cid, Integer uid, Date happenTime, Date updateTime, Integer state, Integer type, Date time, Integer locationId,
			Double locationLatitude, Double locationLongitude, String locationName, String locationAddress, String locationAliss, // Location
			Integer imageId, Integer remoteId, String imageTitle, // Image
			String userNickname, String userHeadImageUrl, /* User */
			String categoryName, Integer categoryParentId /* Category */) {
		
		super( id, title, cid, uid, happenTime, updateTime, state, type, time, locationId, locationLatitude, locationLongitude, locationName, locationAddress, locationAliss,
				imageId, remoteId, imageTitle, userNickname, userHeadImageUrl, categoryName, categoryParentId);
	}
	
	public List<Image> getImages() {
		return images;
	}
	public void setImages(List<Image> images) {
		this.images = images;
	}
}
