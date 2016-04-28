package com.laf.common.enums;

import org.apache.commons.lang3.StringUtils;

/**
 * 返回码
 * 
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
	DateParseError("17", "日期格式不正确"), 
	SecretKeyError("18", "密钥验证错误"),
	TimestampParseError("19", "时间戳不正确"), 

	// access
	IllegalVisit("10001", "访问无效"), 
	IllegalArgument("10002", "参数缺失或者不完整"), 
	NotPermissions("10003", "无权限访问"), 
	LoginExpired("10004", "登录已过期"), 
	UnRegist("10005", "未注册"), 
	FailOperDB("10006", "数据库操作失败"), 
	ErrorMD5Create("10007", "MD5创建失败"), 
	LoginFailed("10008", "登录失败"), 
	AuthorizeFailed("10009", "授权失败"), 
	DiabledInterface("10010", "接口不可用"), 
	LoginInvalid("10011", "登录已失效"),
	Unlogin("10012", "未登录"),
	InterfaceNoExist("10013", "接口未定义"),
	InterfaceLinkError("10014", "接口连接错误"), 

	// service
	MatchInterWrong("11000", "接口未找到"), 
	UnsupportedEncoding("11001", "编码格式不支持"), 
	DataAccessWrong("11002", "查询用户信息失败"), 
	FailQueryDB("11003", "数据库查询失败"), 
	FailSaveDB("11004", "数据保存失败,请重试"), 
	FailDelDB("11005", "数据删除失败,请重试"), 
	FailUpdDB("11006", "数据更新失败,请重试"), 
	FailDelAllDB("11007", "数据批量删除失败,请重试"), 
	ErrorServiceComponentNoExist("11008", "服务域不存在"),

	// user
	UserNotExist("12000", "用户不存在"), 
	UserExist("12001", "用户已存在"), 
	ErrorIntegral("12003", "积分不足，请及时充值"), 
	AccessUserInfoFailed("12004", "获取用户信息失败"),
	UserNameCannotBeEmpty("12005", "用户名不可以为空"), 
	PasswordCannotBeEmpty("12006", "密码不可以为空"), 
	EmailCannotBeEmpty("12007", "邮箱不可以为空"),
	UsernameHasRegister("12008", "用户名已注册"), 
	TelephoneHasRegister("12009", "手机号已注册"), 
	EmailHasRegister("12010", "邮箱已注册"), 
	TelephoneCannotBeEmpty("12011", "手机号不可以为空"), 
	PasswordIncorrect("12012", "密码不正确"), 
	OldPasswordIncorrect("12013", "原密码不正确"),

	// register
	MoreRegisters("14000", "注册记录不唯一"), 
	TelephoneOrEmailExist("14001", "手机号/邮箱已存在"), 
	ErrorSecretOrCodeIsNotVerify("14002", "密钥匹配失败/验证码过期"), 
	ErrorPlatformType("14003", "错误的平台类型"), 
	VerifyCodeIncerrect("14004", "验证码不正确"), 
	RegisterFailed("14005", "注册失败"),
	TelephoneExist("14006", "手机号已存在"), 
	AccountNotExist("14007", "账号不存在"), 

	// 充值
	ErrorPrice("15001", "充值面额不正确"),

	// 支付
	WeixTokenErroe("16001", "微信支付获取token发生异常"), 
	WeixPreIDErroe("16002", "微信支付预支付获取prepayId发生异常"), 
	EmptyPlatform("16007", "支付平台不存在"), 
	ErrorAliPayParams("16008", "支付宝参数错误"),

	// 远程文件
	FailInvokeRemote("17000", "调用远程服务失败"), 
	FailCommunication("17001", "通讯失败"),

	// 发送短信和邮箱
	ErrorSendMessage("18000", "发送失败"), 
	ErrorMailAddress("18001", "邮箱格式不正确"), 
	ErrorTelePhoneNumber("18002", "手机号码格式不正确"), 
	ErrorMailOrTelePhone("18003", "邮箱或手机号码格式不正确"), 
	ErrorUsername("18003", "用户名必须是英文和数字的组合"),

	// role
	RoleUnknown("19000", "未知角色"), 
	RoleNotFound("19001", "角色未找到"),

	// 关注
	ErrorConcerStateParamIncomplete("20000", "关注状态参数不完整"),

	// 反馈
	FeedbackFailed("21000", "反馈失败"),

	// 分类
	CategoryNotExsits("22000", "分类不存在"),

	// 公告
	NoticeNotExsits("21000", "公告不存在"),

	// 寻物启事
	LostNotExsits("22000", "寻物启事不存在"),

	// 寻物启事
	FounsNotExsits("23000", "失物招领不存在"),

	// 文件
	FileUploadFailed("24000", "文件上传失败"),

	// ShareSDK
	ShareSDKAppKeyEmpty("25000", "AppKey为空"), 
	ShareSDKAppKeyInvalid("25001", "AppKey无效"), 
	ShareSDKZoneCodeOrTelephoneEmpty("25002", "国家代码或手机号码为空"), 
	ShareSDKTelephoneFormateError("25003", "手机号码格式错误"), 
	ShareSDKVerifyCodeEmpty("25004", "请求校验的验证码为空"), 
	ShareSDKRequestFrequently("25005", "请求校验验证码频繁"), 
	ShareSDKVerifyCodeError("25006", "验证码错误"), 
	ShareSDKServerUnopen("25007", "没有打开服务端验证开关");

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
	 * 
	 * @param code
	 *            错误码
	 * @return 响应码对应的ResponseCodes枚举
	 */
	public static ResponseCodes getResponseByCode(String code) {
		if (StringUtils.isEmpty(code)) {
			throw new NullPointerException("响应编码为空");
		}

		for (ResponseCodes responseCode : ResponseCodes.values()) {
			if (responseCode.getCode().equals(code)) {
				return responseCode;
			}
		}

		throw new IllegalArgumentException("未能找到匹配的ResponseCodes:" + code);
	}

	/**
	 * 获取响应编码
	 * 
	 * @return
	 */
	public String getCode() {
		return this.code;
	}

	/**
	 * 获取编码对应消息
	 * 
	 * @return
	 */
	public String getMessage() {
		return this.message;
	}
}
