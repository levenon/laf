package com.laf.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

import com.laf.common.enums.NoticeState;
import com.laf.common.enums.NoticeType;
import com.laf.util.JSONPropertyFilter;

@Entity
@Table(name = "t_notice", catalog = "laf")
public class Notice implements IEntity {

	private Integer id;
	private Integer locationId;
	private String title;
	private Integer cid;
	private Integer uid;
	private Integer imageId;
	private Date happenTime;
	private Date updateTime;
	private Integer state = NoticeState.New.value();
	private Integer type = NoticeType.Lost.value();

	@JSONPropertyFilter
	private Date createTime;

	@JSONPropertyFilter
	private Date modifyTime;

	@JSONPropertyFilter
	private Date deleteTime;

	@JSONPropertyFilter
	private Boolean isDelete = false;

	public Notice() {
		super();
	}

	public Notice(Integer id, Integer locationId, String title, Integer cid, Integer uid, Integer imageId, Date happenTime, Date updateTime, Integer state, Integer type,
			Date createTime, Date modifyTime, Date deleteTime, Boolean isDelete) {
		super();
		this.id = id;
		this.locationId = locationId;
		this.title = title;
		this.cid = cid;
		this.uid = uid;
		this.imageId = imageId;
		this.happenTime = happenTime;
		this.updateTime = updateTime;
		this.state = state;
		this.type = type;
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

	@Column(name = "locationId", length = 20)
	public Integer getLocationId() {
		return locationId;
	}

	public void setLocationId(Integer locationId) {
		this.locationId = locationId;
	}

	@Column(name = "title", length = 500)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column(name = "cid", nullable = false, length = 20)
	public Integer getCid() {
		return cid;
	}

	public void setCid(Integer cid) {
		this.cid = cid;
	}

	@Column(name = "uid", nullable = false, length = 20)
	public Integer getUid() {
		return uid;
	}

	public void setUid(Integer uid) {
		this.uid = uid;
	}

	@Column(name = "imageId", length = 500)
	public Integer getImageId() {
		return imageId;
	}

	public void setImageId(Integer imageId) {
		this.imageId = imageId;
	}

	@DateTimeFormat(iso = ISO.DATE_TIME)
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "happenTime", length = 19)
	public Date getHappenTime() {
		return happenTime;
	}

	public void setHappenTime(Date happenTime) {
		this.happenTime = happenTime;
	}

	@DateTimeFormat(iso = ISO.DATE_TIME)
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "updateTime", length = 19)
	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	@Column(name = "state", length = 5)
	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	@Column(name = "type", length = 10)
	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
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
}
