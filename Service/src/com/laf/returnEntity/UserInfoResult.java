package com.laf.returnEntity;

public class UserInfoResult extends UserSummaryResult {

	/**
	 * 发现数量
	 */
	private Integer foundsCount;
	/**
	 * 头像图片
	 */
	private Integer lostsCount;

	public UserInfoResult() {
		// TODO Auto-generated constructor stub
	}

	public UserInfoResult(Integer uid, String nickname, String realname, String email,
			String telephone, String headImgUrl, Integer foundsCount,
			Integer lostsCount) {
		super(uid, nickname, realname, email, telephone, headImgUrl);
		
		this.foundsCount = foundsCount;
		this.lostsCount = lostsCount;
	}

	public Integer getFoundsCount() {
		return foundsCount;
	}

	public void setFoundsCount(Integer foundsCount) {
		this.foundsCount = foundsCount;
	}

	public Integer getLostsCount() {
		return lostsCount;
	}

	public void setLostsCount(Integer lostsCount) {
		this.lostsCount = lostsCount;
	}
	
}
