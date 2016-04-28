package com.laf.util;

import java.util.UUID;

import org.apache.commons.codec.binary.Base64;

public class UUIDUtil {

	public static String uuid() {
		UUID uuid = UUID.randomUUID();
		return toBase64UUID(uuid);
	}

	private static String toBase64UUID(UUID uuid) {
		byte[] byUuid = new byte[16];
		long least = uuid.getLeastSignificantBits();
		long most = uuid.getMostSignificantBits();
		long2bytes(most, byUuid, 0);
		long2bytes(least, byUuid, 8);
		String compressUUID = Base64.encodeBase64URLSafeString(byUuid);
		return compressUUID;
	}

	private static void long2bytes(long value, byte[] bytes, int offset) {
		for (int i = 7; i > -1; i--) {
			bytes[offset++] = (byte) ((value >> 8 * i) & 0xFF);
		}
	}

	@SuppressWarnings("unused")
	private static long bytes2long(byte[] bytes, int offset) {
		long value = 0;
		for (int i = 7; i > -1; i--) {
			value |= (((long) bytes[offset++]) & 0xFF) << 8 * i;
		}
		return value;
	}
	
	public static String randomShortUUID() {  
	    UUID uuid = UUID.randomUUID();  
	    StringBuilder sb = new StringBuilder();  
	    sb.append(digits(uuid.getMostSignificantBits() >> 32, 8));  
	    sb.append(digits(uuid.getMostSignificantBits() >> 16, 4));  
	    sb.append(digits(uuid.getMostSignificantBits(), 4));  
	    sb.append(digits(uuid.getLeastSignificantBits() >> 48, 4));  
	    sb.append(digits(uuid.getLeastSignificantBits(), 12));  
	    return sb.toString();  
	}  
	
	private static String digits(long val, int digits) {  
	    long hi = 1L << (digits * 4);  
	    return Numbers.toString(hi | (val & (hi - 1)), Numbers.MAX_RADIX)  
	            .substring(1);  
	}
}
