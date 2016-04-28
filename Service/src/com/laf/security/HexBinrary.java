package com.laf.security;

public class HexBinrary {
	private static int hexToBin(char ch) {
		if (('0' <= ch) && (ch <= '9'))
			return ch - '0';
		if (('A' <= ch) && (ch <= 'F'))
			return ch - 'A' + 10;
		if (('a' <= ch) && (ch <= 'f')) {
			return ch - 'a' + 10;
		}
		return -1;
	}

	public static byte[] decodeHexBinrary(String s) {
		int len = s.length();
		if (len % 2 != 0)
			return null;
		byte[] out = new byte[len / 2];
		for (int i = 0; i < len; i += 2) {
			int h = hexToBin(s.charAt(i));
			int l = hexToBin(s.charAt(i + 1));
			if ((h == -1) || (l == -1))
				return null;
			out[(i / 2)] = (byte) (h * 16 + l);
		}

		return out;
	}

	private static char encode(int ch) {
		ch &= 15;
		if (ch < 10) {
			return (char) (48 + ch);
		}
		return (char) (65 + (ch - 10));
	}

	public static String encodeHexBinrary(byte[] data) {
		StringBuffer r = new StringBuffer(data.length * 2);
		for (int i = 0; i < data.length; i++) {
			r.append(encode(data[i] >> 4));
			r.append(encode(data[i] & 0xF));
		}

		return r.toString();
	}
}
