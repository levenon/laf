package com.laf.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.laf.common.enums.NoticeState;
import com.laf.util.JSONPropertyFilter;

@Entity
@Table(name = "t_noticeStateChange", catalog = "laf")
public class NoticeStateChange implements IEntity {

	private Integer id;
	private Integer noticeId;
	private Integer uid;
	private Integer state = NoticeState.New.value();

	@JSONPropertyFilter
	private Date createTime;

	@JSONPropertyFilter
	private Date modifyTime;

	@JSONPropertyFilter
	private Date deleteTime;

	@JSONPropertyFilter
	private Boolean isDelete = false;

	public NoticeStateChange() {
		super();
	}

	public NoticeStateChange(Integer id, Integer noticeId, Integer uid, Integer state, Date createTime, Date modifyTime, Date deleteTime, Boolean isDelete) {
		super();
		this.id = id;
		this.noticeId = noticeId;
		this.uid = uid;
		this.state = state;
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

	@Column(name = "uid", nullable = false, length = 20)
	public Integer getUid() {
		return uid;
	}

	public void setUid(Integer uid) {
		this.uid = uid;
	}

	@Column(name = "state", length = 5)
	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
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
