package com.laf.pay.weixin;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 
 * @author tangbiao
 *
 */
public class WeixPayResponse {
    private String accessToken;

    private String expiresIn;

    private String errcode;

    private String errmsg;

    private String prepayid;
    
    private String nonceStr;
    
    private String timestamp;
    
    private String sign;

    public String getAccessToken() {
        return accessToken;
    }

    @JsonProperty("access_token")
    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getExpiresIn() {
        return expiresIn;
    }

    @JsonProperty("expires_in")
    public void setExpiresIn(String expiresIn) {
        this.expiresIn = expiresIn;
    }

    public String getErrcode() {
        return errcode;
    }

    @JsonProperty("errcode")
    public void setErrcode(String errcode) {
        this.errcode = errcode;
    }

    public String getErrmsg() {
        return errmsg;
    }

    @JsonProperty("errmsg")
    public void setErrmsg(String errmsg) {
        this.errmsg = errmsg;
    }

	public String getPrepayid() {
		return prepayid;
	}

	public void setPrepayid(String prepayid) {
		this.prepayid = prepayid;
	}

	public String getNonceStr() {
		return nonceStr;
	}

	public void setNonceStr(String nonceStr) {
		this.nonceStr = nonceStr;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}

	public String getSign() {
		return sign;
	}

	public void setSign(String sign) {
		this.sign = sign;
	}
}
