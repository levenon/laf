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

/**
 * 用户权限信息
 * @author tangbiao
 *
 */
@Entity
@Table(name = "t_permission", catalog = "laf")
public class Permission implements IEntity  {
	/**
	 * 权限ID
	 */
	private Integer id;
	/**
	 * 用户ID
	 */
	private Integer uid;
	
	/**
	 * 权限
	 */
	private Integer permission;
	
	/**
	 * 创建时间
	 */
	@JSONPropertyFilter
	private Date createTime;
	/**
	 * 修改时间
	 */
	@JSONPropertyFilter
	private Date modifyTime;
	/**
	 * 删除时间
	 */
	@JSONPropertyFilter
	private Date deleteTime;
	/**
	 * 删除状态
	 */
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

	@Column(name = "uid", nullable = false, length = 20)
	public Integer getUid() {
		return uid;
	}
	
	public void setUid(Integer uid) {
		this.uid = uid;
	}

	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "createTime", length = 19)
	public Date getCreateTime() {
		return createTime;
	}
	
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "modifyTime", length = 19)
	public Date getModifyTime() {
		return modifyTime;
	}
	
	public void setModifyTime(Date modifyTime) {
		this.modifyTime = modifyTime;
	}

	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "deleteTime", length = 19)
	public Date getDeleteTime() {
		return deleteTime;
	}
	
	public void setDeleteTime(Date deleteTime) {
		this.deleteTime = deleteTime;
	}

	
	@Column(name = "isDelete", nullable = false)
	public Boolean getIsDelete() {
		return isDelete;
	}
	
	public void setIsDelete(Boolean isDelete) {
		this.isDelete = isDelete;
	}

	@Column(name = "permission", nullable = false, length = 5)
	public Integer getPermission() {
		return permission;
	}

	public void setPermission(Integer permission) {
		this.permission = permission;
	}
	
}
