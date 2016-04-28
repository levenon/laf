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
 * 用户角色信息
 * @author tangbiao
 *
 */
@Entity
@Table(name = "t_role", catalog = "laf")
public class Role implements IEntity  {

	/**
	 * 角色ID
	 */
	private Integer id;
	/**
	 * 角色名称描述
	 */
	private String name = "";
	/**
	 * 访问优先级
	 */
	private Short priority = 0;
	/**
	 * 角色介绍
	 */
	private String introduction;
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
	
	public Role() {

	}
	
	public Role(Integer id, String name, String introduction) {
		this.id = id;
		this.name = name;
		this.introduction = introduction;
	}

	public Role(Integer id, String name, String introduction, Date createTime, Date modifyTime, Date deleteTime, Boolean isDelete) {
		super();
		this.id = id;
		this.name = name;
		this.introduction = introduction;
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

	@Column(name = "name", nullable = false, length = 128)
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Column(name = "priority", nullable = false)
	public Short getPriority() {
		return priority;
	}

	public void setPriority(Short priority) {
		this.priority = priority;
	}

	@Column(name = "introduction", nullable = false, length = 500)
	public String getIntroduction() {
		return this.introduction;
	}

	public void setIntroduction(String introduction) {
		this.introduction = introduction;
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
