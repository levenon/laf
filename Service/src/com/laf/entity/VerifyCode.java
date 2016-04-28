package com.laf.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.laf.common.enums.PlatformType;
import com.laf.util.JSONPropertyFilter;

@Entity
@Table(name = "t_verifyCode", catalog = "laf")
public class VerifyCode implements IEntity {

	private Integer id;
	private String code = "";
	private Boolean valid = false;
	private Integer secretKeyId;
	private Integer type = PlatformType.Normal.value();
	private String account;

	@JSONPropertyFilter
	private Date createTime;

	@JSONPropertyFilter
	private Date modifyTime;

	@JSONPropertyFilter
	private Date deleteTime;

	@JSONPropertyFilter
	private Boolean isDelete = false;

	public VerifyCode() {
		super();
	}

	public VerifyCode(Integer id, Integer type, String account, String code, Boolean valid, Integer secretKeyId) {
		super();
		this.id = id;
		this.code = code;
		this.valid = valid;
		this.secretKeyId = secretKeyId;
		this.type = type;
		this.account = account;
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

	@Column(name = "type", nullable = false, length = 4)
	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	@Column(name = "account", nullable = false, length = 100)
	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	@Column(name = "code", nullable = false)
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	@Column(name = "valid", nullable = false)
	public Boolean getValid() {
		return valid;
	}

	public void setValid(Boolean valid) {
		this.valid = valid;
	}

	@Column(name = "secretId", nullable = false, length = 20)
	public Integer getSecretKeyId() {
		return secretKeyId;
	}

	public void setSecretKeyId(Integer secretKeyId) {
		this.secretKeyId = secretKeyId;
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
