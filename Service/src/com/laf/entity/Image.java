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
@Table(name = "t_image", catalog = "laf")
public class Image implements IEntity {

	private Integer id;
	private Integer noticeId;
	private Integer remoteId;
	private Integer remoteBinderId;
	private String title;
	@JSONPropertyFilter
	private Date createTime;
	@JSONPropertyFilter
	private Date modifyTime;
	@JSONPropertyFilter
	private Date deleteTime;
	@JSONPropertyFilter
	private Boolean isDelete = false;
	
	public Image() {
		super();
	}

	public Image(Integer id, Integer noticeId, Integer remoteId, Integer remoteBinderId, String title,
			Date createTime, Date modifyTime, Date deleteTime, Boolean isDelete) {
		super();
		this.id = id;
		this.noticeId = noticeId;
		this.remoteId = remoteId;
		this.remoteBinderId = remoteBinderId;
		this.title = title;
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

	@Column(name = "noticeId", nullable = false, length = 20)
	public Integer getNoticeId() {
		return noticeId;
	}
	public void setNoticeId(Integer noticeId) {
		this.noticeId = noticeId;
	}

	@Column(name = "remoteId", nullable = false, length = 20)
	public Integer getRemoteId() {
		return remoteId;
	}
	public void setRemoteId(Integer remoteId) {
		this.remoteId = remoteId;
	}

	@Column(name = "remoteBinderId", length = 20)
	public Integer getRemoteBinderId() {
		return remoteBinderId;
	}
	public void setRemoteBinderId(Integer remoteBinderId) {
		this.remoteBinderId = remoteBinderId;
	}
	
	@Column(name = "title", length = 500)
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
