package com.laf.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.laf.util.JSONPropertyFilter;

@Entity
@Table(name = "t_location", catalog = "laf")
public class Location implements IEntity {

	private Integer id;
	private Integer noticeId;
	private Integer regionId;
	private Double latitude;
	private Double longitude;
	private String name;
	private String address;
	private String aliss;
	@JSONPropertyFilter
	private Date createTime;
	@JSONPropertyFilter
	private Date modifyTime;
	@JSONPropertyFilter
	private Date deleteTime;
	@JSONPropertyFilter
	private Boolean isDelete = false;

	public Location() {
		super();
	}
	public Location(Integer id, Integer noticeId, Integer regionId,
			Double latitude, Double longitude, String name, String address,
			String aliss, Date createTime, Date modifyTime, Date deleteTime,
			Boolean isDelete) {
		super();
		this.id = id;
		this.noticeId = noticeId;
		this.regionId = regionId;
		this.latitude = latitude;
		this.longitude = longitude;
		this.name = name;
		this.address = address;
		this.aliss = aliss;
		this.createTime = createTime;
		this.modifyTime = modifyTime;
		this.deleteTime = deleteTime;
		this.isDelete = isDelete;
	}
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false, length = 20)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	@Column(name = "noticeId", length = 20)
	public Integer getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(Integer noticeId) {
		this.noticeId = noticeId;
	}

	@Column(name = "regionId", length = 20)
	public Integer getRegionId() {
		return regionId;
	}
	public void setRegionId(Integer regionId) {
		this.regionId = regionId;
	}

	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "createTime", length = 19)
	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "modifyTime", length = 19)
	public Date getModifyTime() {
		return this.modifyTime;
	}

	public void setModifyTime(Date modifyTime) {
		this.modifyTime = modifyTime;
	}

	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "deleteTime", length = 19)
	public Date getDeleteTime() {
		return this.deleteTime;
	}

	public void setDeleteTime(Date deleteTime) {
		this.deleteTime = deleteTime;
	}

	
	@Column(name = "isDelete", nullable = false)
	public Boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(Boolean isDelete) {
		this.isDelete = isDelete;
	}

	@Column(name = "latitude", length = 20)
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	@Column(name = "longitude", length = 20)
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
	
	@Column(name = "name", length = 200)
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@Column(name = "address", length = 500)
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}

	@Column(name = "aliss", length = 200)
	public String getAliss() {
		return aliss;
	}
	public void setAliss(String aliss) {
		this.aliss = aliss;
	}
	
}
