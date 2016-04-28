package com.laf.service.common;

import java.util.List;

import org.springframework.stereotype.Service;

import com.laf.entity.Location;
import com.laf.service.BaseService;

@Service
public class LocationService extends BaseService {

	public Location locationById(Integer id) {

		Object object = findById(Location.class, id);
		if (object != null && object instanceof Location) {
			return (Location)object;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Location> locationByNoticeId(Integer noticeId) {
		
		return find(" from Location where noticeId = " + noticeId);
	}

	@SuppressWarnings("unchecked")
	public List<Location> possibleLocationByNoticeId(Integer noticeId) {
		
		return find(" select lo from Location lo, Notice no where no.id = lo.noticeId and lo.noticeId = " + noticeId + " and no.locationId != lo.id");
	}
	
	public Location addLocation(Integer noticeId, Integer regionId, Double latitude, Double longitude, String name, String address,
			String aliss) {
		
		Location location = new Location();

		location.setNoticeId(noticeId);
		location.setRegionId(regionId);
		location.setLatitude(latitude);
		location.setLongitude(longitude);
		location.setName(name);
		location.setAddress(address);
		location.setAliss(aliss);
		
		save(location);
		
		return location;
	}
	
	public void removeLocation(Integer id) {

		Location location = new Location();
		location.setId(id);

		delete(location);
	}
	
	public Location updateLocation(Integer id, Integer noticeId, Integer regionId, Double latitude, Double longitude, String name, String address,
			String aliss) {

		Location location = locationById(id);
		
		if (location != null) {

			location.setNoticeId(noticeId);
			location.setRegionId(regionId);
			location.setLatitude(latitude);
			location.setLongitude(longitude);
			location.setName(name);
			location.setAddress(address);
			location.setAliss(aliss);
			
			update(location);
		}
		return location;
	}
}
