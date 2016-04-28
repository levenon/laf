package com.laf.returnEntity;

public class UserSessionResult {
	/**
	 * 用户ID
	 */
	private Integer id;
	/**
	 * 登录唯一标识
	 */
	private String sid;
	/**
	 * 昵称
	 */
	private String nickname;
	/**
	 * 真实信命
	 */
	private String realname;
	/**
	 * 头像地址
	 */
	private String headImageUrl;
	/**
	 * 邮箱
	 */
	private String email;
	/**
	 * 电话
	 */
	private String telephone;
	/**
	 * 发现数量
	 */
	private Long foundsCount;
	/**
	 * 丢失数量
	 */
	private Long lostsCount;
	
	public UserSessionResult() {
	}

	public UserSessionResult(Integer id, String sid, String nickname, String realname, String headImageUrl, String email, String telephone,
			Long foundsCount, Long lostsCount) {
		this.id = id;
		this.sid = sid;
		this.nickname = nickname;
		this.realname = realname;
		this.headImageUrl = headImageUrl;
		this.email = email;
		this.telephone = telephone;
		this.foundsCount = foundsCount;
		this.lostsCount = lostsCount;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public String getHeadImageUrl() {
		return headImageUrl;
	}

	public void setHeadImageUrl(String headImageUrl) {
		this.headImageUrl = headImageUrl;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public Long getFoundsCount() {
		return foundsCount;
	}

	public void setFoundsCount(Long foundsCount) {
		this.foundsCount = foundsCount;
	}

	public Long getLostsCount() {
		return lostsCount;
	}

	public void setLostsCount(Long lostsCount) {
		this.lostsCount = lostsCount;
	}
}
