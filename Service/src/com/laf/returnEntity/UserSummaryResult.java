package com.laf.returnEntity;

public class UserSummaryResult {

	/**
	 * 用户ID
	 */
	private Integer uid;
	/**
	 * 昵称
	 */
	private String nickname;
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
	private String headImgUrl;

	public UserSummaryResult() {
	}

	public UserSummaryResult(Integer uid, String nickname, String realname, String email, String telephone, String headImgUrl) {
		this.uid = uid;
		this.nickname = nickname;
		this.realname = realname;
		this.email = email;
		this.telephone = telephone;
		this.headImgUrl = headImgUrl;
	}


	public Integer getUid() {
		return uid;
	}


	public void setUid(Integer uid) {
		this.uid = uid;
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


	public String getHeadImgUrl() {
		return headImgUrl;
	}


	public void setHeadImgUrl(String headImgUrl) {
		this.headImgUrl = headImgUrl;
	}
}
