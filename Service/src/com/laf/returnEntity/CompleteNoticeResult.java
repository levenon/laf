package com.laf.returnEntity;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.laf.entity.Location;
import com.laf.entity.Region;

public class CompleteNoticeResult extends ImagesNoticeResult {

	private List<Location> locations = new ArrayList<Location>();
	private List<Region> regions = new ArrayList<Region>();

	public CompleteNoticeResult(Integer id, String title, Integer cid, Integer uid, Date happenTime, Date updateTime, Integer state, Integer type, Date time, Integer locationId,
			Double locationLatitude, Double locationLongitude, String locationName, String locationAddress, String locationAliss, // Location
			Integer imageId, Integer remoteId, String imageTitle, // Image
			String userNickname, String userHeadImageUrl, /* User */
			String categoryName, Integer categoryParentId /* Category */) {
		
		super( id, title, cid, uid, happenTime, updateTime, state, type, time, locationId, locationLatitude, locationLongitude, locationName, locationAddress, locationAliss,
				imageId, remoteId, imageTitle, userNickname, userHeadImageUrl, categoryName, categoryParentId);
	}

	public List<Location> getLocations() {
		return locations;
	}

	public void setLocations(List<Location> locations) {
		this.locations = locations;
	}

	public List<Region> getRegions() {
		return regions;
	}

	public void setRegions(List<Region> regions) {
		this.regions = regions;
	}
}
