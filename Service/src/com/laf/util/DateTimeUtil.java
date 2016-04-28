package com.laf.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.laf.common.enums.ResponseCodes;
import com.laf.common.exception.SystemException;

/**
 * 时间格式化
 * 
 * @author tangbiao
 *
 */
public class DateTimeUtil {
	
	 /** 年月日时分秒(无下划线) yyyyMMddHHmmss */
    public static final String dtLong                  = "yyyyMMddHHmmss";
    
    /** 完整时间 yyyy-MM-dd HH:mm:ss */
    public static final String simple                  = "yyyy-MM-dd HH:mm:ss";
    
    /** 年月日(无下划线) yyyyMMdd */
    public static final String dtShort                 = "yyyyMMdd";
    
    /**
     * 日期格式转换成字符串
	 * 格式：yyyy-MM-dd HH:mm:ss
	 * @return
	 */
	public static String format(Date date) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
				simple);
		if (date != null) {
			return simpleDateFormat.format(date);
		}
		return "";
	}
	
	/**
	 * 字符串转换成日期格式
	 * 格式：yyyy-MM-dd HH:mm:ss
	 * @param formatDate
	 * @return
	 * @throws ParseException
	 */
	public static Date parse(String formatDate) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
				simple);
		try {
			return simpleDateFormat.parse(formatDate);
		} catch (Exception e) {
			throw new SystemException(ResponseCodes.DateParseError, e);
		}
		
	}
	
	/**
	 * 字符串转换成日期格式
	 * 格式：yyyy-MM-dd
	 * @param formatDate
	 * @return
	 * @throws ParseException
	 */
	public static String parseShortDate(Date formatDate) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
				dtShort);
		try {
			return simpleDateFormat.format(formatDate);
		} catch (Exception e) {
			throw new SystemException(ResponseCodes.DateParseError, e);
		}
		
	}
	
}
