package com.fileserver.common.enums;

import org.apache.commons.lang3.StringUtils;

/**
 * 返回码
 * @author tangbiao
 *
 */
public enum ResponseCodes {
	
	Success("200", "操作成功"),
	UnKnownError("500", "服务器发生异常，请重试"),
	
	// match
	TypeMismatchAccessError("10", "类型不匹配异常"),
	ImageTypeWrong("11", "上传的图片格式不对！"),
	VideoTypeWrong("12", "上传的视频格式不对！"),
	AudioTypeWrong("13", "上传的音频格式不对！"),
	ReadWriteWrong("14", "数据写入失败"),
	UnsupportedEncodingWrong("15", "数据格式错误"),
	SpringWrong("16", "Spring抛出异常"),
	ErrDateParse("17","日期格式不正确"),
	ErrorSecretKey("18", "密钥验证错误"),
	
	// access
	IllegalVisit("10001", "访问无效"),
	IllegalArgument("10002", "参数缺失或者不完整"),
	NotPermissions("10003", "无权限访问"),
	LoginExpired("10004", "登录已过期"),
	UnRegist("10005", "未注册"),
	FailOperDB("10006","数据库操作失败"),
	ErrorMD5Create("10007", "MD5创建失败"),
	LoginFailed("10008", "登录失败"),
	AuthorizeFailed("10009", "授权失败"),
	DiabledInterface("10010", "接口不可用"),
	LoginInvalid("10011", "登录已失效"),
	
	//service
	MatchInterWrong("11000", "接口未找到"),
	UnsupportedEncoding("11001","编码格式不支持"),
	DataAccessWrong("11002","查询用户信息失败"),
	FailQueryDB("11003","数据库查询失败"),
	FailSaveDB("11004","数据保存失败,请重试"),
	FailDelDB("11005","数据删除失败,请重试"),
	FailUpdDB("11006","数据更新失败,请重试"),
	FailDelAllDB("11007","数据批量删除失败,请重试"),
    ErrorServiceComponentNoExist("11008", "服务域不存在"),
		
	//文件
	FileNotExist("20004", "文件不存在"),
	ErrFileCommunication("20006", "文件通讯失败"),
	ErrSaveRemoteFile("20007", "远程文件信息保存失败"),
	ImageNotExist("20008", "图片不存在"),
	ImageIdNotBeEmpty("20009", "图片ID不可以为空");	
	
	/**
	 * 返回码
	 */
	private String code;
	
	/**
	 * 返回码说明
	 */
	private String message;
	
	ResponseCodes(String code, String message) {
		this.code = code;
		this.message = message;
	}
	
	/**
	 * 通过code获取对应的ResponseCodes
	 * @param code 错误码
	 * @return 响应码对应的ResponseCodes枚举
	 */
	public static ResponseCodes getResponseByCode(String code){
		if(StringUtils.isEmpty(code)){
			throw new NullPointerException("响应编码为空");
		}
		
		for(ResponseCodes responseCode : ResponseCodes.values()){
			if(responseCode.getCode().equals(code)){
				return responseCode;
			}
		}
		
		throw new IllegalArgumentException("未能找到匹配的ResponseCodes:" + code);
	}
	
	/**
	 * 获取响应编码
	 * @return
	 */
	public String getCode(){
		return this.code;
	}
	
	/**
	 * 获取编码对应消息
	 * @return
	 */
	public String getMessage(){
		return this.message;
	}
}
