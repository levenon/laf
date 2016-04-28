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
@Table(name = "t_requestLog", catalog = "laf")
public class RequestLog implements IEntity  {

	private Integer id;
	private String method = "";
	private String version = "1.0";
	private String params;
	private Date time;
	private String code = "200";
	private String device;

	@JSONPropertyFilter
	private Date createTime;

	@JSONPropertyFilter
	private Date modifyTime;

	@JSONPropertyFilter
	private Date deleteTime;

	@JSONPropertyFilter
	private Boolean isDelete = false;
	
	
	public RequestLog() {
		super();
	}

	public RequestLog(Integer id, String method, String version, String params,
			Date time, String code, String device, Date createTime, Date modifyTime,
			Date deleteTime, Boolean isDelete) {
		super();
		this.id = id;
		this.method = method;
		this.version = version;
		this.params = params;
		this.time = time;
		this.code = code;
		this.device = device;
		this.createTime = createTime;
		this.modifyTime = modifyTime;
		this.deleteTime = deleteTime;
		this.isDelete = isDelete;
	}

	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false, length = 20)
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "method", nullable = false, length = 20)
	public String getMethod() {
		return this.method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	@Column(name = "version", nullable = false, length = 20)
	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	@Column(name = "params", length = 1000)
	public String getParams() {
		return this.params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "time", nullable = false, length = 19)
	public Date getTime() {
		return this.time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	@Column(name = "code", nullable = false, length = 19)
	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	@Column(name = "device", nullable = false, length = 200)
	public String getDevice() {
		return this.device;
	}

	public void setDevice(String device) {
		this.device = device;
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
