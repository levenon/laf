package com.laf.service.common;

import java.util.regex.Pattern;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.common.enums.PlatformType;
import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;
import com.laf.entity.SecretKey;
import com.laf.entity.VerifyCode;
import com.laf.middleResult.VerifyCodeMiddleResult;
import com.laf.middleResult.VerifyStatus;
import com.laf.service.BaseService;
import com.laf.util.mail.Captchas;
import com.laf.util.mail.MailSender;
import com.laf.util.mail.SendMail;
import com.laf.util.mobile.HttpSend;
import com.laf.util.mobile.MD5;
import com.laf.util.sms.spi.SmsVerifyKit;

@Service
public class VerifyCodeService extends BaseService {

	@Value("${sms.username}")
	private String username = "";
	@Value("${sms.password}")
	private String password = "";

	@Value("${sms.appKey}")
	private String smsAppKey = "";

	@Autowired
	SecretKeyService secretKeyService;

	public VerifyCode verifyCodeById(Integer id) {

		Object object = findById(VerifyCode.class, id);
		if (object != null && object instanceof VerifyCode) {
			return (VerifyCode) object;
		}
		return null;
	}

	public VerifyCode verifyCodeBy(String code, Integer secretKeyId) {

		Object object = findObjectByCondition("from VerifyCode where code = '" + code + "' and secretKeyId = " + secretKeyId + " and valid = " + DefaultCode.Code_True
				+ " and isDelete = " + DefaultCode.Code_Zero);
		if (object != null && object instanceof VerifyCode) {
			return (VerifyCode) object;
		}
		return null;
	}

	public VerifyCode addVerifyCode(String code, String account, PlatformType type, Boolean valid, Integer secretKeyId) {

		VerifyCode verifyCode = new VerifyCode();
		verifyCode.setCode(code);
		verifyCode.setValid(valid);
		verifyCode.setSecretKeyId(secretKeyId);
		verifyCode.setAccount(account);
		verifyCode.setType(type.value());

		save(verifyCode);

		return verifyCode;
	}

	public void removeVerifyCode(Integer id) {

		VerifyCode verifyCode = new VerifyCode();
		verifyCode.setId(id);

		delete(verifyCode);
	}

	public VerifyCode updateVerifyCode(Integer id, String code, Boolean valid, Integer secretKeyId) {

		VerifyCode verifyCode = verifyCodeById(id);

		if (verifyCode != null) {

			verifyCode.setCode(code);
			verifyCode.setValid(valid);
			verifyCode.setSecretKeyId(secretKeyId);

			update(verifyCode);
		}
		return verifyCode;
	}

	public VerifyCodeMiddleResult sendVerifyCode(PlatformType type, String account) {

		// 根据type判断类型
		String code = Captchas.getSixRandomString();

		if (PlatformType.Telephone == type) {

			Pattern p = Pattern.compile("^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$");
			if (p.matcher(account).matches()) {

				// 发送邮件
				SendMail sendMail = new SendMail();
				sendMail.setToAddress(account);
				sendMail.setFromAddress("308865427@qq.com");
				sendMail.setContent("您的验证码是：" + code);
				sendMail.setSubject("欢迎您注册得失！");

				MailSender sms = new MailSender();
				try {
					sms.sendTextMail(sendMail);
				} catch (Exception e) {
					throw new SystemException(ResponseCodes.ErrorSendMessage, e);
				}
			} else {
				throw new SystemException(ResponseCodes.ErrorMailAddress, null);
			}
		} else if (PlatformType.Email == type) {

			// 发送短信
			String pwdString = new MD5().Md5(password);
			HttpSend httpSend = new HttpSend(username, pwdString, account, code);
			try {
				httpSend.send();
			} catch (Exception e) {
				throw new SystemException(ResponseCodes.ErrorMailAddress, null);
			}
		} else {
			throw new SystemException(ResponseCodes.UnKnownError, null);
		}
		// 生成密钥
		SecretKey secretKey = secretKeyService.addSecretKey();
		// 记录验证码
		VerifyCode verifyCode = addVerifyCode(code, account, type, DefaultCode.Code_True, secretKey.getId());
		VerifyCodeMiddleResult verifyCodeMiddleResult = new VerifyCodeMiddleResult();
		verifyCodeMiddleResult.setSecret(secretKey.getSecret());
		verifyCodeMiddleResult.setVerifyCode(verifyCode);

		return verifyCodeMiddleResult;
	}

	public void invalidVerifyCode(VerifyCode verifyCode) {

		verifyCode.setValid(false);
		update(verifyCode);
	}

	public boolean verifyTelephoneCode(String telephone, String code, String zone) {

		SmsVerifyKit smsVerifyKit = new SmsVerifyKit(smsAppKey, telephone, zone, code);
		String result;
		try {
			result = smsVerifyKit.go();
			if (result != null) {
				int statusCode = JSONObject.fromObject(result).getInt("status");
				switch (statusCode) {
				case 200:
					return true;
				case 405: // AppKey为空
					throw new SystemException(ResponseCodes.ShareSDKAppKeyEmpty, null);
				case 406: // AppKey无效
					throw new SystemException(ResponseCodes.ShareSDKAppKeyInvalid, null);
				case 456: // 国家代码或手机号码为空
					throw new SystemException(ResponseCodes.ShareSDKZoneCodeOrTelephoneEmpty, null);
				case 457: // 手机号码格式错误
					throw new SystemException(ResponseCodes.ShareSDKTelephoneFormateError, null);
				case 466: // 请求校验的验证码为空
					throw new SystemException(ResponseCodes.ShareSDKVerifyCodeEmpty, null);
				case 467: // 请求校验验证码频繁（5分钟内同一个appkey的同一个号码最多只能校验三次）
					throw new SystemException(ResponseCodes.ShareSDKRequestFrequently, null);
				case 468: // 验证码错误
					throw new SystemException(ResponseCodes.ShareSDKVerifyCodeError, null);
				case 474: // 没有打开服务端验证开关
					throw new SystemException(ResponseCodes.ShareSDKServerUnopen, null);
				default:
					throw new SystemException(ResponseCodes.UnKnownError, null);
				}
			} else {
				throw new SystemException(ResponseCodes.VerifyCodeIncerrect, null);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			throw new SystemException(ResponseCodes.VerifyCodeIncerrect, e);
		}
	}

	public VerifyStatus matchVerifyCode(PlatformType platformType, String account, String zone, String code, String secret) {

		VerifyStatus verifyStatus = new VerifyStatus();
		if (platformType == PlatformType.Email) {
			// 校验秘钥
			SecretKey secretKey = secretKeyService.secretKeyBySecret(secret);
			if (secretKey != null) {
				// 校验验证码
				VerifyCode verifyCode = verifyCodeBy(code, secretKey.getId());
				if (verifyCode != null) {
					verifyStatus.setStatus(true);
					verifyStatus.setVerifyCode(verifyCode);
				}
			}
		} else if (platformType == PlatformType.Telephone) {

//			 verifyStatus.setStatus(true);
			boolean status = verifyTelephoneCode(account, code, zone);
			verifyStatus.setStatus(status);
		}
		return verifyStatus;
	}
}
