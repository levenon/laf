package com.laf.returnEntity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import com.laf.common.constants.DefaultCode;
import com.laf.entity.Category;
import com.laf.entity.Image;
import com.laf.entity.Location;
import com.laf.entity.User;

public class NoticeResult {

	private Integer id;
	private String title;
	private Integer cid;
	private Integer uid;
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date happenTime;
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date updateTime;
	private Integer state;
	private Integer type;
	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date time;
	private String url;

	private Image image = new Image();
	private Location location = new Location();
	private User user = new User();
	private Category category = new Category();

	public NoticeResult() {
	}
	
	public NoticeResult(Integer id, String title, Integer cid, Integer uid, Date happenTime, Date updateTime, Integer state, Integer type, Date time, Integer locationId,
			Double locationLatitude, Double locationLongitude, String locationName, String locationAddress, String locationAliss, // Location
			Integer imageId, Integer remoteId, String imageTitle, // Image
			String userNickname, String userHeadImageUrl, /* User */
			String categoryName, Integer categoryParentId /* Category */) {
		this.id = id;
		this.title = title;
		this.cid = cid;
		this.uid = uid;
		this.happenTime = happenTime;
		this.updateTime = updateTime;
		this.state = state;
		this.type = type;
		this.time = time;
		this.url = DefaultCode.Notice_Web_Domain_Url + id;

		this.image.setId(imageId);
		this.image.setRemoteId(remoteId);
		this.image.setTitle(imageTitle);

		this.location.setId(locationId);
		this.location.setLatitude(locationLatitude);
		this.location.setLongitude(locationLongitude);
		this.location.setName(locationName);
		this.location.setAddress(locationAddress);
		this.location.setAliss(locationAliss);

		this.user.setId(uid);
		this.user.setNickname(userNickname);
		this.user.setHeadImageUrl(userHeadImageUrl);

		this.category.setId(cid);
		this.category.setName(categoryName);
		this.category.setParentId(categoryParentId);
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public Date getHappenTime() {
		return happenTime;
	}

	public void setHappenTime(Date happenTime) {
		this.happenTime = happenTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	public Integer getCid() {
		return cid;
	}

	public void setCid(Integer cid) {
		this.cid = cid;
	}

	public Integer getUid() {
		return uid;
	}

	public void setUid(Integer uid) {
		this.uid = uid;
	}

	public Image getImage() {
		return image;
	}

	public void setImage(Image image) {
		this.image = image;
	}

	public Location getLocation() {
		return location;
	}

	public void setLocation(Location location) {
		this.location = location;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}
}
