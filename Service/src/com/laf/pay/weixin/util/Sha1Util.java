package com.laf.pay.weixin.util;

import java.security.MessageDigest;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

/**
 * 
 * @author tangbiao
 *
 */
public class Sha1Util {
    public static String getSha1(String str) {
        if (str == null || str.length() == 0) {
            return null;
        }
        char hexDigits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                'a', 'b', 'c', 'd', 'e', 'f'};
        try {
            MessageDigest mdTemp = MessageDigest.getInstance("SHA1");
            mdTemp.update(str.getBytes());

            byte[] md = mdTemp.digest();
            int j = md.length;
            char buf[] = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                buf[k++] = hexDigits[byte0 >>> 4 & 0xf];
                buf[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(buf);
        } catch (Exception e) {
            return null;
        }
    }

    public static String createSHA1Sign(Map<String, String> es) {
        Iterator<Map.Entry<String, String>> iterator = es.entrySet().iterator();
        Set<String> sortSet = new TreeSet<String>();
        while (iterator.hasNext()) {
            Map.Entry<String, String> entity = iterator.next();
            sortSet.add(entity.getKey() + "=" + entity.getValue());
        }

        StringBuffer sb = new StringBuffer();
        Iterator<String> setIterator = sortSet.iterator();
        while (setIterator.hasNext()) {
            String item = setIterator.next();
            sb.append(item);
            if (setIterator.hasNext()) {
                sb.append("&");
            }
        }
        String appsign = Sha1Util.getSha1(sb.toString());
        return appsign;
    }

}
