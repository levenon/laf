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
@Table(name = "t_push", catalog = "laf")
public class Push implements IEntity  {

	private Integer id;
	private String deviceToken = "";
	private Integer loginId;
	private Short type = 0;
	private Short deviceType = 0;
	private String centent;
	private String soundStyle = "default";
	private Integer edgeNumber = 0;
	private Boolean contentAvailable = false;
	private Short msgCategory = 0;
	private Short msgSubCategory = 0;
	private Boolean needLogin = false;
	private Boolean valid = false;
	@JSONPropertyFilter
	private Date createTime;
	@JSONPropertyFilter
	private Date modifyTime;
	@JSONPropertyFilter
	private Date deleteTime;
	@JSONPropertyFilter
	private Boolean isDelete = false;
	
	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false, length = 20)
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "deviceToken", nullable = false, length = 100)
	public String getDeviceToken() {
		return this.deviceToken;
	}

	public void setDeviceToken(String deviceToken) {
		this.deviceToken = deviceToken;
	}

	@Column(name = "loginId", nullable = false, length = 50)
	public Integer getLoginId() {
		return this.loginId;
	}

	public void setLoginId(Integer loginId) {
		this.loginId = loginId;
	}

	@Column(name = "type", nullable = false)
	public Short getType() {
		return this.type;
	}

	public void setType(Short type) {
		this.type = type;
	}

	@Column(name = "deviceType", nullable = false)
	public Short getDeviceType() {
		return this.deviceType;
	}

	public void setDeviceType(Short deviceType) {
		this.deviceType = deviceType;
	}

	@Column(name = "msgCategory", nullable = false)
	public Short getMsgCategory() {
		return this.msgCategory;
	}

	public void setMsgCategory(Short msgCategory) {
		this.msgCategory = msgCategory;
	}

	@Column(name = "msgSubCategory", nullable = false)
	public Short getMsgSubCategory() {
		return this.msgSubCategory;
	}

	public void setMsgSubCategory(Short msgSubCategory) {
		this.msgSubCategory = msgSubCategory;
	}

	@Column(name = "needLogin", nullable = false)
	public Boolean getNeedLogin() {
		return this.needLogin;
	}

	public void setNeedLogin(Boolean needLogin) {
		this.needLogin = needLogin;
	}

	@Column(name = "valid", nullable = false)
	public Boolean getValid() {
		return this.valid;
	}

	public void setValid(Boolean valid) {
		this.valid = valid;
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

	@Column(name = "soundStyle", nullable = false, length = 3)
	public String getSoundStyle() {
		return soundStyle;
	}

	public void setSoundStyle(String soundStyle) {
		this.soundStyle = soundStyle;
	}

	@Column(name = "edgeNumber", nullable = false, length = 5)
	public Integer getEdgeNumber() {
		return edgeNumber;
	}

	public void setEdgeNumber(Integer edgeNumber) {
		this.edgeNumber = edgeNumber;
	}

	@Column(name = "contentAvailable", nullable = false, length = 1)
	public Boolean getContentAvailable() {
		return contentAvailable;
	}

	public void setContentAvailable(Boolean contentAvailable) {
		this.contentAvailable = contentAvailable;
	}

	@Column(name = "centent", length = 5000)
	public String getCentent() {
		return centent;
	}

	public void setCentent(String centent) {
		this.centent = centent;
	}
}
