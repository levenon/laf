package com.laf.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.laf.util.DateTimeUtil;
import com.laf.util.JSONPropertyFilter;

/**
 * 用户信息
 * @author tangbiao
 *
 */
@Entity
@Table(name="t_user", catalog = "laf")
public class User implements IEntity  {
	/**
	 * 用户ID
	 */
	private Integer id;
	/**
	 * 昵称
	 */
	private String nickname = "用户" + DateTimeUtil.parseShortDate(new Date()) ;
	/**
	 * 真实姓名
	 */
	private String realname;
	/**
	 * 真实姓名
	 */
	private String email;
	/**
	 * 真实姓名
	 */
	private String telephone;
	/**
	 * 头像图片
	 */
	private String headImageUrl;
	/**
	 * 角色ID
	 */
	private Integer roleId;
	/**
	 * 个人介绍
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

	/**
	 * 密码
	 * */
	@JSONPropertyFilter
	private String password;
	
	public User() {
	}
	
	public User(Integer id, String nickname, String headImageUrl, String email,
			String telephone, Integer roleId) {
		super();
		this.id = id;
		this.nickname = nickname;
		this.headImageUrl = headImageUrl;
		this.roleId = roleId;
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

	@Column(name = "nickname", length = 40)
	public String getNickname() {
		return this.nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	@Column(name = "headImageUrl", length = 300)
	public String getHeadImageUrl() {
		return this.headImageUrl;
	}

	public void setHeadImageUrl(String headImageUrl) {
		this.headImageUrl = headImageUrl;
	}

	@Column(name = "roleId", nullable = false, length = 20)
	public Integer getRoleId() {
		return this.roleId;
	}

	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}

	@Column(name = "introduction", length = 1000)
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

	@Column(name = "realname", length = 40)
	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	@Column(name = "email", length = 100)
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Column(name = "telephone", length = 15)
	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	
	@Column(name = "password", length = 128)
	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
}
